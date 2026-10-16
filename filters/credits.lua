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
-- its _quarto-<lang>.yml. It is a list, so it also sets the order:
--
--     credits-roles:
--       - role: coordinator      # as written in CONTRIBUTORS.md
--         label: Coordination    # as shown in this edition
--
-- The output is a definition list: each role that has people, then their
-- names in the order of CONTRIBUTORS.md. A role missing from `credits-roles`
-- is shown under its name as written, with a warning;
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
    local file = io.open(SOURCE, "r")
    if not file then error("credits: cannot read " .. SOURCE) end
    local text = file:read("a")
    file:close()

    local people, err = contributors.people(contributors.read(text))
    if not people then error("credits: CONTRIBUTORS.md: " .. err) end

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
    return pandoc.Blocks({contributors.definition_list(groups)})
  end,
}
