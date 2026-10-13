# Writing Quenya in Tengwar: the classical Quenya mode

These rules turn Quenya written in Latin letters (Tolkien's standard spelling: `c` for /k/, `qu`, `ë`, acute accents for long vowels) into Tengwar in the **classical Quenya mode**. That is the mode of Tolkien's tengwar *Namárië* in *The Road Goes Ever On* (1968; DTS 20) and the one described in *The Lord of the Rings*, Appendix E. The rules are written as an algorithm a program can follow, and they keep the choices a beginners' course needs. Every word the course needs is spelled out in §8.

Where Tolkien's own usage varies, §10 lists the alternatives and names the one recommended for the book. The rules below always use the recommended choice.

The book implements exactly these rules in `filters/tengwar/quenya.lua`, tested by `tests/tengwar_test.lua` (run `quarto pandoc lua tests/tengwar_test.lua`). Two independent checks agreed with it on every word in §8: a second transcriber written only from this document, and a visual check of each word drawn in the book's font. Authors write `[namárië]{.tengwar}` in a chapter, or `[rómen]{.tengwa}` to show one letter on its own.

---

## 1. Notation

**Spelling strings.** A spelling lists the written signs in reading order:

* `,` separates **columns**. A column is one tengwa (letter) together with the marks attached to it.
* `/` separates words.
* `tengwa+mark+mark` means marks attached to that tengwa, in this order: the marks below (`bar below`, `y-dots`, `s-hook`), then the vowel tehta above (`a`, `e`, `i`, `o`, `u`).
* `short carrier+e` means an e-tehta written on the short carrier. `long carrier+a` means a long á written on the long carrier.

**Code points.** The book's font, `fonts/AlcarinTengwar-Regular.woff2`, uses the Free Tengwar / CSUR Private Use Area mapping (Everson 2001, as adapted by the Free Tengwar Font Project). Its cmap was checked, and it has GPOS `mark`/`mkmk` positioning. So a program writes each tengwa followed by its combining marks, and the font places them.

| Tengwa (name used here) | Other names | Code point |
|---|---|---|
| tinco | | U+E000 |
| parma | | U+E001 |
| calma | | U+E002 |
| quessë | | U+E003 |
| ando | | U+E004 |
| umbar | | U+E005 |
| anga | | U+E006 |
| ungwë | | U+E007 |
| súlë | thúlë | U+E008 |
| formen | | U+E009 |
| harma | aha | U+E00A |
| hwesta | | U+E00B |
| anto | | U+E00C |
| ampa | | U+E00D |
| anca | | U+E00E |
| unquë | | U+E00F |
| númen | | U+E010 |
| malta | | U+E011 |
| noldo | ñoldo | U+E012 |
| nwalmë | ñwalmë | U+E013 |
| óre | | U+E014 |
| vala | | U+E015 |
| anna | | U+E016 |
| vilya | wilya | U+E017 |
| rómen | | U+E020 |
| arda | | U+E021 |
| lambe | | U+E022 |
| alda | | U+E023 |
| silmë | | U+E024 |
| silmë nuquerna | turned silmë | U+E025 |
| essë | áre, áze | U+E026 |
| essë nuquerna | | U+E027 |
| hyarmen | | U+E028 |
| yanta | | U+E02A |
| úre | | U+E02B |
| long carrier | ára | U+E02C |
| halla | | U+E02D |
| short carrier | telco | U+E02E |

| Mark | Meaning | Code point |
|---|---|---|
| `a` | a-tehta, three dots | U+E040 |
| `e` | e-tehta, acute stroke | U+E046 |
| `i` | i-tehta, one dot | U+E044 |
| `o` | o-tehta, the curl Free Tengwar names RIGHT CURL | U+E04A |
| `u` | u-tehta, LEFT CURL | U+E04C |
| `y-dots` | two dots below = following y | U+E043 |
| `bar below` | doubled (long) consonant | U+E051 |
| `s-hook` | sa-rincë = following s | U+E059 |
| (not used by default) | nasal bar above | U+E050 |
| (not used by default) | circumflex form of the a-tehta | U+E055 |

| Punctuation | Spelling name | Code point |
|---|---|---|
| `,` `;` `:` | single pusta | U+2E31 (or legacy U+E060) |
| `.` | double pusta | U+003A (or legacy U+E061) |
| `!` | exclamation mark | U+E065 |
| `?` | question mark | U+E066 |
| end of a text (optional) | four-dot pusta | U+2058 |

---

## 2. The algorithm

Apply the steps in order, one word at a time. Words are separated by white space, and punctuation attached to a word is handled in step 9.

### Step 1: Normalise the Latin text

1. Convert to Unicode NFC and **lower-case everything**. Tengwar have no capital letters (§7).
2. **Delete apostrophes** (`'`, `’`). The elided word is written as it stands, so `lúmenn'` ends in nn.
3. **Delete hyphens** and write the parts as one word. Example: `lissë-miruvóreva` becomes lissemiruvóreva.
4. **Long vowels.** Read `á é í ó ú` as long. Also accept `ā â aa` etc. as long.
5. **Diaeresis.** `ë ä ö` are just e, a, o; the diaeresis has no Tengwar sign. `ï ü` are just i and u, but are flagged "not a glide" for step 3.
6. **Rewrites:**
   * `k` → c
   * `th` or `þ` → þ
   * `ch` → χ (/x/)
   * `qu`, `q`, `cw`, `kw` → Q (one consonant)
   * `x` → cs
   * `z` → ss

### Step 2: Segment into units (left to right, longest match first)

1. **Diphthong.** A short `a`, `o` or `u` followed by a plain `i` forms one unit: **ai, oi, ui**. A short `a`, `e` or `i` followed by a plain `u` forms one unit: **au, eu, iu**. No other vowel pair is a diphthong (ea, ie, io, oa, ëa … are two vowels).
2. **Long vowel** (á é í ó ú) or **short vowel** (a e i o u): one unit each.
3. **Consonant units.** Try them in this order. The first one that matches wins.
   1. `ngw`
   2. `nQ` (nqu)
   3. `ng`, `nc`, `nt`, `nd`, `mp`, `mb`, `ld`, `rd`
   4. `hw`, `hy`, `hl`, `hr`
   5. `ts`, `ps`, `cs`
   6. `ss`
   7. word-initial `nw`
   8. a doubled letter: `tt pp cc mm nn ll rr` (also `ff vv`)
   9. a single letter
4. **y.**
   * A `y` that directly follows a consonant unit is absorbed into it as **y-dots**. Example: `ty`, `ny`, `ly`, `ry`, `ndy`, `lly`.
   * Any other `y` (word-initial, or after a vowel or diphthong) becomes the unit **anna + y-dots**. Anna then behaves as a consonant.

### Step 3: Map each consonant unit to tengwar

Use the consonant table in §3. Two letters depend on their position:

* **r** is **rómen** when the next unit is a vowel, a diphthong, or an absorbed y. Otherwise it is **óre**: before a consonant, and at the end of the word.
  * `rr` is rómen + bar below.
  * `rd` is always arda.
* **h** on its own is **hyarmen** at the start of a word. In every other position it is **harma** (aha); in practice that means `ht` and a few medial h's.
  * `hy`, `hw`, `hl` and `hr` follow the table in every position.

### Step 4: Place the vowels

Go through the vowel units in order.

1. **Diphthong.** Write the glide tengwa with the tehta of the first vowel on it:
   * yanta for ai, oi, ui
   * úre for au, eu, iu

   The consonant before a diphthong gets **no** tehta.
2. **Short vowel.**
   * If the unit just before it is a consonant tengwa that has no vowel tehta yet, put the tehta **on that consonant**. The vowel is written above the consonant that **precedes** it.
   * Otherwise write a **short carrier** with the tehta. This happens at the start of a word, after another vowel, and after a diphthong.
3. **Long vowel.** Always write a **long carrier** with the tehta, placed after the preceding consonant. That consonant gets no tehta.

Tehta shapes:

| Vowel | Tehta |
|---|---|
| a | three dots |
| e | acute stroke |
| i | dot |
| o | right curl |
| u | left curl |

### Step 5: Turn silmë and essë upside down when a tehta stands on them

After step 4:

* A **silmë** that carries a vowel tehta becomes **silmë nuquerna**.
* An **essë** that carries a vowel tehta becomes **essë nuquerna**.

Before a long vowel or a diphthong they stay upright, because the tehta then goes on the carrier or the glide.

### Step 6: Word-final vowels

Nothing special. A final vowel after a consonant goes on that consonant (`Elda`: …alda+a). A final vowel after a vowel goes on a short carrier (`namárië`: …rómen+i, short carrier+e). Final ë is plain e.

### Step 7: Capitals

Ignore them (step 1).

### Step 8: Encode

For each column, output:

1. the tengwa
2. bar below, if any
3. y-dots, if any
4. s-hook, if any
5. the vowel tehta, if any

Use the code points in §1.

### Step 9: Punctuation and spacing

| Latin | Tengwar |
|---|---|
| `,` `;` `:` | single pusta (one dot) |
| `.` | double pusta (two dots) |
| `!` | Tengwar exclamation mark |
| `?` | Tengwar question mark |

Put the mark straight after the word, as in Latin, then the space. Optionally end a whole text with the four-dot pusta. Quotation marks and digits are outside this mode description.

---

## 3. Consonant table

In this mode the columns (témar) are dental t, labial p, velar c/k and labio-velar qu. The rows are:

1. voiceless stops
2. nasal + voiced stop (nd, mb, ng, ngw)
3. voiceless fricatives
4. nasal + voiceless stop (nt, mp, nc, nqu)
5. nasals
6. weak consonants

(Wikipedia, *Tengwar*: "In the classical Quenya mode, row 1 represents voiceless stops, row 2 voiced prenasalized stops, row 3 voiceless fricatives, row 4 voiceless prenasalized stops, row 5 nasal stops, and row 6 approximants".)

| Latin | Tengwa | Condition / note |
|---|---|---|
| t | tinco | |
| tt | tinco + bar below | |
| ty | tinco + y-dots | |
| ts | tinco + s-hook | Recommended; alternative tinco, silmë (§10) |
| p | parma | |
| pp | parma + bar below | |
| ps | parma + s-hook | |
| c, k | calma | |
| cc | calma + bar below | |
| x (= cs, ks) | calma + s-hook | |
| qu (q, cw, kw) | quessë | Spelled as one consonant |
| nd | ando | |
| mb | umbar | |
| ng | anga | Medial ng = [ŋg] |
| ngw | ungwë | |
| th, þ | súlë (thúlë) | Only when the Latin spelling has th/þ. An s that comes from older þ is written silmë (§10). |
| f | formen | |
| h (word-initial, before a vowel or diphthong) | hyarmen | |
| h (anywhere else, e.g. ht) | harma (aha) | `tehtar` = tinco+e, harma, tinco+a, óre |
| ch (/x/, rare) | harma | |
| hw | hwesta | |
| hy | hyarmen + y-dots | Any position |
| hl | halla, lambe | Halla marks the voiceless l |
| hr | halla, rómen | |
| nt | anto | |
| mp | ampa | |
| nc, nk | anca | |
| nqu | unquë | |
| n | númen | |
| nn | númen + bar below | |
| ny | númen + y-dots | |
| nw (inside a word) | númen, vilya | `Elenwë`, `Voronwë` |
| nw (word-initial, old ñw) | nwalmë | |
| m | malta | |
| mm | malta + bar below | |
| my | malta + y-dots | |
| ñ | noldo | Only if the input writes ñ (`Ñoldo`). Plain n is númen (§10). |
| r (before a vowel or y) | rómen | |
| r (before a consonant or word-final) | óre | |
| rr | rómen + bar below | |
| ry | rómen + y-dots | |
| rd | arda | Overrides the óre rule |
| v | vala | |
| w | vilya | |
| y (word-initial or after a vowel) | anna + y-dots | |
| y (after a consonant) | y-dots under that consonant | |
| l | lambe | |
| ll | lambe + bar below | |
| ly | lambe + y-dots | |
| ld | alda | |
| lv | lambe, vala | lb: lambe, umbar |
| s (bearing a tehta, i.e. before a short vowel that does not start a diphthong) | silmë nuquerna | |
| s (elsewhere: before a consonant, a long vowel or a diphthong, or at the end) | silmë | |
| ss (bearing a tehta) | essë nuquerna | |
| ss (elsewhere) | essë | |
| z (archaic) | as ss | |
| d, b, g alone | ando / umbar / anga | Not Quenya; fallback only, flag them |

The **nasal bar above** is not used. Quenya's nasal + stop clusters all have their own tengwar (rows 2 and 4). Any other nasal + consonant sequence is written with the nasal tengwa itself.

---

## 4. Vowels

* **Tehtar sit above the consonant before the vowel.** Read each column as "consonant, then the vowel above it". For example, `ma` = malta+a.
* **Short carrier** (a short dotless stem, telco) holds a short vowel with no consonant directly before it: word-initial, after another vowel, or after a diphthong.
  * `Atan` = short carrier+a, tinco+a, númen.
  * `Tirion` = tinco+i, rómen+i, short carrier+o, númen.
* **Long carrier** (a long dotless stem, ára) holds every long vowel, with or without a consonant before it. The consonant before it carries no tehta.
  * `lúmë` = lambe, long carrier+u, malta+e.
  * `á` = long carrier+a.

  Tolkien does this in the 1968 Namárië: *Namárië*, *rámar*, *únótimë*, the second *yéni*. Appendix E calls it the usual method. The alternative is a doubled tehta (§10).
* **Diphthongs.** The first vowel is the tehta; the second vowel is a tengwa (the glide):
  * ai = yanta+a
  * oi = yanta+o
  * ui = yanta+u
  * au = úre+a
  * eu = úre+e
  * iu = úre+i

  So the tehta is read before the letter it sits on. Tolkien does this in *Ai!*, *laurië*, *nainië*, *luini* and *Oiolossëo*. The one exception in his manuscript is *caita*, where he put the a on calma.
* **y.**
  * After a consonant, y is two dots under that consonant, and the next vowel's tehta still goes on top: `Quenya` = quessë+e, númen+y-dots+a.
  * Elsewhere y is anna + two dots: `yéni`, `aiya`.
* **ë** is plain e, so `quëan` = quessë+e, short carrier+a, númen. A trema on i or u only stops a diphthong from forming (§2).

---

## 5. Consonant details in prose

* **r: óre or rómen.** The rule is the one in Tolkien's Namárië manuscripts: "óre represents r before consonants and word-finally, while rómen is used before vowels" (Björkman). Rómen also stays when the r is palatalised or long (ry, rr).
  * `Eldar` ends in óre.
  * `aurë` has rómen.
  * `Nerdanel` uses arda for rd.
  * rd = arda and ld = alda follow the letter names, Eldamo and the transcribers below. No word with these clusters in Tolkien's tengwar *Namárië* confirms them.
* **s: silmë or silmë nuquerna.** Appendix E says the turned forms were "much used" when a tehta stands on the letter, and both Namárië manuscripts do so. The program rule: nuquerna exactly when the s carries a vowel tehta.
  * `sinyë` and `Sindarin` begin with silmë nuquerna+i.
  * `síla` begins with silmë, then the long carrier.
* **ss: essë.** Appendix E: tengwa 31 "was in Quenya used for the very frequent ss of that language, and the name esse was given to it". It turns like silmë.
  * `esselya` = short carrier+e, essë nuquerna+e, lambe+y-dots+a.
* **h.**
  * Breath-h at the start of a word is **hyarmen**: `hantanyel`, `hísië`, `hiruva`.
  * Harma/aha "continued to be used for medial h", and that h is still [x] in **ht** (Telumehtar). So medial h, and always ht, is **harma**: `tehtar`, `ohtar`.
  * hy = hyarmen + y-dots.
  * hw = hwesta.
  * hl, hr = halla + lambe / rómen (Appendix E: halla "placed before a consonant to indicate that it was unvoiced and breathed").
* **v and w.** v = **vala**, w = **vilya**.
  * Tolkien's *vanwa* (DTS 20) = vala+a, númen, vilya+a.
  * The same pattern gives `Elenwë` and `Voronwë`: …númen, vilya+e.
* **Nasal + stop.** Use the row 2 and row 4 tengwar: nd, mb, ng, ngw → ando, umbar, anga, ungwë; nt, mp, nc, nqu → anto, ampa, anca, unquë.
  * Tolkien writes nqu with unquë in *enquantuva*, and anto appears in *lantar*, *lintë* and *tintilar* in the typeset specimen (§9.2).
* **Doubled consonants** take a bar below. On lambe the font draws the bar inside the bow, and it does the same with the y-dots (`nalyë`, `quetilyë`).
  * `atta` = short carrier+a, tinco+bar below+a.
  * `alla` = short carrier+a, lambe+bar below+a.

  Tolkien does this in *Altariello*. The exception is ss, which has its own letter, essë.
* **ts, ps, x** take the s-hook (sa-rincë) on tinco, parma and calma. Appendix E says it was used especially for ts, ps and ks (x), which Quenya favoured. A vowel after the s goes on the hooked letter.
  * `otso` = short carrier+o, tinco+s-hook+o.
  * No Quenya text in Tolkien's own tengwar shows an s-hook; the rule rests on Appendix E alone.

---

## 6. Punctuation

The usage follows Tolkien's Namárië (DTS 20) as catalogued by Björkman:

* **A single dot** is a short pause. Use it for the comma, and also for `;` and `:`. In the poem it also ends a verse line that has no other mark.
* **A double dot** (like a colon) is a full stop.
* **The wavy Tengwar exclamation mark** follows exclamations (*Ai!*, *Namárië!*).
* **The only Tengwar question mark** Tolkien wrote is in Namárië (*…enquantuva?*).
* **A four-dot diamond** marks a strong pause or the end of a text. It is optional in the book.

---

## 7. Capitals, apostrophes, hyphens, diaeresis

* **Capitals.** There are none, so write every word in the same letters. Fauskanger speaks of "Quenya capitals" for some proper names in the 1968 Namárië (Varda, Valimar …), but that is calligraphy, not a spelling rule.
* **Apostrophe of elision** (`lúmenn' omentielvo`). Drop it and spell the shortened word as written. `lúmenn'` ends in númen+bar below.
* **Hyphen.** Drop it and join the parts. The Namárië specimen writes *lissemiruvóreva* and *airetárilírinen* as single words.
* **Diaeresis** (ë, ä, ï …). It is only a Latin reading aid, so write the plain vowel. On i or u it also stops a diphthong.

---

## 8. Worked spellings

| Latin | Spelling (reading order) | Notes |
|---|---|---|
| aiya | yanta+a, anna+y-dots+a | ai is a diphthong (a on yanta). The following y is anna + dots, carrying the final a. |
| alla | short carrier+a, lambe+bar below+a | ll = bar below |
| namárië | númen+a, malta, long carrier+a, rómen+i, short carrier+e | Long á on the long carrier. ë follows a vowel, so it goes on a short carrier. |
| á na márië | long carrier+a / númen+a / malta, long carrier+a, rómen+i, short carrier+e | A lone long vowel = long carrier |
| mára | malta, long carrier+a, rómen+a | |
| quetilyë | quessë+e, tinco+i, lambe+y-dots+e | qu = quessë; ly = lambe + dots |
| quetin | quessë+e, tinco+i, númen | Final n = númen with no tehta |
| Quenya | quessë+e, númen+y-dots+a | No capital |
| Elda | short carrier+e, alda+a | ld = alda |
| Eldar | short carrier+e, alda+a, óre | Final r = óre |
| Atan | short carrier+a, tinco+a, númen | |
| Rúmil | rómen, long carrier+u, malta+i, lambe | r before a (long) vowel = rómen |
| Elenwë | short carrier+e, lambe+e, númen, vilya+e | Medial nw = númen + vilya |
| Nerdanel | númen+e, arda+a, númen+e, lambe | rd = arda |
| Voronwë | vala+o, rómen+o, númen, vilya+e | v = vala, w = vilya |
| Elendil | short carrier+e, lambe+e, ando+i, lambe | nd = ando |
| Tirion | tinco+i, rómen+i, short carrier+o, númen | io is not a diphthong |
| Valimar | vala+a, lambe+i, malta+a, óre | |
| Avallónë | short carrier+a, vala+a, lambe+bar below, long carrier+o, númen+e | |
| Endórë | short carrier+e, ando, long carrier+o, rómen+e | |
| Númenórë | númen, long carrier+u, malta+e, númen, long carrier+o, rómen+e | |
| Vanya | vala+a, númen+y-dots+a | |
| Noldo | númen+o, alda+o | Historic ñ is not shown (§10) |
| lúmë | lambe, long carrier+u, malta+e | |
| aurë | úre+a, rómen+e | au = úre + a |
| amaurë | short carrier+a, malta, úre+a, rómen+e | Malta takes no tehta before a diphthong |
| endaurë | short carrier+e, ando, úre+a, rómen+e | |
| apárilë | short carrier+a, parma, long carrier+a, rómen+i, lambe+e | |
| undómë | short carrier+u, ando, long carrier+o, malta+e | |
| sinyë | silmë nuquerna+i, númen+y-dots+e | s carries a tehta, so nuquerna |
| lómë | lambe, long carrier+o, malta+e | |
| minë | malta+i, númen+e | |
| atta | short carrier+a, tinco+bar below+a | |
| neldë | númen+e, alda+e | |
| canta | calma+a, anto+a | nt = anto |
| lempë | lambe+e, ampa+e | mp = ampa |
| enquë | short carrier+e, unquë+e | nqu = unquë |
| otso | short carrier+o, tinco+s-hook+o | ts = s-hook; alternative: short carrier+o, tinco, silmë nuquerna+o |
| tolto | tinco+o, lambe, tinco+o | |
| nertë | númen+e, óre, tinco+e | r before a consonant = óre |
| quëan | quessë+e, short carrier+a, númen | ë is plain e; ea is not a diphthong |
| hantanyel | hyarmen+a, anto+a, númen+y-dots+e, lambe | Initial h = hyarmen |
| manen | malta+a, númen+e, númen | |
| nalyë | númen+a, lambe+y-dots+e | |
| nanyë | númen+a, númen+y-dots+e | |
| esselya | short carrier+e, essë nuquerna+e, lambe+y-dots+a | ss = essë, turned under a tehta |
| essenya | short carrier+e, essë nuquerna+e, númen+y-dots+a | |
| tulin | tinco+u, lambe+i, númen | |
| tulilyë | tinco+u, lambe+i, lambe+y-dots+e | |
| síla | silmë, long carrier+i, lambe+a | s before a long vowel stays upright |
| elen | short carrier+e, lambe+e, númen | |
| lúmenn' omentielvo | lambe, long carrier+u, malta+e, númen+bar below / short carrier+o, malta+e, anto+i, short carrier+e, lambe, vala+o | Apostrophe dropped; ie is not a diphthong; lv = lambe, vala |
| mallo | malta+a, lambe+bar below+o | |
| Valimarello | vala+a, lambe+i, malta+a, rómen+e, lambe+bar below+o | |
| Tirionello | tinco+i, rómen+i, short carrier+o, númen+e, lambe+bar below+o | |
| ma | malta+a | |
| ná | númen, long carrier+a | |
| ui | yanta+u | A diphthong needs no carrier |
| tengwar | tinco+e, ungwë+a, óre | ngw = ungwë |
| tehtar | tinco+e, harma, tinco+a, óre | Medial h (ht) = harma |
| Sindarin | silmë nuquerna+i, ando+a, rómen+i, númen | |

---

## 9. Tolkien exemplars

### 9.1 Words from Tolkien's own tengwar that these rules reproduce

Source key:

* **DTS 20**: Tolkien's tengwar Namárië, *The Road Goes Ever On* (1968), pp. 57, 62.
* **F**: Fauskanger, *Namárië in Tengwar* (Ardalambion).
* **B**: Björkman, *Amanye Tenceli*, "Quenya mode" and "Punctuation".

| Tolkien's word | Spelling by these rules | What it attests | Sources |
|---|---|---|---|
| **Ai!** | yanta+a, exclamation mark | The ai diphthong is the a-tehta on yanta. Wavy exclamation mark. | DTS 20; F; B |
| **laurië** | lambe, úre+a, rómen+i, short carrier+e | au is the a-tehta on úre; rómen before a vowel; -ië puts its second vowel on a short carrier | DTS 20; F; B |
| **lantar** | lambe+a, anto+a, óre | Final r = óre ("óre first appears in lantar") | DTS 20; F |
| **Namárië** | númen+a, malta, long carrier+a, rómen+i, short carrier+e | The long á is "an ómatehta over a single long carrier" | DTS 20; F |
| **yéni** (second occurrence) | anna+y-dots, long carrier+e, númen+i | y = anna + dots; long é on the long carrier | DTS 20; F; B |
| **únótimë** | long carrier+u, númen, long carrier+o, tinco+i, malta+e | The word begins with a long carrier | DTS 20; F |
| **vanwa** | vala+a, númen, vilya+a | v = vala, medial w = vilya, nw = númen + vilya | DTS 20; F; B |
| **enquantuva** | short carrier+e, unquë+a, anto+u, vala+a | nqu = unquë | DTS 20; F |
| **Altariello** (title) | short carrier+a, lambe, tinco+a, rómen+i, short carrier+e, lambe+bar below+o | Bar below for ll | DTS 20; F |
| **luini** | lambe, yanta+u, númen+i | ui = the u-tehta on yanta | DTS 20; F |
| **Oiolossëo** | yanta+o, short carrier+o, lambe+o, essë nuquerna+e, short carrier+o | oi = the o-tehta on yanta | DTS 20; F; B (DTS 20 sometimes keeps essë upright under a tehta) |
| **máryat** | malta, long carrier+a, rómen+y-dots+a, tinco | ry = rómen + dots | DTS 20; F |
| **Sí man i yulma nin enquantuva?** | silmë, long carrier+i / malta+a, númen / short carrier+i / anna+y-dots+u, lambe, malta+a / númen+i, númen / short carrier+e, unquë+a, anto+u, vala+a, question mark | The only Tengwar question mark Tolkien wrote | DTS 20; B |

Known Tolkien deviations, which the book should not copy:

* **caita**: the a is on calma, not on yanta (DTS 20).
* **ómaryo**: no y-dots under rómen (DTS 20); written with óre in DTS 55.
* The **circumflex a** shape in DTS 20.
* **Doubled tehtar for long vowels** (except á) and **a written only when stressed** in DTS 55.
* *hísië* and *sindanóriello* have **silmë** where the etymology (older þ) would give súlë. The rule "follow the Latin spelling" agrees with Tolkien here.

### 9.2 Machine check against a typeset Namárië

This check compares the rules with another program's typesetting, not with Tolkien's calligraphy, so it shows agreement with tengwar.js rather than with Tolkien. In that specimen *ómaryo* has y-dots that Tolkien left out (§9.1).

A first implementation of these rules transcribed stanza 1:

> Ai! laurië lantar lassi súrinen, / yéni únótimë ve rámar aldaron! / Yéni ve lintë yuldar avánier / mi oromardi lissë-miruvóreva / Andúnë pella, Vardo tellumar / nu luini yassen tintilar i eleni / ómaryo airetári-lírinen.

It was rendered in Alcarin Tengwar and compared line by line with `samples/namarie.jpg` in Kris Kowal's tengwar.js 1.2.6, a typeset Namárië in Tengwar Parmaitë. All seven lines agree glyph for glyph: every consonant, carrier, tehta, y-dot, bar, essë nuquerna, óre/rómen choice, long carrier, and the joined compounds. The only difference is the stanza-final mark (`:·` in the specimen; `:` here).

---

## 10. Open choices and the recommendation for a beginners' book

| # | Point | Options | Recommendation and reason |
|---|---|---|---|
| 1 | Long vowels | (a) long carrier + tehta; (b) doubled tehta on the consonant before it, for é ó ú (and í in DTS 55), never á | **(a)**. Appendix E calls it the usual method, it is what DTS 20 mostly does, and it is one rule for all five vowels. A long vowel after a vowel needs a carrier anyway. |
| 2 | Shape of the a-tehta | three dots, or the quick circumflex (DTS 20, 62) | **Three dots**: the standard form and the font default (U+E040) |
| 3 | Leaving out a | Appendix E notes a frequent a could be left unwritten; DTS 55 writes a only when stressed or initial | **Always write a.** Beginners must be able to read every vowel. |
| 4 | Turned silmë/essë under a tehta | turned, or upright (DTS 20 sometimes keeps essë upright) | **Always turn it when a tehta stands on it.** Appendix E says "much used"; both Namárië manuscripts do it; it is a mechanical rule. |
| 5 | Medial h | harma (aha), or hyarmen | **Harma** for medial h and always in ht; **hyarmen** only word-initially. This follows the Outline of Phonology via Björkman, the Eldamo course and Glaemscribe. |
| 6 | r | Namárië rule (rómen before a vowel or y, óre elsewhere), or the older rule (óre between vowels) | **Namárië rule**, plus rd = arda. Third-Age usage, attested by Tolkien. |
| 7 | ts, ps, x | s-hook on tinco/parma/calma, or a separate silmë | **s-hook.** Appendix E names exactly these Quenya clusters; Eldamo and Glaemscribe do it; Alcarin draws it well. Fallback if a renderer misplaces it: tinco, silmë (nuquerna). |
| 8 | Nasal + consonant | row 2/4 tengwar (anto, ando …), or the nasal bar above | **Row 2/4 tengwar.** Tolkien's enquantuva uses unquë, and the bar is not needed for any Quenya cluster. Do not use the bar in the book. |
| 9 | v and w | v = vala, w = vilya; or vilya for every v that comes from older w (Fauskanger's etymological proposal) | **v = vala, w = vilya**, following the Latin letters. Tolkien himself wrote vala in avánier and in initial vanwa. |
| 10 | Historic ñ and þ (Noldo/Ñoldo, Isil/Iþil) | follow the Latin spelling, or restore noldo and súlë by etymology | **Follow the Latin spelling.** Use noldo and súlë only when the text itself writes ñ or th/þ. Tolkien wrote silmë in hísië and sindanóriello. |
| 11 | Initial nw | nwalmë (for old ñw), or númen + vilya | **nwalmë** only at the start of a word; inside words númen + vilya (Tolkien's vanwa). None of the course words needs nwalmë. |
| 12 | iu | úre+i (like the other diphthongs), or anna + y-dots + u for Third-Age rising iu (unattested speculation) | **úre+i**: consistent and attested as a pattern |
| 13 | lv | lambe, vala; or lambe, umbar (Appendix E notes lv was often pronounced lb) | **lambe, vala**, following the spelling |
| 14 | y-dots | two dots below, or three (DTS 55) | **Two dots** |
| 15 | Hyphens and apostrophes | drop and join, or keep as separate words | **Drop the hyphen and join the parts** (as the Namárië specimen does). **Drop the apostrophe** and keep the elided word separate. |
| 16 | Diphthong with aiya-type y | yanta+a, then anna+y-dots+a | **That spelling.** Two tehtar cannot stand on one letter, so the y needs its own anna. |
| 17 | o/u curl direction | o = right curl, u = left curl; some modes reverse them | **o = right curl (U+E04A), u = left curl (U+E04C)**, the usual assignment (Glaemscribe and tengwar.js default). Keep it consistent throughout the book. |

---

## Appendix A. Code points for the worked spellings (Alcarin Tengwar / Free Tengwar PUA)

`·` separates words.

| Latin | Code points |
|---|---|
| aiya | E02A E040 E016 E043 E040 |
| alla | E02E E040 E022 E051 E040 |
| namárië | E010 E040 E011 E02C E040 E020 E044 E02E E046 |
| á na márië | E02C E040 · E010 E040 · E011 E02C E040 E020 E044 E02E E046 |
| mára | E011 E02C E040 E020 E040 |
| quetilyë | E003 E046 E000 E044 E022 E043 E046 |
| quetin | E003 E046 E000 E044 E010 |
| Quenya | E003 E046 E010 E043 E040 |
| Elda | E02E E046 E023 E040 |
| Eldar | E02E E046 E023 E040 E014 |
| Atan | E02E E040 E000 E040 E010 |
| Rúmil | E020 E02C E04C E011 E044 E022 |
| Elenwë | E02E E046 E022 E046 E010 E017 E046 |
| Nerdanel | E010 E046 E021 E040 E010 E046 E022 |
| Voronwë | E015 E04A E020 E04A E010 E017 E046 |
| Elendil | E02E E046 E022 E046 E004 E044 E022 |
| Tirion | E000 E044 E020 E044 E02E E04A E010 |
| Valimar | E015 E040 E022 E044 E011 E040 E014 |
| Avallónë | E02E E040 E015 E040 E022 E051 E02C E04A E010 E046 |
| Endórë | E02E E046 E004 E02C E04A E020 E046 |
| Númenórë | E010 E02C E04C E011 E046 E010 E02C E04A E020 E046 |
| Vanya | E015 E040 E010 E043 E040 |
| Noldo | E010 E04A E023 E04A |
| lúmë | E022 E02C E04C E011 E046 |
| aurë | E02B E040 E020 E046 |
| amaurë | E02E E040 E011 E02B E040 E020 E046 |
| endaurë | E02E E046 E004 E02B E040 E020 E046 |
| apárilë | E02E E040 E001 E02C E040 E020 E044 E022 E046 |
| undómë | E02E E04C E004 E02C E04A E011 E046 |
| sinyë | E025 E044 E010 E043 E046 |
| lómë | E022 E02C E04A E011 E046 |
| minë | E011 E044 E010 E046 |
| atta | E02E E040 E000 E051 E040 |
| neldë | E010 E046 E023 E046 |
| canta | E002 E040 E00C E040 |
| lempë | E022 E046 E00D E046 |
| enquë | E02E E046 E00F E046 |
| otso | E02E E04A E000 E059 E04A |
| tolto | E000 E04A E022 E000 E04A |
| nertë | E010 E046 E014 E000 E046 |
| quëan | E003 E046 E02E E040 E010 |
| hantanyel | E028 E040 E00C E040 E010 E043 E046 E022 |
| manen | E011 E040 E010 E046 E010 |
| nalyë | E010 E040 E022 E043 E046 |
| nanyë | E010 E040 E010 E043 E046 |
| esselya | E02E E046 E027 E046 E022 E043 E040 |
| essenya | E02E E046 E027 E046 E010 E043 E040 |
| tulin | E000 E04C E022 E044 E010 |
| tulilyë | E000 E04C E022 E044 E022 E043 E046 |
| síla | E024 E02C E044 E022 E040 |
| elen | E02E E046 E022 E046 E010 |
| lúmenn' omentielvo | E022 E02C E04C E011 E046 E010 E051 · E02E E04A E011 E046 E00C E044 E02E E046 E022 E015 E04A |
| mallo | E011 E040 E022 E051 E04A |
| Valimarello | E015 E040 E022 E044 E011 E040 E020 E046 E022 E051 E04A |
| Tirionello | E000 E044 E020 E044 E02E E04A E010 E046 E022 E051 E04A |
| ma | E011 E040 |
| ná | E010 E02C E040 |
| ui | E02A E04C |
| tengwar | E000 E046 E007 E040 E014 |
| tehtar | E000 E046 E00A E000 E040 E014 |
| Sindarin | E025 E044 E004 E040 E020 E044 E010 |

---

## Sources

**Primary**

* J.R.R. Tolkien, *The Lord of the Rings*, Appendix E, "Writing": tengwar values, tehtar, carriers, essë, silmë nuquerna, halla, the s-hook. Quoted here through Björkman and Eldamo.
* J.R.R. Tolkien and Donald Swann, *The Road Goes Ever On* (1968), the tengwar Namárië (DTS 20).

**Mode descriptions**

* Måns Björkman, *Amanye Tenceli*, "Quenya mode" and "Tengwar Punctuation": http://at.mansbjorkman.net/teng_quenya.htm, https://at.boktypografen.se/teng_quenya.htm, https://at.boktypografen.se/teng_punctuation.htm
* Helge K. Fauskanger, *Namárië in Tengwar*, an analysis of Tolkien's calligraphy: https://ardalambion.net/namteng.pdf
* Paul Strack, *Eldamo: Introduction to Quenya*, ch. 4–5 (Tengwar): https://eldamo.org/intro-quenya/eldamo-intro-quenya-04.html, https://eldamo.org/intro-quenya/eldamo-intro-quenya-05.html
* Wikipedia, "Tengwar": https://en.wikipedia.org/wiki/Tengwar
* Tolkien Gateway, "Quenya mode" and "Tehta": https://tolkiengateway.net/wiki/Quenya_mode, https://tolkiengateway.net/wiki/Tehta
* Ivan Derzhanski, *TengTeX* documentation, Quenya mode: https://ykf.ca.distfiles.macports.org/CTAN/macros/plain/contrib/tengtex/tengdoc.tex

**Transcribers checked against**

* Benjamin Babut (Talagan), Glaemscribe mode `quenya-tengwar-classical.glaem` v0.9.12: https://raw.githubusercontent.com/BenTalagan/glaemscribe/master/glaemresources/modes/quenya-tengwar-classical.glaem. Also checked the Python port glaemscribe 0.2.0 on PyPI.
* Kris Kowal, tengwar.js 1.2.6 (`classical.js`, `test/classical.js`, `editor/modes.html`, `samples/namarie.jpg`): https://registry.npmjs.org/tengwar/-/tengwar-1.2.6.tgz

**Encoding and font**

* Free Tengwar Font Project, character mapping: https://freetengwar.sourceforge.net/mapping.html
* Toshi Omagari, Alcarin Tengwar README: https://raw.githubusercontent.com/Tosche/Alcarin-Tengwar/main/README.md
* The repo font `fonts/AlcarinTengwar-Regular.woff2` (cmap and GPOS inspected).
