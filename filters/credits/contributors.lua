-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Reads CONTRIBUTORS.md and groups its people by role, for the credits page of
-- every edition (filters/credits.lua). Only Pandoc's Lua API is used, so
-- tests/credits_test.lua can run it with `quarto pandoc lua`.
--
-- CONTRIBUTORS.md must keep two things:
--   * a paragraph "Roles: a, b, c." that lists every role, in the order the
--     credits page shows them;
--   * a table whose first two columns are "Name" and "Roles", one person per
--     row, roles written as in that list and separated by commas. If there
--     are several such tables, their rows are read in order, as one list.

local M = {}

local stringify = pandoc.utils.stringify

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Splits "a, b,c" into {"a", "b", "c"}, dropping empty items.
local function split_list(s)
  local items = {}
  for item in s:gmatch("[^,]+") do
    item = trim(item)
    if item ~= "" then items[#items + 1] = item end
  end
  return items
end

-- Roles are matched without regard to case or repeated spaces.
function M.key(role)
  return trim(role):gsub("%s+", " "):lower()
end

-- Parses the text of CONTRIBUTORS.md. GitHub-flavoured Markdown, so a handle
-- such as [@name](url) stays a link and is never read as a citation.
function M.read(text)
  return pandoc.read(text, "gfm")
end

-- The roles listed in the "Roles:" paragraph, in order.
function M.role_list(doc)
  for _, block in ipairs(doc.blocks) do
    if block.t == "Para" or block.t == "Plain" then
      local text = stringify(block)
      local list = text:match("^%s*Roles:%s*(.-)%s*$")
      if list then return split_list((list:gsub("%.$", ""))) end
    end
  end
  return nil, 'no "Roles:" paragraph'
end

local function cell_inlines(cell)
  local inlines = pandoc.Inlines({})
  for i, block in ipairs(cell.contents) do
    if block.content and (block.t == "Plain" or block.t == "Para") then
      if i > 1 then inlines:insert(pandoc.Space()) end
      inlines:extend(block.content)
    end
  end
  return inlines
end

local function is_people_table(tbl)
  local head = tbl.head.rows[1]
  if not head or #head.cells < 2 then return false end
  return M.key(stringify(head.cells[1].contents)) == "name"
     and M.key(stringify(head.cells[2].contents)) == "roles"
end

-- The people of every "Name | Roles | ..." table, in order:
-- { {name = Inlines, roles = {"coordinator", ...}}, ... }
function M.people(doc)
  local people, found = {}, false
  for _, block in ipairs(doc.blocks) do
    if block.t == "Table" and is_people_table(block) then
      found = true
      for _, body in ipairs(block.bodies) do
        for _, row in ipairs(body.body) do
          local name = cell_inlines(row.cells[1])
          if stringify(name) ~= "" then
            people[#people + 1] = {
              name = name,
              roles = split_list(stringify(row.cells[2].contents)),
            }
          end
        end
      end
    end
  end
  if not found then return nil, 'no table with the columns "Name" and "Roles"' end
  return people
end

-- Groups the people by role. `order` is a list of {role = ..., label = ...}:
-- the roles to show, in order, with their names in the edition's language.
-- Returns the groups that have people, {label = ..., names = {Inlines, ...}},
-- and the roles found in the table but missing from `order`, which get a
-- group of their own at the end, under the role as written.
function M.group(people, order)
  local groups, by_key, unknown = {}, {}, {}
  for _, entry in ipairs(order) do
    local key = M.key(entry.role)
    if not by_key[key] then
      local group = {label = entry.label, names = {}}
      groups[#groups + 1] = group
      by_key[key] = group
    end
  end
  for _, person in ipairs(people) do
    local seen = {}
    for _, role in ipairs(person.roles) do
      local key = M.key(role)
      if not seen[key] then
        seen[key] = true
        local group = by_key[key]
        if not group then
          group = {label = role, names = {}}
          groups[#groups + 1] = group
          by_key[key] = group
          unknown[#unknown + 1] = role
        end
        group.names[#group.names + 1] = person.name
      end
    end
  end
  local shown = {}
  for _, group in ipairs(groups) do
    if #group.names > 0 then shown[#shown + 1] = group end
  end
  return shown, unknown
end

-- The groups as a definition list: each role, then its people separated by
-- commas.
function M.definition_list(groups)
  local items = {}
  for _, group in ipairs(groups) do
    local names = pandoc.Inlines({})
    for i, name in ipairs(group.names) do
      if i > 1 then
        names:insert(pandoc.Str(","))
        names:insert(pandoc.Space())
      end
      names:extend(name)
    end
    items[#items + 1] = {
      pandoc.Inlines(group.label),
      {pandoc.Blocks({pandoc.Plain(names)})},
    }
  end
  return pandoc.DefinitionList(items)
end

return M
