<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

# Style guide

The choices *Ma Quetilyë Quenya?* has made, so that six chapters written by
many people read as one book. The [constitution](.specify/memory/constitution.md)
holds the rules (Quenya-only chapters, Eldamo, parallel editions, licences);
this guide holds the choices made under those rules. To change one, propose a
decision as [CONTRIBUTING.md](CONTRIBUTING.md#making-decisions) describes; the
coordinator records the outcome here, with the date.

## Contents

- [The book](#the-book)
- [Setting and cast](#setting-and-cast)
- [Words and forms](#words-and-forms)
- [Pronunciation standard](#pronunciation-standard)
- [Tengwar](#tengwar)
- [Pictures](#pictures)
- [Audio](#audio)
- [Editions](#editions)
- [Open decisions](#open-decisions)
- [Decisions log](#decisions-log)

## The book

- **Title:** *Ma Quetilyë Quenya?* "Do you speak Quenya?", with the regular
  aorist *quetilyë* (Tolkien's aorist in *-i-*, PE18 p. 86, PE22 p. 95; the
  plural *quetir* PE17 p. 167). The older form *Quetelyë* is not used.
- **Chapters are *parandë*** "lesson", a Neo-Quenya word recorded in
  [Eldamo](https://eldamo.org/content/words/word-1387298955.html?neo) (from
  *par-* "to learn"). Chapter files are `docs/parande_N.qmd`, the prompt
  files `raw_images/prompts/parande_N.md` and the audio folders
  `audio/parande_N/`; most pictures start with `parande_N_`.
- **Chapter shape** (chapter 1 is the model): a few topic sections, each built
  around a picture, a dialogue with an **Á lasta!** recording reference and a
  pattern table; then *Lammar* (the sounds introduced, with example words),
  *Tengwar* (the letters introduced), *Carië* (exercises, ending with a
  Tengwar reading and a Tengwar writing exercise) with the answers under
  *Hanquentar*, and the word lists
  *Quettar* (words) and *Essi* (names), each entry linked to Eldamo.
- **Section titles are in Quenya**, like everything else in a chapter. Grammar
  is shown in pattern tables (stem, then the ending in bold), not explained in
  prose; explanations belong in the editions' introductions.
- **Model:** the structure of *Schwätzt Dir Lëtzebuergesch?* A1: short,
  practical, communicative steps around everyday situations, grammar kept
  light.

## Setting and cast

- **Present day, in Avallónë**, a small harbour town where Quenya is simply the
  language people speak. Contemporary clothes, streets and furniture. Place
  names are attested ones: Avallónë, Valimar, Tirion, Endórë, Númenórë.
- **One story across the six chapters** (proposed): one Quenya season per
  chapter, from *yávië* to *lairë*. Elendil comes off the ferry alone in
  chapter 1; the book ends on the same quay when the ferry brings his family.
- **The cast**, drawn once and kept: Rúmil, the elderly Elf who teaches the
  class (round glasses, half-up silver hair, taupe cardigan); Elenwë, a young
  Vanya from Valimar, new in town (mustard yellow, golden hair); Nerdanel, a
  Noldo from Tirion and Elenwë's old friend (sage green, copper curls);
  Voronwë, a Noldo from Endórë and an officer on the ferry (navy coat with
  gold trim); Elendil, a Man from Númenórë, just off the ferry (camel coat,
  grey-brown beard, round ears). Elves have long pointed ears, Men round ones.
- The full descriptions, the style block, the town and the story arc proposal
  are in the [picture guide](raw_images/prompts/README.md). The five story
  questions at its end are still open (see [Open decisions](#open-decisions)).

## Words and forms

### Eldamo is the source of truth

Every Quenya word, form and gloss is checked against
[Eldamo](https://eldamo.org/) and linked to its entry. Nothing is invented
silently.

**How to look up a word and mark it**

1. Search the word on Eldamo. Neo-Quenya entries appear only when the site's
   *neo* mode is on; their links end in `?neo`, as the chapter 1 word list
   shows.
2. Read the entry's language mark and prefer a form from Tolkien's later
   Quenya (Q.). If only an older form exists, see the era policy under
   [Open decisions](#open-decisions) and say so in your pull request.
3. Copy the entry's address and add the word to the chapter's *Quettar* table
   (names go in *Essi*), with the mark as the link text:

   ```markdown
   | *aurë* | [Q.](https://eldamo.org/content/words/word-3521740537.html) |
   | *apárilë* | [NQ.](https://eldamo.org/content/words/word-1057275467.html?neo) |
   ```

**The marks**, in Eldamo's own notation, as the editions' introductions explain
them to readers:

| Mark | Meaning |
|---|---|
| **Q.** | a word from Tolkien's later Quenya (from *The Lord of the Rings* on) |
| **MQ.** | from his "Middle Quenya" writings of the 1930s and 1940s |
| **EQ.** | from his early "Qenya" of the 1910s and 1920s |
| **NQ.** | a Neo-Quenya neologism recorded by Eldamo |
| `*` | a reconstructed or extrapolated form (`Q.*`) |
| `#` | a word attested only inside a longer word or name (`Q.#`) |

### Neologisms

- A Neo-Quenya word recorded by Eldamo may be used and is marked **NQ.**;
  Eldamo names its author and explains how it was formed.
- The neologism notes say the book coins no words of its own (*parandë*
  replaced our earlier coinage *carincë*). One title still needs checking:
  *Cariquettar*, the heading of an empty page at the end of the book. If a
  chapter needs a word that neither Tolkien nor Eldamo
  provides, propose it in the pull request that introduces it: mark it as a
  neologism, explain its formation with Eldamo links in the neologism notes of
  your edition (`docs/<lang>/neologisms.qmd`), list the other editions as
  pending, and say why it is needed. It is reviewed in that pull request; no
  separate issue.

### Forms the book has settled

- **Farewells:** *Namárië* (formal), *Á na márië!* (informal). *Mesta* is not
  used: it is Early Qenya only.
- **Greetings:** *Aiya* (formal), *Alla* (informal).
- **Aorist and present:** the aorist for general and habitual statements
  (*quetin Quenya* "I speak Quenya"), the present only for what is happening
  right now.
- **Stem and ending** are shown in pattern tables with the ending in bold, as
  in chapter 1.

## Pronunciation standard

The book, its recordings and the Quenya-TTS voice all follow **Third Age Quenya
as Tolkien describes it in Appendix E of *The Lord of the Rings***, the Quenya
of the Noldor in Middle-earth. Where Appendix E is silent, Eldamo's
pronunciation notes and Tolkien's later writings decide, weighed by era; the
coordinator's four readings of 10 October 2026 settle the points below that
Appendix E leaves open.

### Vowels

| Spelling | Sound | Notes |
|---|---|---|
| a, á | [a], [aː] | the same quality long and short |
| e, é | [ɛ], [eː] | the long vowel is closer and tenser |
| i, í | [i], [iː] | |
| o, ó | [ɔ], [oː] | the long vowel is closer and tenser |
| u, ú | [u], [uː] | |
| ë, ä, ö | as e, a, o | the dieresis only says that the vowel is pronounced separately; it never changes the sound (*lómë* has two syllables, *Eärendil* four) |

Long vowels (with an acute) are held about twice as long as short ones, in
every position.

### Diphthongs

*ai, au, eu, oi, ui* are falling diphthongs (the stress on the first vowel);
*iu* is rising, [ju], as in English *yule*. Every other pair of vowels is two
syllables (*ëa, ëo, oa, ië, ua*).

### Consonants

| Spelling | Sound | Notes |
|---|---|---|
| c, k | [k] | always, as in *cat*: *canta*, *cenda*, *Tulkas* |
| qu | [kw] | as in *queen*; one letter in Tengwar, but two sounds, so it counts as two consonants for stress |
| x | [ks] | |
| y | [j] | always a consonant, as in *yes*: *yávië*, *aiya*. After *t*, *n* or *l* it is part of the palatals below |
| v | [v] | |
| w | [w] | inside a word (*Elenwë*). A word-initial *w* in older spellings is read [v], as *vilya*, "older *wilya*" |
| s | [s] | always voiceless |
| th, þ | [s] | the Noldor's sound: *Isil*, *súlë*. Words that Eldamo lists with [þ], such as *sinyë*, are read with s |
| z | [r] | *áze* = *áre*; the Third Age had no z |
| h | [h] | *h* standing alone (not in *ht, hy, hw, hl, hr*) is breath h in every position, as in *house*: *aha*, *mahalma* |
| ht | [xt], after e or i [çt] | *ohtar* as in Scots *loch*; *ehtelë* as in German *echt* |
| hy | [ç] | as in English *huge*: *hyarmen* |
| hw | [ʍ] | voiceless w, as in *white* for speakers who distinguish it |
| hl, hr | [l], [r] | the Third Age pronunciation of *hlócë*, *hrívë* |
| ty, ny, ly | [c], [ɲ], [ʎ] | single palatal sounds, as in Hungarian *ty*, Spanish *ñ*, Portuguese *lh*: *tyelpë*, *Quenya*, *quetilyë*. Between vowels they still make the syllable before them heavy (see Stress) |
| ñ, ng at the start of a word | [n] | *Ñoldo* is read *Noldo* |
| n before c, k, qu, g | [ŋ] | as in *finger*: *ancalima* |
| ng inside a word | [ŋg] | as in *finger*, never as in *singer* |
| r | trilled [r] | in every position, as in Spanish or Italian |
| l, m, n, p, t, d, f, b, g | as in English | |
| double consonants | long | hold them, as in Italian *fatto*: *Elessar*, *alla* |

### Stress

The stressed syllable is in capitals below.

- A word of two syllables stresses the first: *EL-da*, *QUE-nya*.
- A longer word stresses the second-to-last syllable when that syllable is
  heavy: it has a long vowel (*e-len-TÁ-ri*, *un-DÓ-më*), a diphthong
  (*a-MAU-rë*), or a vowel followed by two or more consonants (*i-SIL-dur*).
- Otherwise the stress goes one syllable further back: *an-CA-li-ma*,
  *VA-li-mar*, *a-PÁ-ri-lë*.
- For this count, *qu*, *x*, *ng* and a consonant followed by *y* or *w* count
  as two consonants (*a-ta-RIN-ya*, *hi-ru-VAL-yë*); *hl*, *hr* and *th* count
  as one. This is Eldamo's weighting. Tolkien's own stress marks on *Namárië*
  in *The Road Goes Ever On* put the stress on *hi-ru-VAL-yë* and *ó-MAR-yo*,
  which confirms it, and the coordinator kept it on 16 October 2026.
- An apostrophe marks an elided vowel (*lúmenn' omentielvo*); the two words
  are run together.

### What is not standard

Appendix E lists the mistakes Men made (*ty* as English *ch*, *hy* as *sh*,
long *é* and *ó* as the diphthongs of *day* and *go*). They are not used.
Archaic or Vanyarin pronunciations (*th* as [θ], initial *ñ* as [ŋ], initial
*w* as [w], *z* as [z]) are not used either; the spellings are read with their Third
Age sounds, as above.

### In a chapter

A chapter's *Lammar* table lists the sounds it introduces with one or two
example words each, as chapter 1 does (`| **au** | aurë, amaurë |`); it gives no English or
IPA, because chapters are Quenya-only. The recording of the table carries the
pronunciation. This guide is where contributors and voices read the rules.

## Tengwar

- Every chapter has a short *Tengwar* section that introduces only the letters
  that chapter needs; *Carië* then has one reading and one writing exercise
  for them. Chapter 1 introduces the vowel marks (*tehtar*) on the short and
  long stems and *númen, malta, lambë, rómen, órë* (exercises 9 and 10).
- The spelling mode is the **Quenya mode of Appendix E**, as in the *Namárië*
  calligraphy: vowels as *tehtar* above the consonant they follow, a short stem
  for a vowel with no consonant before it, a long stem for a long vowel. The
  rules the `tengwar` filter implements are in
  [`specs/001-chapter-1/tengwar-mode.md`](specs/001-chapter-1/tengwar-mode.md),
  with tests in `tests/tengwar_test.lua`.
- Write Tengwar from Latin spelling with `[word]{.tengwar}` and a letter name
  with `[númen]{.tengwa}`. **Always show the Latin spelling beside a Tengwar
  word** (the next table cell, or the website's hover text, which the
  `.no-title` class turns off for reading exercises), because some e-readers
  drop the font.
- Open: *rd* and *ld* as *arda* and *alda*, and the *s*-hook, are not confirmed
  by Tolkien's Quenya samples. Chapter 1 avoids both; avoid them until a
  decision says otherwise.

## Pictures

- **One style, one town, one cast**, as the [picture guide](raw_images/prompts/README.md)
  describes. Every picture is checked against the cast sheet (the right people,
  clothes and ears) before it is merged.
- **Pictures are a separate task** for each chapter, with its own sub-issue
  (`images`), so that a chapter's text does not wait on its pictures.
- **Generated pictures are placeholders.** The chapter 1 pictures were generated
  with Gemini from the prompts in the guide to show what the book should look
  like; some still do not match the cast or the prompt. An illustrator may fix
  them, replace them with hand-drawn pictures in the same style, or write and
  check prompts for the coordinator to run through the generator. In every
  case the review checks the result against the prompt, the cast sheet and the
  alt text, and the pull request says which generative tool was used, if any.
- **Nothing is written inside a picture.** Labels and titles in Quenya or
  Tengwar are added in an image editor afterwards; the unlabelled original is
  kept in `raw_images/unlabelled/`. Speech bubbles appear only on dialogue
  panels and are empty.
- **Alt text in every edition**, in the edition's language, in each
  `_quarto-<lang>.yml` and in the chapter's prompt file; editions still
  missing are listed in the pull request for translators. It describes what is
  seen; it is the one place in a chapter that is not Quenya.
- **Files:** `raw_images/<name>.jpeg` with a `.license` sidecar (CC-BY-4.0, the
  artist's name), compressed to `images/` with `compress_images.py`. Scenes are
  16:9, the cover 2:3, at least 1600 px wide.

## Audio

- **Standard:** the [pronunciation standard](#pronunciation-standard) above.
- **Masters:** WAV at 48 kHz, as the Quenya-TTS recorder writes them, one file
  per track, in a quiet room with the same setup for every session; no noise
  removal, music or effects. The masters go to Quenya-TTS as training data, as
  issue
  [#38](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/38)
  describes.
- **Published tracks:** an MP3 per track in `audio/parande_N/`, named as in the
  chapter's `SCRIPT.md`, with a `.license` sidecar naming the speaker, in the
  format [`audio/README.md`](audio/README.md) gives.
- **Consent first:** before a voice's first recording is merged, the voice has
  signed the consent and licence form of #38 (being written in #46) (CC-BY-4.0, and permission to use
  the recordings to train a public synthetic voice). Recordings are credited
  with the name the speaker chooses.
- **One voice per character** across the whole book where possible; a speaker
  may voice several characters.
- **Synthetic audio** fills a track only when no human recording exists, the
  coordinator accepts it after a Quenya reviewer has listened, and the sidecar
  says it is synthetic.

## Editions

- The book is published in several language editions that share the Quenya
  chapters. Only `docs/<lang>/intro.qmd`, `docs/<lang>/credits.qmd`,
  `docs/<lang>/toc.qmd`, `docs/<lang>/neologisms.qmd`, and the alt text and
  role names in `_quarto-<lang>.yml` are written in an edition's language.
  English and Portuguese are the current editions, not the only possible ones.
- Every edition has a **credits page** after the introduction. Its list of
  people is built from [CONTRIBUTORS.md](CONTRIBUTORS.md), grouped by role, so
  CONTRIBUTORS.md stays the one list; the edition only translates the page's
  text and the role names (`credits-roles` in `_quarto-<lang>.yml`).
- A change to a per-language file is made in every edition, or the editions
  still missing are listed in the pull request so that translators can pick
  them up.
- The website serves the default edition at the root and every other edition
  at `/<lang>/`; the PDF and EPUB of each edition are attached to every release.

## Open decisions

In the order they block work. Process: CONTRIBUTING.md,
[Making decisions](CONTRIBUTING.md#making-decisions).

1. **Syllabus for chapters 2 to 6**: topics and grammar per chapter.
2. **Story arc**: the five questions at the end of the picture guide
   (Elendil's job, the seasons, kinship words or new names, the look of
   Elendil's partner, the length of the week).
3. **Era policy**: chapter 1 already uses seven words Eldamo marks MQ.
   (*istyar, lamma, mallo, minë, nótë, sinyë, tec-*). Keep them, replace them
   where Tolkien's later Quenya has a word, and how to treat new MQ. and EQ.
   words?
4. **Tengwar details**: *rd*, *ld*, the *s*-hook.

## Decisions log

| Date | Decision |
|---|---|
| 2026-10-05 | Chapters Quenya-only; Eldamo the source of truth; CC-BY-4.0 content and Apache-2.0 code; the structure of *Schwätzt Dir Lëtzebuergesch?* (constitution 1.0.0) |
| 2026-10-09 | The book has any number of language editions; neologisms are proposed and reviewed in the pull request that introduces them; Spec Kit is for maintainers |
| 2026-10-10 | Pronunciation: archaic spellings read with Third Age sounds (*th* [s], initial *ñ* [n], initial *w* [v], *z* [r]); *h* standing alone is [h] everywhere; *ty, ny, ly* single palatals; Eldamo's weighting of digraphs for stress |
| 2026-10-13 | Title *Ma Quetilyë Quenya?* with the regular aorist; chapters are *parandë*; present-day Avallónë with the five-character cast; *Á na márië!* as the informal farewell; the aorist for habitual statements; a Tengwar section per chapter in the Appendix E Quenya mode, Latin shown beside every Tengwar word |
| 2026-10-16 | Digraphs keep counting as two consonants for stress (RGEO marks); status posts on a pinned issue; pictures as a separate sub-issue per chapter, generated pictures are placeholders; Code of Conduct reports through GitHub issues; WAV 48 kHz masters, MP3 published; CI builds every language profile; a shared credits page in every edition, built from CONTRIBUTORS.md |
