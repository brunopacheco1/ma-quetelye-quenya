-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Shortcode that writes the list of contributors on the credits page of an
-- edition (docs/<lang>/credits.qmd):
--
--     {{< contributors >}}
--
-- The people and their roles come from the table in CONTRIBUTORS.md, the one
-- list of everyone who has helped, so the book never needs a second list.
-- Each edition names the roles in its own language with `credits-roles` in
-- its _quarto-<lang>.yml. It is a list, and the page follows its order, which
-- is the order of the "Roles:" list in CONTRIBUTORS.md (the test checks it):
--
--     credits-roles:
--       - role: coordinator      # as written in CONTRIBUTORS.md
--         label: Coordination    # as shown in this edition
--
-- The output is a definition list: each role that has people, then their
-- names in the order of CONTRIBUTORS.md. It sits in a div with the class
-- quarto-include-in-search-index, because the website's search otherwise
-- skips a list placed directly in the page. A role missing from
-- `credits-roles` is shown under its name as written, with a warning;
-- tests/credits_test.lua fails on it.
--
-- The parsing and grouping are in credits/contributors.lua next to this file.

local function script_dir()
  local src = debug.getinfo(1, "S").source
  local path = (src:sub(1, 1) == "@") and src:sub(2) or PANDOC_SCRIPT_FILE
  return (path and path:match("^(.*[/\\])")) or "./"
end

local DIR = script_dir()
package.path = DIR .. "?.lua;" .. package.path
local contributors = require("credits.contributors")

local SOURCE = DIR .. "../CONTRIBUTORS.md"

local function warn(msg)
  if quarto and quarto.log and quarto.log.warning then
    quarto.log.warning(msg)
  else
    io.stderr:write("[credits] " .. msg .. "\n")
  end
end

local function read_order(meta)
  local order = {}
  local list = meta["credits-roles"]
  if type(list) ~= "table" then return order end
  for _, entry in ipairs(list) do
    if type(entry) == "table" and entry.role ~= nil then
      local role = pandoc.utils.stringify(entry.role)
      local label = entry.label ~= nil and pandoc.utils.stringify(entry.label) or ""
      order[#order + 1] = {role = role, label = label ~= "" and label or role}
    end
  end
  return order
end

return {
  ["contributors"] = function(_args, _kwargs, meta)
    -- assert, not error: inside a shortcode Quarto's error() only logs, and
    -- the render would go on to fail on a nil value instead.
    local file = assert(io.open(SOURCE, "r"))
    local text = file:read("a")
    file:close()

    local people, err = contributors.people(contributors.read(text))
    assert(people, "credits: CONTRIBUTORS.md: " .. tostring(err))

    local order = read_order(meta)
    local groups, unknown = contributors.group(people, order)
    if #order == 0 then
      warn("credits: no credits-roles in this edition's profile; "
        .. "the roles are shown as written in CONTRIBUTORS.md")
    else
      for _, role in ipairs(unknown) do
        warn('credits: role "' .. role .. '" in CONTRIBUTORS.md is not in '
          .. "this edition's credits-roles")
      end
    end
    return pandoc.Blocks({
      pandoc.Div({contributors.definition_list(groups)},
        pandoc.Attr("", {"quarto-include-in-search-index"})),
    })
  end,
}
