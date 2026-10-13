-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Tests for filters/tengwar/quenya.lua and filters/tengwar.lua.
--
-- Run with Quarto's bundled Pandoc as the Lua interpreter:
--
--     quarto pandoc lua tests/tengwar_test.lua
--
-- Every expected value below was worked out by hand from the mode description
-- (specs/001-chapter-1/tengwar-mode.md), not produced by the code under test. Each case has
--   1. the Latin input,
--   2. the hand spelling in reading order ("tengwa+mark+mark", columns joined
--      by ", ", words by " / "), and
--   3. the hand code points ("/" stands for the space U+0020).
-- The test first checks that 2 and 3 agree, using its own name table below
-- (so a slip in either one is caught), then checks the transcriber's output
-- against 3 and its quenya.spell() against 2.

local function here()
  local src = debug.getinfo(1, "S").source
  local path = (src:sub(1, 1) == "@") and src:sub(2) or (arg and arg[0]) or ""
  return path:match("^(.*[/\\])") or "./"
end

local FILTERS = here() .. "../filters/"
package.path = FILTERS .. "?.lua;" .. package.path
local quenya = require("tengwar.quenya")

---------------------------------------------------------------------------
-- The test's own name -> code point table (mode description, section 1)
---------------------------------------------------------------------------

local CP = {
  ["tinco"] = 0xE000, ["parma"] = 0xE001, ["calma"] = 0xE002, ["quessë"] = 0xE003,
  ["ando"] = 0xE004, ["umbar"] = 0xE005, ["anga"] = 0xE006, ["ungwë"] = 0xE007,
  ["súlë"] = 0xE008, ["formen"] = 0xE009, ["harma"] = 0xE00A, ["hwesta"] = 0xE00B,
  ["anto"] = 0xE00C, ["ampa"] = 0xE00D, ["anca"] = 0xE00E, ["unquë"] = 0xE00F,
  ["númen"] = 0xE010, ["malta"] = 0xE011, ["noldo"] = 0xE012, ["nwalmë"] = 0xE013,
  ["óre"] = 0xE014, ["vala"] = 0xE015, ["anna"] = 0xE016, ["vilya"] = 0xE017,
  ["rómen"] = 0xE020, ["arda"] = 0xE021, ["lambe"] = 0xE022, ["alda"] = 0xE023,
  ["silmë"] = 0xE024, ["silmë nuquerna"] = 0xE025, ["essë"] = 0xE026,
  ["essë nuquerna"] = 0xE027, ["hyarmen"] = 0xE028, ["yanta"] = 0xE02A,
  ["úre"] = 0xE02B, ["long carrier"] = 0xE02C, ["halla"] = 0xE02D,
  ["short carrier"] = 0xE02E,
  -- marks
  ["a"] = 0xE040, ["e"] = 0xE046, ["i"] = 0xE044, ["o"] = 0xE04A, ["u"] = 0xE04C,
  ["y-dots"] = 0xE043, ["bar below"] = 0xE051, ["s-hook"] = 0xE059,
  -- punctuation
  ["pusta"] = 0x2E31, ["double pusta"] = 0x003A,
  ["exclamation mark"] = 0xE065, ["question mark"] = 0xE066,
}

local function split(s, sep)
  local t, start = {}, 1
  while true do
    local a, b = s:find(sep, start, true)
    if not a then t[#t + 1] = s:sub(start); return t end
    t[#t + 1] = s:sub(start, a - 1)
    start = b + 1
  end
end

-- hand spelling -> "E02E E040 / E010 ..."
local function spelling_to_hex(spelling)
  local words = {}
  for _, word in ipairs(split(spelling, " / ")) do
    local hex = {}
    for _, column in ipairs(split(word, ", ")) do
      for _, name in ipairs(split(column, "+")) do
        local cp = CP[name]
        if not cp then error("unknown name '" .. name .. "' in: " .. spelling) end
        hex[#hex + 1] = string.format("%04X", cp)
      end
    end
    words[#words + 1] = table.concat(hex, " ")
  end
  return table.concat(words, " / ")
end

-- transcriber output -> "E02E E040 / E010 ..."
local function string_to_hex(s)
  local t = {}
  for _, c in utf8.codes(s) do
    t[#t + 1] = (c == 0x20) and "/" or string.format("%04X", c)
  end
  return table.concat(t, " ")
end

---------------------------------------------------------------------------
-- The course words (hand-derived)
---------------------------------------------------------------------------

local COURSE = {
  { "aiya", "yanta+a, anna+y-dots+a", "E02A E040 E016 E043 E040" },
  { "alla", "short carrier+a, lambe+bar below+a", "E02E E040 E022 E051 E040" },
  { "namárië", "númen+a, malta, long carrier+a, rómen+i, short carrier+e",
    "E010 E040 E011 E02C E040 E020 E044 E02E E046" },
  { "á na márië", "long carrier+a / númen+a / malta, long carrier+a, rómen+i, short carrier+e",
    "E02C E040 / E010 E040 / E011 E02C E040 E020 E044 E02E E046" },
  { "mára", "malta, long carrier+a, rómen+a", "E011 E02C E040 E020 E040" },
  { "quetilyë", "quessë+e, tinco+i, lambe+y-dots+e", "E003 E046 E000 E044 E022 E043 E046" },
  { "quetin", "quessë+e, tinco+i, númen", "E003 E046 E000 E044 E010" },
  { "Quenya", "quessë+e, númen+y-dots+a", "E003 E046 E010 E043 E040" },
  { "Elda", "short carrier+e, alda+a", "E02E E046 E023 E040" },
  { "Eldar", "short carrier+e, alda+a, óre", "E02E E046 E023 E040 E014" },
  { "Atan", "short carrier+a, tinco+a, númen", "E02E E040 E000 E040 E010" },
  { "Rúmil", "rómen, long carrier+u, malta+i, lambe", "E020 E02C E04C E011 E044 E022" },
  { "Elenwë", "short carrier+e, lambe+e, númen, vilya+e",
    "E02E E046 E022 E046 E010 E017 E046" },
  { "Nerdanel", "númen+e, arda+a, númen+e, lambe", "E010 E046 E021 E040 E010 E046 E022" },
  { "Voronwë", "vala+o, rómen+o, númen, vilya+e", "E015 E04A E020 E04A E010 E017 E046" },
  { "Elendil", "short carrier+e, lambe+e, ando+i, lambe",
    "E02E E046 E022 E046 E004 E044 E022" },
  { "Tirion", "tinco+i, rómen+i, short carrier+o, númen",
    "E000 E044 E020 E044 E02E E04A E010" },
  { "Valimar", "vala+a, lambe+i, malta+a, óre", "E015 E040 E022 E044 E011 E040 E014" },
  { "Avallónë", "short carrier+a, vala+a, lambe+bar below, long carrier+o, númen+e",
    "E02E E040 E015 E040 E022 E051 E02C E04A E010 E046" },
  { "Endórë", "short carrier+e, ando, long carrier+o, rómen+e",
    "E02E E046 E004 E02C E04A E020 E046" },
  { "Númenórë", "númen, long carrier+u, malta+e, númen, long carrier+o, rómen+e",
    "E010 E02C E04C E011 E046 E010 E02C E04A E020 E046" },
  { "Vanya", "vala+a, númen+y-dots+a", "E015 E040 E010 E043 E040" },
  { "Noldo", "númen+o, alda+o", "E010 E04A E023 E04A" },
  { "lúmë", "lambe, long carrier+u, malta+e", "E022 E02C E04C E011 E046" },
  { "aurë", "úre+a, rómen+e", "E02B E040 E020 E046" },
  { "amaurë", "short carrier+a, malta, úre+a, rómen+e", "E02E E040 E011 E02B E040 E020 E046" },
  { "endaurë", "short carrier+e, ando, úre+a, rómen+e", "E02E E046 E004 E02B E040 E020 E046" },
  { "apárilë", "short carrier+a, parma, long carrier+a, rómen+i, lambe+e",
    "E02E E040 E001 E02C E040 E020 E044 E022 E046" },
  { "undómë", "short carrier+u, ando, long carrier+o, malta+e",
    "E02E E04C E004 E02C E04A E011 E046" },
  { "sinyë", "silmë nuquerna+i, númen+y-dots+e", "E025 E044 E010 E043 E046" },
  { "lómë", "lambe, long carrier+o, malta+e", "E022 E02C E04A E011 E046" },
  { "minë", "malta+i, númen+e", "E011 E044 E010 E046" },
  { "atta", "short carrier+a, tinco+bar below+a", "E02E E040 E000 E051 E040" },
  { "neldë", "númen+e, alda+e", "E010 E046 E023 E046" },
  { "canta", "calma+a, anto+a", "E002 E040 E00C E040" },
  { "lempë", "lambe+e, ampa+e", "E022 E046 E00D E046" },
  { "enquë", "short carrier+e, unquë+e", "E02E E046 E00F E046" },
  { "otso", "short carrier+o, tinco+s-hook+o", "E02E E04A E000 E059 E04A" },
  { "tolto", "tinco+o, lambe, tinco+o", "E000 E04A E022 E000 E04A" },
  { "nertë", "númen+e, óre, tinco+e", "E010 E046 E014 E000 E046" },
  { "quëan", "quessë+e, short carrier+a, númen", "E003 E046 E02E E040 E010" },
  { "hantanyel", "hyarmen+a, anto+a, númen+y-dots+e, lambe",
    "E028 E040 E00C E040 E010 E043 E046 E022" },
  { "manen", "malta+a, númen+e, númen", "E011 E040 E010 E046 E010" },
  { "nalyë", "númen+a, lambe+y-dots+e", "E010 E040 E022 E043 E046" },
  { "nanyë", "númen+a, númen+y-dots+e", "E010 E040 E010 E043 E046" },
  { "esselya", "short carrier+e, essë nuquerna+e, lambe+y-dots+a",
    "E02E E046 E027 E046 E022 E043 E040" },
  { "essenya", "short carrier+e, essë nuquerna+e, númen+y-dots+a",
    "E02E E046 E027 E046 E010 E043 E040" },
  { "tulin", "tinco+u, lambe+i, númen", "E000 E04C E022 E044 E010" },
  { "tulilyë", "tinco+u, lambe+i, lambe+y-dots+e", "E000 E04C E022 E044 E022 E043 E046" },
  { "síla", "silmë, long carrier+i, lambe+a", "E024 E02C E044 E022 E040" },
  { "elen", "short carrier+e, lambe+e, númen", "E02E E046 E022 E046 E010" },
  { "lúmenn' omentielvo",
    "lambe, long carrier+u, malta+e, númen+bar below / "
      .. "short carrier+o, malta+e, anto+i, short carrier+e, lambe, vala+o",
    "E022 E02C E04C E011 E046 E010 E051 / E02E E04A E011 E046 E00C E044 E02E E046 E022 E015 E04A" },
  { "mallo", "malta+a, lambe+bar below+o", "E011 E040 E022 E051 E04A" },
  { "Valimarello", "vala+a, lambe+i, malta+a, rómen+e, lambe+bar below+o",
    "E015 E040 E022 E044 E011 E040 E020 E046 E022 E051 E04A" },
  { "Tirionello", "tinco+i, rómen+i, short carrier+o, númen+e, lambe+bar below+o",
    "E000 E044 E020 E044 E02E E04A E010 E046 E022 E051 E04A" },
  { "ma", "malta+a", "E011 E040" },
  { "ná", "númen, long carrier+a", "E010 E02C E040" },
  { "ui", "yanta+u", "E02A E04C" },
  { "tengwar", "tinco+e, ungwë+a, óre", "E000 E046 E007 E040 E014" },
  { "tehtar", "tinco+e, harma, tinco+a, óre", "E000 E046 E00A E000 E040 E014" },
  { "Sindarin", "silmë nuquerna+i, ando+a, rómen+i, númen",
    "E025 E044 E004 E040 E020 E044 E010" },
}

---------------------------------------------------------------------------
-- Further cases: Tolkien's Namárië, punctuation, every rule branch
-- (hand-derived the same way)
---------------------------------------------------------------------------

local EXTRA = {
  -- punctuation (step 12)
  { "Ai!", "yanta+a, exclamation mark", "E02A E040 E065" },
  { "Ai! laurië lantar lassi súrinen,",
    "yanta+a, exclamation mark / lambe, úre+a, rómen+i, short carrier+e / "
      .. "lambe+a, anto+a, óre / lambe+a, essë nuquerna+i / "
      .. "silmë, long carrier+u, rómen+i, númen+e, númen, pusta",
    "E02A E040 E065 / E022 E02B E040 E020 E044 E02E E046 / E022 E040 E00C E040 E014 / "
      .. "E022 E040 E027 E044 / E024 E02C E04C E020 E044 E010 E046 E010 2E31" },
  { "Sí man i yulma nin enquantuva?",
    "silmë, long carrier+i / malta+a, númen / short carrier+i / "
      .. "anna+y-dots+u, lambe, malta+a / númen+i, númen / "
      .. "short carrier+e, unquë+a, anto+u, vala+a, question mark",
    "E024 E02C E044 / E011 E040 E010 / E02E E044 / E016 E043 E04C E022 E011 E040 / "
      .. "E010 E044 E010 / E02E E046 E00F E040 E00C E04C E015 E040 E066" },
  { "Elen síla lúmenn' omentielvo.",
    "short carrier+e, lambe+e, númen / silmë, long carrier+i, lambe+a / "
      .. "lambe, long carrier+u, malta+e, númen+bar below / "
      .. "short carrier+o, malta+e, anto+i, short carrier+e, lambe, vala+o, double pusta",
    "E02E E046 E022 E046 E010 / E024 E02C E044 E022 E040 / E022 E02C E04C E011 E046 E010 E051 / "
      .. "E02E E04A E011 E046 E00C E044 E02E E046 E022 E015 E04A 003A" },
  { "ma; ma: ma", "malta+a, pusta / malta+a, pusta / malta+a",
    "E011 E040 2E31 / E011 E040 2E31 / E011 E040" },
  -- hyphen joins, curly apostrophe drops (step 1)
  { "lissë-miruvóreva",
    "lambe+i, essë nuquerna+e, malta+i, rómen+u, vala, long carrier+o, rómen+e, vala+a",
    "E022 E044 E027 E046 E011 E044 E020 E04C E015 E02C E04A E020 E046 E015 E040" },
  { "lúmenn’", "lambe, long carrier+u, malta+e, númen+bar below",
    "E022 E02C E04C E011 E046 E010 E051" },
  -- capitals, decomposed accents and other long-vowel spellings (steps 1-2)
  { "NAMÁRIË", "númen+a, malta, long carrier+a, rómen+i, short carrier+e",
    "E010 E040 E011 E02C E040 E020 E044 E02E E046" },
  { "lu\u{0301}me\u{0308}", "lambe, long carrier+u, malta+e", "E022 E02C E04C E011 E046" },
  { "naa", "númen, long carrier+a", "E010 E02C E040" },
  { "nā", "númen, long carrier+a", "E010 E02C E040" },
  { "nâ", "númen, long carrier+a", "E010 E02C E040" },
  -- k, kw, x, z, th, þ, ch, ñ (step 2)
  { "Kementári", "calma+e, malta+e, anto, long carrier+a, rómen+i",
    "E002 E046 E011 E046 E00C E02C E040 E020 E044" },
  { "kwenya", "quessë+e, númen+y-dots+a", "E003 E046 E010 E043 E040" },
  { "axo", "short carrier+a, calma+s-hook+o", "E02E E040 E002 E059 E04A" },
  { "Ezellohar", "short carrier+e, essë nuquerna+e, lambe+bar below+o, harma+a, óre",
    "E02E E046 E027 E046 E022 E051 E04A E00A E040 E014" },
  { "Ithil", "short carrier+i, súlë+i, lambe", "E02E E044 E008 E044 E022" },
  { "Iþil", "short carrier+i, súlë+i, lambe", "E02E E044 E008 E044 E022" },
  { "ech", "short carrier+e, harma", "E02E E046 E00A" },
  { "Ñoldo", "noldo+o, alda+o", "E012 E04A E023 E04A" },
  -- diphthongs and the diaeresis (step 3)
  { "luini", "lambe, yanta+u, númen+i", "E022 E02A E04C E010 E044" },
  { "Oiolossëo", "yanta+o, short carrier+o, lambe+o, essë nuquerna+e, short carrier+o",
    "E02A E04A E02E E04A E022 E04A E027 E046 E02E E04A" },
  { "oi", "yanta+o", "E02A E04A" },
  { "eu", "úre+e", "E02B E046" },
  { "iu", "úre+i", "E02B E044" },
  { "aï", "short carrier+a, short carrier+i", "E02E E040 E02E E044" },
  -- consonant clusters (step 4)
  { "lapsë", "lambe+a, parma+s-hook+e", "E022 E040 E001 E059 E046" },
  { "hwesta", "hwesta+e, silmë, tinco+a", "E00B E046 E024 E000 E040" },
  { "hyarmen", "hyarmen+y-dots+a, óre, malta+e, númen", "E028 E043 E040 E014 E011 E046 E010" },
  { "hlócë", "halla, lambe, long carrier+o, calma+e", "E02D E022 E02C E04A E002 E046" },
  { "hrívë", "halla, rómen, long carrier+i, vala+e", "E02D E020 E02C E044 E015 E046" },
  { "nwalmë", "nwalmë+a, lambe, malta+e", "E013 E040 E022 E011 E046" },
  { "vanwa", "vala+a, númen, vilya+a", "E015 E040 E010 E017 E040" },
  { "tintilar", "tinco+i, anto+i, lambe+a, óre", "E000 E044 E00C E044 E022 E040 E014" },
  { "Altariello",
    "short carrier+a, lambe, tinco+a, rómen+i, short carrier+e, lambe+bar below+o",
    "E02E E040 E022 E000 E040 E020 E044 E02E E046 E022 E051 E04A" },
  { "Silmarillion",
    "silmë nuquerna+i, lambe, malta+a, rómen+i, lambe+bar below+i, short carrier+o, númen",
    "E025 E044 E022 E011 E040 E020 E044 E022 E051 E044 E02E E04A E010" },
  -- y (step 5) and r (step 6)
  { "yéni", "anna+y-dots, long carrier+e, númen+i", "E016 E043 E02C E046 E010 E044" },
  { "máryat", "malta, long carrier+a, rómen+y-dots+a, tinco",
    "E011 E02C E040 E020 E043 E040 E000" },
  { "Calacirya", "calma+a, lambe+a, calma+i, rómen+y-dots+a",
    "E002 E040 E022 E040 E002 E044 E020 E043 E040" },
  { "yarra", "anna+y-dots+a, rómen+bar below+a", "E016 E043 E040 E020 E051 E040" },
  -- h (step 6)
  { "ohtar", "short carrier+o, harma, tinco+a, óre", "E02E E04A E00A E000 E040 E014" },
  { "Ilúvatar", "short carrier+i, lambe, long carrier+u, vala+a, tinco+a, óre",
    "E02E E044 E022 E02C E04C E015 E040 E000 E040 E014" },
  -- lb is Quenya; a lone d is not (step 14)
  { "alba", "short carrier+a, lambe, umbar+a", "E02E E040 E022 E005 E040", warnings = 0 },
  { "adan", "short carrier+a, ando+a, númen", "E02E E040 E004 E040 E010", warnings = 1 },
}

-- Options (hand-derived; the spelling column is not used for these)
local OPTION_CASES = {
  { "otso", { s_hook = "spacing" }, "E02E E04A E000 E04A E058" },
  { "otso", { s_hook = "silme" }, "E02E E04A E000 E025 E04A" },
  { "axo", { s_hook = "silme" }, "E02E E040 E002 E025 E04A" },
  { "ma, ma.", { punctuation = "legacy" }, "E011 E040 E060 / E011 E040 E061" },
}

---------------------------------------------------------------------------
-- Runner
---------------------------------------------------------------------------

local passed, failed = 0, 0

local function check(label, ok, detail)
  if ok then
    passed = passed + 1
  else
    failed = failed + 1
    print("FAIL  " .. label .. (detail and ("\n      " .. detail) or ""))
  end
end

local function run_cases(title, cases)
  print(("== %s (%d cases)"):format(title, #cases))
  for _, case in ipairs(cases) do
    local latin, spelling, hex = case[1], case[2], case[3]
    -- 1. hand spelling and hand code points agree
    local from_spelling = spelling_to_hex(spelling)
    check(latin .. " [hand spelling = hand code points]", from_spelling == hex,
      "spelling gives " .. from_spelling .. "\n      code points " .. hex)
    -- 2. transcriber output
    local result = quenya.analyse(latin)
    local got = string_to_hex(result.text)
    check(latin .. " [code points]", got == hex, "expected " .. hex .. "\n      got      " .. got)
    -- 3. transcriber's spelling helper
    local spelled = quenya.spell(result.text)
    check(latin .. " [spelling]", spelled == spelling,
      "expected " .. spelling .. "\n      got      " .. spelled)
    -- 4. warnings (none, unless the case says otherwise)
    local want = case.warnings or 0
    check(latin .. " [warnings]", #result.warnings == want,
      ("expected %d warnings, got %d"):format(want, #result.warnings))
    -- transcribe() is the same text
    check(latin .. " [transcribe]", quenya.transcribe(latin) == result.text)
  end
end

run_cases("course words", COURSE)
run_cases("further cases", EXTRA)

print(("== options (%d cases)"):format(#OPTION_CASES))
for _, case in ipairs(OPTION_CASES) do
  local got = string_to_hex(quenya.transcribe(case[1], case[2]))
  check(case[1] .. " " .. (case[2].s_hook or case[2].punctuation), got == case[3],
    "expected " .. case[3] .. "\n      got      " .. got)
end

---------------------------------------------------------------------------
-- The Pandoc filter (only when run under pandoc)
---------------------------------------------------------------------------

if pandoc then
  print("== filter")
  local filter = dofile(FILTERS .. "tengwar.lua")
  local function apply(markdown, format)
    FORMAT = format
    local doc = pandoc.read(markdown, "markdown")
    for _, f in ipairs(filter) do doc = doc:walk(f) end
    return pandoc.write(doc, format, { wrap_text = "wrap-none" })
  end
  local T = quenya.transcribe("namárië")

  local html = apply("Say [namárië]{.tengwar}.", "html5")
  local expected_html = '<p>Say <span class="tengwar" lang="qya-Teng" title="namárië" '
    .. 'aria-label="namárië" role="img">' .. T .. '</span>.</p>'
  check("html span", html:find(expected_html, 1, true) ~= nil,
    "expected " .. expected_html .. "\n      got      " .. html)

  local tex = apply("Say [namárië]{.tengwar}.", "latex")
  check("latex span", tex == "Say {\\tengwarfont " .. T .. "}.", "got " .. tex)

  local tex2 = apply("[ma 50%]{.tengwar}", "latex")
  check("latex escaping", tex2 == "{\\tengwarfont " .. quenya.transcribe("ma") .. " 50\\%}",
    "got " .. tex2)

  -- One letter by name: [rómen]{.tengwa}
  check("letter rómen", quenya.letter("rómen") == utf8.char(0xE020), "got " .. tostring(quenya.letter("rómen")))
  check("letter Órë", quenya.letter("Órë") == utf8.char(0xE014), "got " .. tostring(quenya.letter("Órë")))
  check("letter lambë", quenya.letter("lambë") == utf8.char(0xE022), "got " .. tostring(quenya.letter("lambë")))
  check("letter silmë nuquerna", quenya.letter("silmë nuquerna") == utf8.char(0xE025),
    "got " .. tostring(quenya.letter("silmë nuquerna")))
  check("letter long carrier", quenya.letter("long carrier") == utf8.char(0xE02C),
    "got " .. tostring(quenya.letter("long carrier")))
  check("letter combining accents", quenya.letter("ro\u{301}men") == utf8.char(0xE020)
    and quenya.letter("lambe\u{308}") == utf8.char(0xE022)
    and quenya.letter("silme\u{308} nuquerna") == utf8.char(0xE025),
    "decomposed accents must be ignored like precomposed ones")
  check("letter surrounding spaces", quenya.letter(" rómen ") == utf8.char(0xE020),
    "got " .. tostring(quenya.letter(" rómen ")))
  check("letter unknown", quenya.letter("tehta_a") == nil and quenya.letter("pusta") == nil
    and quenya.letter("xyz") == nil, "a mark, punctuation or unknown name must give nil")
  local html_letter = apply("[rómen]{.tengwa}", "html5")
  local expected_letter = '<span class="tengwar" lang="qya-Teng" title="rómen" '
    .. 'aria-label="rómen" role="img">' .. utf8.char(0xE020) .. '</span>'
  check("html letter", html_letter:find(expected_letter, 1, true) ~= nil,
    "expected " .. expected_letter .. "\n      got      " .. html_letter)
  local tex_letter = apply("[malta]{.tengwa}", "latex")
  check("latex letter", tex_letter == "{\\tengwarfont " .. utf8.char(0xE011) .. "}", "got " .. tex_letter)

  local html_quiz = apply("[minë]{.tengwar .no-title}", "html5")
  local expected_quiz = '<span class="tengwar" lang="qya-Teng" aria-label="minë" role="img">'
    .. quenya.transcribe("minë") .. '</span>'
  check("html no-title", html_quiz:find(expected_quiz, 1, true) ~= nil,
    "expected " .. expected_quiz .. "\n      got      " .. html_quiz)

  -- Notes and links inside a span are dropped, with a warning.
  local saved_quarto, warnings = quarto, {}
  quarto = { log = { warning = function (msg) warnings[#warnings + 1] = msg end } }
  apply("[ná[^1]]{.tengwar} [[rómen](https://example.org)]{.tengwa} [ar]{.tengwar}\n\n[^1]: A note.", "html5")
  quarto = saved_quarto
  check("lost note and link warned", #warnings == 2
    and warnings[1]:find("a note", 1, true) ~= nil and warnings[2]:find("a link", 1, true) ~= nil,
    "got " .. table.concat(warnings, " | "))

  local plain = apply("[namárië]{.tengwar} [namárië]{.other}", "plain")
  check("other formats", plain:find(T, 1, true) == 1 and plain:find("namárië", 1, true) ~= nil,
    "got " .. plain)
end

print(("\n%d passed, %d failed"):format(passed, failed))
if failed > 0 then os.exit(1) end
