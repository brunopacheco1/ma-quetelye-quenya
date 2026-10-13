-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
--
-- SPDX-License-Identifier: Apache-2.0

-- Quenya in Latin letters -> Tengwar, classical Quenya mode.
--
-- Pure Lua 5.3+ (only the standard `utf8` and `string` libraries), so it runs
-- inside Pandoc/Quarto filters and under any plain Lua interpreter.
--
-- The output uses the Free Tengwar / CSUR Private Use Area code points that
-- the book font (fonts/AlcarinTengwar-Regular.woff2) maps. Each tengwa is
-- followed by its combining marks in this order: bar below, y-dots, s-hook,
-- vowel tehta. The font positions the marks (GPOS mark/mkmk).
--
-- The spelling rules are the ones in the book's mode description
-- (specs/001-chapter-1/tengwar-mode.md):
--   * tehta on the consonant BEFORE the vowel; short carrier when there is none
--   * long vowels always on the long carrier
--   * ai oi ui -> yanta, au eu iu -> úre, carrying the first vowel's tehta
--   * r: rómen before a vowel or y, óre elsewhere; rd = arda
--   * h: hyarmen word-initially, harma elsewhere (ht)
--   * silmë / essë turn (nuquerna) when a vowel tehta stands on them
--   * nasal + stop clusters use their own tengwar; the nasal bar is never used
--
-- API
--   quenya.transcribe(latin [, opts]) -> string
--   quenya.analyse(latin [, opts])    -> { text = string, warnings = {...} }
--   quenya.codepoints(tengwar)        -> "U+E010 U+E040 ..."
--   quenya.spell(tengwar)             -> "númen+a, malta, long carrier+a / ..."
--
-- opts (all optional)
--   s_hook      = "mark"     U+E059 combining s-hook, before the tehta (default)
--                 "spacing"  U+E058 spacing s-hook, typed after the tehta;
--                            Alcarin then switches to its .sarince letter forms
--                 "silme"    no s-hook: ts, ps, x are written with silmë
--   punctuation = "unicode"  , ; : -> U+2E31 and . -> U+003A (default)
--                 "legacy"   , ; : -> U+E060 and . -> U+E061

local M = {}

M.version = "1.0.0"

local uchar = utf8.char

---------------------------------------------------------------------------
-- Code points
---------------------------------------------------------------------------

local CP = {
  tinco = 0xE000, parma = 0xE001, calma = 0xE002, quesse = 0xE003,
  ando = 0xE004, umbar = 0xE005, anga = 0xE006, ungwe = 0xE007,
  sule = 0xE008, formen = 0xE009, harma = 0xE00A, hwesta = 0xE00B,
  anto = 0xE00C, ampa = 0xE00D, anca = 0xE00E, unque = 0xE00F,
  numen = 0xE010, malta = 0xE011, noldo = 0xE012, nwalme = 0xE013,
  ore = 0xE014, vala = 0xE015, anna = 0xE016, vilya = 0xE017,
  romen = 0xE020, arda = 0xE021, lambe = 0xE022, alda = 0xE023,
  silme = 0xE024, silme_nuquerna = 0xE025, esse = 0xE026, esse_nuquerna = 0xE027,
  hyarmen = 0xE028, yanta = 0xE02A, ure = 0xE02B,
  long_carrier = 0xE02C, halla = 0xE02D, short_carrier = 0xE02E,
  -- marks
  tehta_a = 0xE040, tehta_e = 0xE046, tehta_i = 0xE044,
  tehta_o = 0xE04A, tehta_u = 0xE04C,
  y_dots = 0xE043, bar_below = 0xE051,
  s_hook = 0xE059, s_hook_spacing = 0xE058,
  -- punctuation
  pusta = 0x2E31, double_pusta = 0x003A,
  pusta_legacy = 0xE060, double_pusta_legacy = 0xE061,
  exclamation = 0xE065, question = 0xE066, four_dot_pusta = 0x2058,
}
M.CP = CP

-- Display names, as used in the spelling notation of the mode description.
local NAME = {
  [0xE000] = "tinco", [0xE001] = "parma", [0xE002] = "calma", [0xE003] = "quessë",
  [0xE004] = "ando", [0xE005] = "umbar", [0xE006] = "anga", [0xE007] = "ungwë",
  [0xE008] = "súlë", [0xE009] = "formen", [0xE00A] = "harma", [0xE00B] = "hwesta",
  [0xE00C] = "anto", [0xE00D] = "ampa", [0xE00E] = "anca", [0xE00F] = "unquë",
  [0xE010] = "númen", [0xE011] = "malta", [0xE012] = "noldo", [0xE013] = "nwalmë",
  [0xE014] = "óre", [0xE015] = "vala", [0xE016] = "anna", [0xE017] = "vilya",
  [0xE020] = "rómen", [0xE021] = "arda", [0xE022] = "lambe", [0xE023] = "alda",
  [0xE024] = "silmë", [0xE025] = "silmë nuquerna", [0xE026] = "essë",
  [0xE027] = "essë nuquerna", [0xE028] = "hyarmen", [0xE02A] = "yanta",
  [0xE02B] = "úre", [0xE02C] = "long carrier", [0xE02D] = "halla",
  [0xE02E] = "short carrier",
  [0xE040] = "a", [0xE046] = "e", [0xE044] = "i", [0xE04A] = "o", [0xE04C] = "u",
  [0xE043] = "y-dots", [0xE051] = "bar below",
  [0xE059] = "s-hook", [0xE058] = "s-hook",
  [0x2E31] = "pusta", [0x003A] = "double pusta",
  [0xE060] = "pusta", [0xE061] = "double pusta",
  [0xE065] = "exclamation mark", [0xE066] = "question mark",
  [0x2058] = "four-dot pusta",
}
M.NAME = NAME

local TEHTA = { a = CP.tehta_a, e = CP.tehta_e, i = CP.tehta_i,
                o = CP.tehta_o, u = CP.tehta_u }

---------------------------------------------------------------------------
-- Step 1: normalise
---------------------------------------------------------------------------

-- Combining marks folded into the preceding letter (a small NFC for the
-- letters Quenya uses).
local COMBINE = {
  ["\u{0301}"] = { a = "á", e = "é", i = "í", o = "ó", u = "ú",
                   A = "Á", E = "É", I = "Í", O = "Ó", U = "Ú" },
  ["\u{0308}"] = { a = "ä", e = "ë", i = "ï", o = "ö", u = "ü",
                   A = "Ä", E = "Ë", I = "Ï", O = "Ö", U = "Ü" },
  ["\u{0304}"] = { a = "ā", e = "ē", i = "ī", o = "ō", u = "ū",
                   A = "Ā", E = "Ē", I = "Ī", O = "Ō", U = "Ū" },
  ["\u{0302}"] = { a = "â", e = "ê", i = "î", o = "ô", u = "û",
                   A = "Â", E = "Ê", I = "Î", O = "Ô", U = "Û" },
  ["\u{0303}"] = { n = "ñ", N = "Ñ" },
}

local LOWER = {
  ["Á"] = "á", ["É"] = "é", ["Í"] = "í", ["Ó"] = "ó", ["Ú"] = "ú",
  ["Ä"] = "ä", ["Ë"] = "ë", ["Ï"] = "ï", ["Ö"] = "ö", ["Ü"] = "ü",
  ["Ā"] = "ā", ["Ē"] = "ē", ["Ī"] = "ī", ["Ō"] = "ō", ["Ū"] = "ū",
  ["Â"] = "â", ["Ê"] = "ê", ["Î"] = "î", ["Ô"] = "ô", ["Û"] = "û",
  ["Ñ"] = "ñ", ["Þ"] = "þ", ["Χ"] = "χ",
}

-- Letters that belong to a word (after lower-casing). ASCII a-z are added
-- below; unknown ASCII letters are kept and reported.
local WORD = {}
for c in ("áéíóúäëïöüāēīōūâêîôûñþχ"):gmatch(utf8.charpattern) do WORD[c] = true end
for b = string.byte("a"), string.byte("z") do WORD[string.char(b)] = true end

local DELETE = { ["'"] = true, ["’"] = true, ["ʼ"] = true,      -- apostrophes
                 ["-"] = true, ["‐"] = true, ["‑"] = true }     -- hyphens

local function to_chars(s)
  local out = {}
  for _, c in utf8.codes(s) do
    local ch = uchar(c)
    local comb = COMBINE[ch]
    if comb and #out > 0 and comb[out[#out]] then
      out[#out] = comb[out[#out]]
    else
      out[#out + 1] = ch
    end
  end
  for i, ch in ipairs(out) do
    out[i] = LOWER[ch] or (#ch == 1 and ch:lower()) or ch
  end
  return out
end

---------------------------------------------------------------------------
-- Step 2: rewrite letters
---------------------------------------------------------------------------

local LONG_ALT = { ["ā"] = "á", ["â"] = "á", ["ē"] = "é", ["ê"] = "é",
                   ["ī"] = "í", ["î"] = "í", ["ō"] = "ó", ["ô"] = "ó",
                   ["ū"] = "ú", ["û"] = "ú" }
local DOUBLE_LONG = { a = "á", e = "é", i = "í", o = "ó", u = "ú" }
-- ï and ü are kept as their own symbols: short i/u that never form a glide.
local TREMA = { ["ä"] = "a", ["ë"] = "e", ["ö"] = "o" }

local function rewrite(word)
  -- long-vowel spellings
  local a = {}
  local i = 1
  while i <= #word do
    local c = LONG_ALT[word[i]] or word[i]
    if DOUBLE_LONG[c] and word[i + 1] == c then
      a[#a + 1] = DOUBLE_LONG[c]; i = i + 2
    else
      a[#a + 1] = c; i = i + 1
    end
  end
  -- diaeresis, k, x, z
  local b = {}
  for _, c in ipairs(a) do
    c = TREMA[c] or c
    if c == "k" then b[#b + 1] = "c"
    elseif c == "x" then b[#b + 1] = "c"; b[#b + 1] = "s"
    elseif c == "z" then b[#b + 1] = "s"; b[#b + 1] = "s"
    else b[#b + 1] = c end
  end
  -- th, ch, qu, q, cw (kw is cw by now)
  local out = {}
  i = 1
  while i <= #b do
    local c, n = b[i], b[i + 1]
    if c == "t" and n == "h" then out[#out + 1] = "þ"; i = i + 2
    elseif c == "c" and n == "h" then out[#out + 1] = "χ"; i = i + 2
    elseif c == "q" and n == "u" then out[#out + 1] = "Q"; i = i + 2
    elseif c == "q" then out[#out + 1] = "Q"; i = i + 1
    elseif c == "c" and n == "w" then out[#out + 1] = "Q"; i = i + 2
    else out[#out + 1] = c; i = i + 1 end
  end
  return out
end

---------------------------------------------------------------------------
-- Steps 3-5: segment into units
---------------------------------------------------------------------------

local VOWEL = {
  a = { v = "a" }, e = { v = "e" }, i = { v = "i" }, o = { v = "o" }, u = { v = "u" },
  ["ï"] = { v = "i", noglide = true }, ["ü"] = { v = "u", noglide = true },
  ["á"] = { v = "a", long = true }, ["é"] = { v = "e", long = true },
  ["í"] = { v = "i", long = true }, ["ó"] = { v = "o", long = true },
  ["ú"] = { v = "u", long = true },
}

-- Consonant clusters, in priority order (step 4). Each entry lists the
-- letters and the unit key.
local CLUSTERS = {
  { { "n", "g", "w" }, "ngw" },
  { { "n", "Q" }, "nQ" },
  { { "n", "g" }, "ng" }, { { "n", "c" }, "nc" }, { { "n", "t" }, "nt" },
  { { "n", "d" }, "nd" }, { { "m", "p" }, "mp" }, { { "m", "b" }, "mb" },
  { { "l", "d" }, "ld" }, { { "r", "d" }, "rd" },
  { { "h", "w" }, "hw" }, { { "h", "y" }, "hy" }, { { "h", "l" }, "hl" },
  { { "h", "r" }, "hr" },
  { { "t", "s" }, "ts", s_hook = true }, { { "p", "s" }, "ps", s_hook = true },
  { { "c", "s" }, "cs", s_hook = true },
  { { "s", "s" }, "ss" },
  { { "n", "w" }, "nw", initial = true }, { { "ñ", "w" }, "nw", initial = true },
}

local DOUBLES = { t = true, p = true, c = true, m = true, n = true,
                  l = true, r = true, f = true, v = true }

-- Consonant letters after step 2 (d, b, g only as a fallback).
local CONSONANT = {}
for c in ("tpcQnmñlrshfvwþχdbg"):gmatch(utf8.charpattern) do CONSONANT[c] = true end

local function match_at(s, i, letters)
  for k, l in ipairs(letters) do
    if s[i + k - 1] ~= l then return false end
  end
  return true
end

local function segment(s, opts)
  local units = {}
  local i = 1
  while i <= #s do
    local c = s[i]
    local v = VOWEL[c]
    if v then
      local w = VOWEL[s[i + 1] or ""]
      local glide
      if not v.long and w and not w.long and not w.noglide then
        if w.v == "i" and (v.v == "a" or v.v == "o" or v.v == "u") then glide = "yanta"
        elseif w.v == "u" and (v.v == "a" or v.v == "e" or v.v == "i") then glide = "ure" end
      end
      if glide then
        units[#units + 1] = { kind = "D", v = v.v, glide = glide }
        i = i + 2
      else
        units[#units + 1] = { kind = "V", v = v.v, long = v.long }
        i = i + 1
      end
    elseif c == "y" then
      local prev = units[#units]
      if prev and prev.kind == "C" and not prev.ydots then
        prev.ydots = true
      else
        units[#units + 1] = { kind = "Y" }
      end
      i = i + 1
    elseif CONSONANT[c] then
      local key, len
      for _, cl in ipairs(CLUSTERS) do
        local skip = (cl.initial and i ~= 1) or (cl.s_hook and opts.s_hook == "silme")
        if not skip and match_at(s, i, cl[1]) then
          key, len = cl[2], #cl[1]
          break
        end
      end
      if not key and DOUBLES[c] and s[i + 1] == c then key, len = c .. c, 2 end
      if not key then key, len = c, 1 end
      local unit = { kind = "C", key = key, initial = (i == 1),
                     prev = s[i - 1] }
      if key == "hy" then unit.ydots = true end
      units[#units + 1] = unit
      i = i + len
    else
      units[#units + 1] = { kind = "X", text = c }
      i = i + 1
    end
  end
  return units
end

---------------------------------------------------------------------------
-- Step 6: consonant units -> tengwar columns
---------------------------------------------------------------------------

local SIMPLE = {
  t = "tinco", p = "parma", c = "calma", Q = "quesse",
  nd = "ando", mb = "umbar", ng = "anga", ngw = "ungwe",
  ["þ"] = "sule", f = "formen", ["χ"] = "harma", hw = "hwesta", hy = "hyarmen",
  nt = "anto", mp = "ampa", nc = "anca", nQ = "unque",
  n = "numen", m = "malta", ["ñ"] = "noldo", nw = "nwalme",
  v = "vala", w = "vilya", l = "lambe", ld = "alda", rd = "arda",
  s = "silme", ss = "esse",
}
local HOOKED = { ts = "tinco", ps = "parma", cs = "calma" }
local FALLBACK = { d = "ando", b = "umbar", g = "anga" }

-- Returns the list of columns for a consonant unit (the last one is the
-- column a following short vowel goes on) and an optional warning.
local function consonant_columns(u, next_unit)
  local key = u.key
  local function col(name) return { base = CP[name], kind = "C" } end
  if key == "r" then
    local nk = next_unit and next_unit.kind
    local before_vowel = nk == "V" or nk == "D" or u.ydots
    return { col(before_vowel and "romen" or "ore") }
  elseif key == "rr" then
    local c = col("romen"); c.bar = true; return { c }
  elseif key == "h" then
    return { col(u.initial and "hyarmen" or "harma") }
  elseif key == "hl" then
    return { col("halla"), col("lambe") }
  elseif key == "hr" then
    return { col("halla"), col("romen") }
  elseif HOOKED[key] then
    local c = col(HOOKED[key]); c.shook = true; return { c }
  elseif SIMPLE[key] then
    return { col(SIMPLE[key]) }
  elseif #key == 2 and key:sub(1, 1) == key:sub(2, 2) and SIMPLE[key:sub(1, 1)] then
    local c = col(SIMPLE[key:sub(1, 1)]); c.bar = true; return { c }
  end
  -- d, b, g on their own (step 14)
  local c = col(FALLBACK[key])
  if key == "b" and u.prev == "l" then return { c } end -- lb is Quenya
  return { c }, ("'" .. key .. "' outside nd/mb/ng/ld/rd/lb is not Quenya;"
                 .. " written with " .. FALLBACK[key])
end

---------------------------------------------------------------------------
-- Steps 7-10: vowels, then the shape of silmë/essë
---------------------------------------------------------------------------

local function word_columns(units, warn)
  local cols = {}
  local open -- consonant column that can still take a short vowel's tehta
  for k, u in ipairs(units) do
    if u.kind == "C" then
      local cs, msg = consonant_columns(u, units[k + 1])
      if msg then warn(msg) end
      for _, c in ipairs(cs) do cols[#cols + 1] = c end
      local last = cs[#cs]
      if u.ydots then last.ydots = true end
      open = (last.kind == "C") and last or nil
    elseif u.kind == "Y" then
      local c = { base = CP.anna, ydots = true, kind = "C" }
      cols[#cols + 1] = c
      open = c
    elseif u.kind == "D" then
      cols[#cols + 1] = { base = CP[u.glide], tehta = TEHTA[u.v], kind = "G" }
      open = nil
    elseif u.kind == "V" then
      if u.long then
        cols[#cols + 1] = { base = CP.long_carrier, tehta = TEHTA[u.v], kind = "L" }
      elseif open then
        open.tehta = TEHTA[u.v]
      else
        cols[#cols + 1] = { base = CP.short_carrier, tehta = TEHTA[u.v], kind = "S" }
      end
      open = nil
    else
      cols[#cols + 1] = { literal = u.text, kind = "X" }
      warn("no Tengwar for '" .. u.text .. "'")
      open = nil
    end
  end
  -- Step 10: turned silmë / essë under a vowel tehta
  for _, c in ipairs(cols) do
    if c.tehta and c.base == CP.silme then c.base = CP.silme_nuquerna end
    if c.tehta and c.base == CP.esse then c.base = CP.esse_nuquerna end
  end
  return cols
end

local function encode(cols, opts)
  local out = {}
  for _, c in ipairs(cols) do
    if c.literal then
      out[#out + 1] = c.literal
    else
      out[#out + 1] = uchar(c.base)
      if c.bar then out[#out + 1] = uchar(CP.bar_below) end
      if c.ydots then out[#out + 1] = uchar(CP.y_dots) end
      if c.shook and opts.s_hook ~= "spacing" then out[#out + 1] = uchar(CP.s_hook) end
      if c.tehta then out[#out + 1] = uchar(c.tehta) end
      if c.shook and opts.s_hook == "spacing" then
        out[#out + 1] = uchar(CP.s_hook_spacing)
      end
    end
  end
  return table.concat(out)
end

---------------------------------------------------------------------------
-- Step 12: punctuation; driver
---------------------------------------------------------------------------

local function punctuation(opts)
  local legacy = opts.punctuation == "legacy"
  local p1 = uchar(legacy and CP.pusta_legacy or CP.pusta)
  local p2 = uchar(legacy and CP.double_pusta_legacy or CP.double_pusta)
  return { [","] = p1, [";"] = p1, [":"] = p1, ["."] = p2,
           ["!"] = uchar(CP.exclamation), ["?"] = uchar(CP.question) }
end

local function is_tengwar(ch)
  local c = utf8.codepoint(ch)
  return c >= 0xE000 and c <= 0xE07F
end

--- Transcribe Latin-script Quenya and report problems.
-- @return { text = <Tengwar string>, warnings = { {word=, message=}, ... } }
function M.analyse(latin, opts)
  opts = opts or {}
  local punct = punctuation(opts)
  local warnings = {}
  local out = {}
  local word, raw = {}, {}
  local other = {} -- run of characters with no Tengwar, reported once

  local function flush_other()
    if #other == 0 then return end
    warnings[#warnings + 1] = { word = table.concat(other),
                                message = "no Tengwar; passed through unchanged" }
    other = {}
  end

  local function flush()
    if #word > 0 then
      local label = table.concat(raw)
      local function warn(msg)
        warnings[#warnings + 1] = { word = label, message = msg }
      end
      local units = segment(rewrite(word), opts)
      out[#out + 1] = encode(word_columns(units, warn), opts)
    end
    word, raw = {}, {}
  end

  for _, ch in ipairs(to_chars(latin or "")) do
    if DELETE[ch] then
      -- step 1: apostrophes and hyphens disappear; the parts are joined
      raw[#raw + 1] = ch
    elseif WORD[ch] then
      flush_other()
      word[#word + 1] = ch
      raw[#raw + 1] = ch
    else
      flush()
      if punct[ch] then
        flush_other()
        out[#out + 1] = punct[ch]
      elseif ch:match("^%s$") or ch == "\u{00A0}" or is_tengwar(ch) then
        -- white space (and Tengwar typed directly) passes through
        flush_other()
        out[#out + 1] = ch
      else
        -- digits, quotes, dashes ...: outside the mode, kept as they are
        other[#other + 1] = ch
        out[#out + 1] = ch
      end
    end
  end
  flush()
  flush_other()
  return { text = table.concat(out), warnings = warnings }
end

--- Transcribe Latin-script Quenya into a UTF-8 Tengwar string.
function M.transcribe(latin, opts)
  return M.analyse(latin, opts).text
end

---------------------------------------------------------------------------
-- Inspection helpers
---------------------------------------------------------------------------

--- "U+E010 U+E040 ..." for a string.
function M.codepoints(s)
  local t = {}
  for _, c in utf8.codes(s) do t[#t + 1] = string.format("U+%04X", c) end
  return table.concat(t, " ")
end

local function is_mark(c) return c >= 0xE040 and c <= 0xE05F end

--- Reading-order spelling of a Tengwar string, in the notation of the mode
-- description: "tengwa+mark+mark" columns joined by ", ", words by " / ".
function M.spell(s)
  local words, cols = {}, {}
  local function end_word()
    if #cols > 0 then words[#words + 1] = table.concat(cols, ", ") end
    cols = {}
  end
  for _, c in utf8.codes(s) do
    local ch = uchar(c)
    if ch:match("^%s$") then
      end_word()
    elseif is_mark(c) and #cols > 0 then
      cols[#cols] = cols[#cols] .. "+" .. (NAME[c] or string.format("U+%04X", c))
    else
      cols[#cols + 1] = NAME[c] or ch
    end
  end
  end_word()
  return table.concat(words, " / ")
end


-- One letter by its name, for tables that show a tengwa on its own:
-- quenya.letter("rómen") -> U+E020. Accents and the diaeresis (precomposed
-- or combining), case and surrounding spaces are ignored, and spaces or
-- hyphens stand for "_" ("silmë nuquerna", "long carrier"). Returns nil for
-- an unknown name.
local NAME_FOLD = { ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o",
  ["ú"] = "u", ["ë"] = "e", ["Á"] = "a", ["É"] = "e", ["Í"] = "i",
  ["Ó"] = "o", ["Ú"] = "u", ["Ë"] = "e" }

function M.letter(name)
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  local key = {}
  for _, c in utf8.codes(name) do
    if c ~= 0x0301 and c ~= 0x0308 then     -- combining acute, diaeresis
      local ch = utf8.char(c)
      ch = NAME_FOLD[ch] or ch:lower()
      if ch == " " or ch == "-" then ch = "_" end
      key[#key + 1] = ch
    end
  end
  local cp = CP[table.concat(key)]
  if cp == nil or cp < 0xE000 or cp > 0xE02E then return nil end
  return utf8.char(cp)
end

return M
