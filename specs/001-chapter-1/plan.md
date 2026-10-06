# Implementation Plan: Chapter 1 – Aiya! (greetings and introductions)

**Branch**: `claude/project-thread-giui4h` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-chapter-1/spec.md`

## Summary

Rewrite `docs/carince_1.qmd` from two word lists into a full A1 first lesson in
Quenya only: five dialogues plus time-of-day exchanges, pattern tables for the
grammar, numbers one to ten, a pronunciation table, eight exercises and an
answer key, and a word list that links every word to Eldamo with its
attestation mark. Recordings and pictures are referenced now and produced
later: a recording script and an image-prompts file are part of the feature.
Alt text is supplied per language through a small Pandoc filter so that the
shared chapter stays Quenya-only.

## Technical Context

**Language/Version**: Quarto Markdown (Quarto 1.10), Lua 5.4 (Pandoc filter)

**Primary Dependencies**: Quarto book project with the `en` and `pt` profiles; Pandoc raw HTML for the audio players; Eldamo data (`eldamo-data.xml`, CC-BY-4.0) for every vocabulary check

**Storage**: Files in the repository (`docs/`, `images/`, `raw_images/`, `audio/`, `filters/`, `specs/`)

**Testing**: `quarto render --profile en` and `--profile pt` (HTML, PDF, EPUB); `reuse lint`; `lintquarto -l pylint -p .`; manual read of the rendered chapter for stray non-Quenya text; EPUB unzipped to confirm alt text and the absence of audio elements

**Target Platform**: GitHub Pages site (HTML), release PDF and EPUB

**Project Type**: Quarto book (content, not software)

**Performance Goals**: N/A

**Constraints**: Chapter body Quenya-only; every word checked against Eldamo; EN and PT per-language files changed together; REUSE headers on every new file; recordings and generated images not yet available

**Scale/Scope**: One chapter (~400 lines of Quarto Markdown), one filter, two profile files, two intros, two tables of contents, one recording script, one prompts file, three placeholder images

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | How this feature complies |
|-----------|---------------------------|
| I. Quenya-Only Chapters | The chapter has no English or Portuguese, including captions and exercise instructions. Alt text, the one exception, is injected per profile by `filters/alt-text.lua` from `_quarto-en.yml` / `_quarto-pt.yml`. |
| II. Eldamo Is the Source of Truth | Every word was looked up in Eldamo's data file; [research.md](research.md) records the entry, layer and mark for each. The chapter's word list links each word to its Eldamo page and shows the mark. No new word is coined, so the neologism pages are unchanged. |
| III. Languages in Parallel | The intro and the table of contents are changed in EN and PT in the same commit; alt text is given in both profiles for every image. |
| IV. Pedagogy First | Dialogues, pictures and pattern tables instead of grammar prose; short exercises; recordings for every dialogue. |
| V. Open and REUSE-Compliant | New Lua filter is Apache-2.0 (tooling); chapter, prompts, script and placeholder images are CC-BY-4.0 with headers or `.license` sidecars; `specs/**` is covered by `REUSE.toml`. |
| VI. Accessible Output | Alt text in the reader's language; heading order kept; tables have header rows; render checked in all three formats for both profiles. |
| VII. Clean Repository | No generated folder is committed; `_book/` stays ignored. |

Post-design re-check: no violation. The filter is the only new tooling and it exists precisely to satisfy principles I, III and VI together.

## Project Structure

### Documentation (this feature)

```text
specs/001-chapter-1/
├── plan.md              # This file
├── research.md          # Eldamo check of every word, and the design decisions
├── spec.md
├── tasks.md
└── checklists/
    └── requirements.md
```

### Source Code (repository root)

```text
docs/carince_1.qmd            # the chapter (shared by both profiles)
docs/en/intro.qmd             # "How to read this book" section
docs/pt/intro.qmd             # same, in Portuguese
docs/en/toc.qmd               # chapter 1 row and table header
docs/pt/toc.qmd               # same, in Portuguese
filters/alt-text.lua          # per-language alt text from profile metadata
_quarto.yml                   # registers the filter and the audio resources
_quarto-en.yml, _quarto-pt.yml  # alt-text maps
audio/README.md               # recording conventions
audio/carince_1/SCRIPT.md     # what to record for chapter 1
raw_images/prompts/carince_1.md  # image-generation prompts and alt texts
raw_images/carince_1_*.png    # placeholders until the pictures are generated
images/carince_1_*.jpg        # compressed copies, as compress_images.py would produce
```

**Structure Decision**: Keep the existing single-chapter-file layout. New
cross-cutting pieces (filter, audio folder, prompts folder) get their own
top-level folders so later chapters reuse them.

## Design decisions

1. **Where the meanings go.** Chapters carry no translations. Each word of the
   chapter is listed at its end with a link to its Eldamo page, which gives
   the gloss. The intro explains this in each language.
2. **Attestation marks.** The word list uses Eldamo's layers and marks in
   plain ASCII (`Q.`, `MQ.`, `EQ.`, `NQ.`, `*`, `#`) so that they render in
   every format; the intro maps them to Eldamo's own notation.
3. **Recordings.** Each recording is referred to as *Á lasta!* plus a
   chapter-scoped number (1.1, 1.2, …). The file lives at
   `audio/carince_<chapter>/<chapter>-<track>.mp3`. On HTML an `<audio>`
   element is emitted inside `::: {.content-visible when-format="html"
   unless-format="epub"}`; PDF and EPUB show only the reference (checked: a
   plain `when-format="html"` leaks into the EPUB). `_quarto.yml` lists
   `audio/**/*.mp3` as project resources so files are published once they
   exist.
4. **Alt text.** A Pandoc Lua filter reads an `alt-text` map (image file name
   → text) from the document metadata, which the profile files supply, and
   sets `alt` and `fig-alt` on every matching image. Checked in HTML and
   EPUB.
5. **Setting and characters.** A present-day world where Quenya is a living
   language, drawn in the book's existing watercolour-and-ink style. Cities
   and lands use attested names (Tirion, Valimar, Alqualondë, Avallónë,
   Endórë, Númenórë). Characters borrow attested names (Rúmil the teacher,
   Elenwë, Nerdanel, Voronwë, Elendil) without following their stories.
6. **Grammar in chapter 1.** Only what the dialogues need: *ná-* with the
   endings *-n* and *-lyë*; the possessives *-nya* and *-lya*; the ablative
   *-llo / -ello*; yes/no questions with *ma* answered by *ná* / *ui*; the
   negative *lá*. Only the polite second person is taught.
7. **Pictures.** Three new pictures are referenced; until they are generated
   from the prompts, neutral placeholder images keep the render green.

## Complexity Tracking

No constitution violations to justify.
