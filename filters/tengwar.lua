-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Writes Quenya in Tengwar. In a .qmd file:
--
--     [namárië]{.tengwar}
--
-- The span's Latin text is replaced by Tengwar (classical Quenya mode, Free
-- Tengwar code points for fonts/AlcarinTengwar-Regular.woff2) and keeps the
-- class "tengwar", so styles.scss can set the font.
--   * HTML and EPUB: the span also gets lang="qya-Teng", and the Latin text as
--     title (shown on hover) and aria-label with role="img" (read by screen
--     readers instead of the Private Use Area characters).
--   * LaTeX/PDF: the Tengwar is written as {\tengwarfont ...}; the header
--     defines \tengwarfont.
--
-- Optional metadata (_quarto.yml or front matter):
--
--     tengwar:
--       s-hook: mark        # mark (default) | spacing | silme
--       punctuation: unicode  # unicode (default) | legacy
--
-- In a reading exercise, add the class "no-title" so that pointing at the
-- word does not show its Latin spelling: [minë]{.tengwar .no-title}
--
-- To show one letter on its own, name it with the class "tengwa":
--
--     [rómen]{.tengwa}
--
-- The transcription itself is in tengwar/quenya.lua next to this file.

local function script_dir()
  local src = debug.getinfo(1, "S").source
  local path = (src:sub(1, 1) == "@") and src:sub(2) or PANDOC_SCRIPT_FILE
  return (path and path:match("^(.*[/\\])")) or "./"
end

package.path = script_dir() .. "?.lua;" .. package.path
local quenya = require("tengwar.quenya")

local opts = {}

-- Characters with no Tengwar (digits, symbols) pass through; these must be
-- escaped inside the raw LaTeX.
local LATEX_ESCAPE = {
  ["\\"] = "\\textbackslash{}", ["{"] = "\\{", ["}"] = "\\}", ["$"] = "\\$",
  ["&"] = "\\&", ["#"] = "\\#", ["^"] = "\\textasciicircum{}", ["_"] = "\\_",
  ["%"] = "\\%", ["~"] = "\\textasciitilde{}",
}

local function is_html()
  return FORMAT:match("html") or FORMAT:match("epub") or FORMAT:match("revealjs")
end

local function is_latex()
  return FORMAT:match("latex") or FORMAT:match("beamer")
end

local function warn(msg)
  if quarto and quarto.log and quarto.log.warning then
    quarto.log.warning(msg)
  elseif pandoc.log and pandoc.log.warn then
    pandoc.log.warn(msg)
  else
    io.stderr:write("[tengwar] " .. msg .. "\n")
  end
end

local function read_meta(meta)
  local m = meta.tengwar
  if type(m) ~= "table" then return nil end
  if m["s-hook"] ~= nil then opts.s_hook = pandoc.utils.stringify(m["s-hook"]) end
  if m.punctuation ~= nil then opts.punctuation = pandoc.utils.stringify(m.punctuation) end
  return nil
end

local function tengwar_span(span)
  local latin, result
  if span.classes:includes("tengwa") then
    latin = pandoc.utils.stringify(span.content)
    local letter = quenya.letter(latin)
    if letter == nil then
      warn(string.format("tengwar: [%s]{.tengwa}: no tengwa has this name", latin))
      return nil
    end
    result = { text = letter }
    span.classes = span.classes:filter(function (c) return c ~= "tengwa" end)
    span.classes:insert("tengwar")
  elseif span.classes:includes("tengwar") then
    latin = pandoc.utils.stringify(span.content)
    result = quenya.analyse(latin, opts)
    for _, w in ipairs(result.warnings) do
      warn(string.format("tengwar: [%s]{.tengwar}: %s: %s", latin, w.word, w.message))
    end
  else
    return nil
  end

  if is_latex() then
    local tex = result.text:gsub("[\\{}$&#^_%%~]", LATEX_ESCAPE)
    return pandoc.RawInline("latex", "{\\tengwarfont " .. tex .. "}")
  end

  -- In reading exercises the class "no-title" keeps the Latin out of the
  -- hover text; screen readers still get it through aria-label.
  local hover = not span.classes:includes("no-title")
  span.classes = span.classes:filter(function (c) return c ~= "no-title" end)
  span.content = { pandoc.Str(result.text) }
  if is_html() then
    span.attributes["lang"] = "qya-Teng"
    if hover then span.attributes["title"] = latin end
    span.attributes["aria-label"] = latin
    span.attributes["role"] = "img"
  end
  return span
end

return {
  { Meta = read_meta },
  { Span = tengwar_span },
}
