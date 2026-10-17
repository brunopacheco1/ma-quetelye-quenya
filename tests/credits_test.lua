-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Tests for filters/credits/contributors.lua and the {{< contributors >}}
-- shortcode in filters/credits.lua, and checks that CONTRIBUTORS.md and every
-- edition agree, so the credits page can be built.
--
-- Run with Quarto's bundled Pandoc as the Lua interpreter:
--
--     quarto pandoc lua tests/credits_test.lua

local function here()
  local src = debug.getinfo(1, "S").source
  local path = (src:sub(1, 1) == "@") and src:sub(2) or (arg and arg[0]) or ""
  return path:match("^(.*[/\\])") or "./"
end

local ROOT = here() .. "../"
local FILTERS = ROOT .. "filters/"
package.path = FILTERS .. "?.lua;" .. package.path
local contributors = require("credits.contributors")

local stringify = pandoc.utils.stringify

local passed, failed = 0, 0

local function check(label, ok, detail)
  if ok then
    passed = passed + 1
  else
    failed = failed + 1
    print("FAIL  " .. label .. (detail and ("\n      " .. detail) or ""))
  end
end

local function read_file(path)
  local file = io.open(path, "r")
  if not file then return nil end
  local text = file:read("a")
  file:close()
  return text
end

local function names_of(group)
  local names = {}
  for _, name in ipairs(group.names) do names[#names + 1] = stringify(name) end
  return table.concat(names, ", ")
end

local function labels_of(groups)
  local labels = {}
  for _, group in ipairs(groups) do labels[#labels + 1] = group.label end
  return table.concat(labels, " | ")
end

---------------------------------------------------------------------------
-- Parsing and grouping, on a made-up list
---------------------------------------------------------------------------

print("== parsing")

local FIXTURE = [[
<!--
SPDX-FileCopyrightText: 2026 Example

SPDX-License-Identifier: CC-BY-4.0
-->

# Contributors

Roles: coordinator, author, Quenya review, translation,
voice.

| Name | Roles | Chapters or editions |
|---|---|---|
| Ana Lima ([@ana](https://github.com/ana)) | author,  quenya REVIEW | chapter 2 |
| Bo | translation, author, translation | pt |
|  | voice | |
| Cy | voice, dance | chapter 1 |

## Tools

Roles: this paragraph comes after the first one and is ignored.

| Name | Roles |
|---|---|
| Di | voice |
]]

local doc = contributors.read(FIXTURE)
local roles = contributors.role_list(doc)
check("role list", roles ~= nil and table.concat(roles, "|") == "coordinator|author|Quenya review|translation|voice",
  "got " .. (roles and table.concat(roles, "|") or "nil"))

local people = contributors.people(doc)
check("people: rows with a name, from every table", people ~= nil and #people == 4,
  "got " .. (people and #people or "nil"))
check("people: name keeps its link", people ~= nil and stringify(people[1].name) == "Ana Lima (@ana)"
  and #people[1].name:filter(function (el) return el.t == "Link" end) == 1,
  "got " .. (people and stringify(people[1].name) or "nil"))
check("people: a handle is not a citation", people ~= nil
  and #people[1].name:filter(function (el) return el.t == "Cite" end) == 0)
check("people: roles split and trimmed", people ~= nil
  and table.concat(people[1].roles, "|") == "author|quenya REVIEW",
  "got " .. (people and table.concat(people[1].roles, "|") or "nil"))

local ORDER = {
  {role = "coordinator", label = "Coordination"},
  {role = "author", label = "Writing"},
  {role = "Quenya  review", label = "Quenya review"},
  {role = "translation", label = "Translation"},
  {role = "voice", label = "Voices"},
}
local groups, unknown = contributors.group(people, ORDER)
check("groups: in the given order, empty ones left out, unknown roles last",
  labels_of(groups) == "Writing | Quenya review | Translation | Voices | dance",
  "got " .. labels_of(groups))
check("groups: people in table order", names_of(groups[1]) == "Ana Lima (@ana), Bo",
  "got " .. names_of(groups[1]))
check("groups: case and spaces ignored", names_of(groups[2]) == "Ana Lima (@ana)",
  "got " .. names_of(groups[2]))
check("groups: a role repeated on one row counts once", names_of(groups[3]) == "Bo",
  "got " .. names_of(groups[3]))
check("groups: rows of a later table follow", names_of(groups[4]) == "Cy, Di",
  "got " .. names_of(groups[4]))
check("groups: unknown roles reported", #unknown == 1 and unknown[1] == "dance",
  "got " .. table.concat(unknown, "|"))

local no_order = contributors.group(people, {})
check("groups: no order shows the roles as written", labels_of(no_order)
  == "author | quenya REVIEW | translation | voice | dance", "got " .. labels_of(no_order))

local _, missing_roles = contributors.role_list(contributors.read("# Contributors\n"))
check("role list: missing", missing_roles ~= nil)
local _, missing_table = contributors.people(contributors.read("| A | B |\n|---|---|\n| x | y |\n"))
check("people: a table without Name and Roles is not used", missing_table ~= nil)

---------------------------------------------------------------------------
-- The definition list
---------------------------------------------------------------------------

print("== output")

local list = contributors.definition_list(groups)
check("definition list", list.t == "DefinitionList" and #list.content == 5,
  "got " .. list.t .. " with " .. #list.content .. " items")

local html = pandoc.write(pandoc.Pandoc({list}), "html5", {wrap_text = "wrap-none"})
check("html", html:find("<dt>Writing</dt>", 1, true) ~= nil
  and html:find('<dd>%s*Ana Lima %(<a href="https://github.com/ana">@ana</a>%), Bo%s*</dd>') ~= nil,
  "got " .. html)

local latex = pandoc.write(pandoc.Pandoc({list}), "latex", {wrap_text = "wrap-none"})
check("latex", latex:find("\\begin{description}", 1, true) ~= nil
  and latex:find("\\item[Quenya review]", 1, true) ~= nil, "got " .. latex)

---------------------------------------------------------------------------
-- The repository: CONTRIBUTORS.md, every edition, the shortcode
---------------------------------------------------------------------------

print("== repository")

local source = read_file(ROOT .. "CONTRIBUTORS.md")
check("CONTRIBUTORS.md exists", source ~= nil)
source = source or ""
local repo_doc = contributors.read(source)
local repo_roles, roles_err = contributors.role_list(repo_doc)
check("CONTRIBUTORS.md: role list", repo_roles ~= nil and #repo_roles > 0, roles_err)
repo_roles = repo_roles or {}
local repo_people, people_err = contributors.people(repo_doc)
check("CONTRIBUTORS.md: table of people", repo_people ~= nil and #repo_people > 0, people_err)
repo_people = repo_people or {}

local known = {}
for _, role in ipairs(repo_roles) do known[contributors.key(role)] = true end
for _, person in ipairs(repo_people) do
  check("CONTRIBUTORS.md: " .. stringify(person.name) .. " has a role", #person.roles > 0)
  for _, role in ipairs(person.roles) do
    check("CONTRIBUTORS.md: " .. stringify(person.name) .. ', role "' .. role .. '"',
      known[contributors.key(role)] == true,
      "use the roles of the list above the table: " .. table.concat(repo_roles, ", "))
  end
end

local function profile_meta(text)
  return pandoc.read("---\n" .. text .. "\n---\n", "markdown").meta
end

local function lists_chapter(meta, path)
  local chapters = meta.book and meta.book.chapters
  if type(chapters) ~= "table" then return false end
  for _, chapter in ipairs(chapters) do
    if stringify(chapter) == path then return true end
  end
  return false
end

local shortcode = dofile(FILTERS .. "credits.lua")["contributors"]

local editions = {}
for _, name in ipairs(pandoc.system.list_directory(ROOT)) do
  local lang = name:match("^_quarto%-(.+)%.yml$")
  if lang then editions[#editions + 1] = lang end
end
table.sort(editions)
check("editions found", #editions > 0)

for _, lang in ipairs(editions) do
  local profile = "_quarto-" .. lang .. ".yml"
  local meta = profile_meta(read_file(ROOT .. profile) or "")
  local order = meta["credits-roles"]
  check(profile .. ": credits-roles", type(order) == "table" and #order > 0)
  order = type(order) == "table" and order or {}

  local keys, labels, seen, edition_order = {}, {}, {}, {}
  for _, entry in ipairs(order) do
    local role = entry.role and stringify(entry.role) or ""
    local label = entry.label and stringify(entry.label) or ""
    keys[#keys + 1] = contributors.key(role)
    edition_order[#edition_order + 1] = {role = role, label = label}
    check(profile .. ': label for "' .. role .. '"', label ~= "" and not seen[label],
      "every role needs its own label in the edition's language")
    seen[label] = true
    labels[#labels + 1] = label
  end
  local expected = {}
  for _, role in ipairs(repo_roles) do expected[#expected + 1] = contributors.key(role) end
  check(profile .. ": credits-roles has the roles of CONTRIBUTORS.md, in its order",
    table.concat(keys, "|") == table.concat(expected, "|"),
    "expected " .. table.concat(expected, ", ") .. "\n      got      " .. table.concat(keys, ", "))

  local page = "docs/" .. lang .. "/credits.qmd"
  check(profile .. ": lists " .. page, lists_chapter(meta, page))
  check(page .. " uses the shortcode", (read_file(ROOT .. page) or ""):find("{{< contributors >}}", 1, true) ~= nil)

  local saved_quarto, warnings = quarto, {}
  quarto = {log = {warning = function (msg) warnings[#warnings + 1] = msg end}}
  local ok, blocks = pcall(shortcode, {}, {}, meta)
  quarto = saved_quarto
  check(profile .. ": shortcode runs", ok, tostring(blocks))
  check(profile .. ": shortcode gives no warning", #warnings == 0, table.concat(warnings, " | "))
  if ok then
    local div = blocks[1]
    check(profile .. ": shortcode output is in the search index", div ~= nil and div.t == "Div"
      and div.classes:includes("quarto-include-in-search-index"))
    local terms = {}
    pandoc.Pandoc(blocks):walk({
      DefinitionList = function (dl)
        for _, item in ipairs(dl.content) do terms[#terms + 1] = stringify(item[1]) end
      end,
    })
    local expected_groups = contributors.group(repo_people, edition_order)
    check(profile .. ": shortcode shows the edition's labels in its order",
      table.concat(terms, " | ") == labels_of(expected_groups),
      "expected " .. labels_of(expected_groups) .. "\n      got      " .. table.concat(terms, " | "))
    local out = pandoc.write(pandoc.Pandoc(blocks), "plain", {wrap_text = "wrap-none"})
    local first = repo_people[1]
    check(profile .. ": shortcode names the first person",
      first ~= nil and out:find(stringify(first.name), 1, true) ~= nil, "got " .. out)
  end
end

print(("\n%d passed, %d failed"):format(passed, failed))
if failed > 0 then os.exit(1) end
