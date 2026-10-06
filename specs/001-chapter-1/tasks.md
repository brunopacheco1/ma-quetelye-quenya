# Tasks: Chapter 1 – Aiya! (greetings and introductions)

**Input**: Design documents from `/specs/001-chapter-1/`

**Prerequisites**: plan.md, spec.md, research.md

**Tests**: No automated tests were requested. The gates are the renders, `reuse lint` and the checks listed under Polish.

**Organization**: Tasks are grouped by user story so each story can be delivered on its own.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Tooling the chapter relies on

- [x] T001 Add `filters/alt-text.lua` (Apache-2.0) that applies per-profile alt text by image file name
- [x] T002 Register the filter and `audio/**/*.mp3` resources in `_quarto.yml`
- [x] T003 [P] Add `audio/README.md` with the recording naming and licensing convention

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Every word the chapter will use is checked before it is written

- [x] T004 Look up every candidate word and form in Eldamo's data file; record layer, mark and page in `specs/001-chapter-1/research.md`
- [x] T005 Replace or drop words with no Eldamo entry (*aparilë* → *apárilë*; no invented place names; *quetilyë* for the aorist)

**Checkpoint**: Vocabulary fixed; the chapter can be written

---

## Phase 3: User Story 1 - Learn the first words of Quenya (Priority: P1) 🎯 MVP

**Goal**: A Quenya-only chapter that teaches greetings, times of day, names, origin, people, language and numbers through dialogues and pattern tables

- [x] T006 [US1] Rewrite `docs/carince_1.qmd`: greetings section with two dialogues (informal, formal) and *Á lasta!* references
- [x] T007 [US1] Time-of-day section: word list, six greetings, three short exchanges
- [x] T008 [US1] "Mana esselya?" section: dialogue, *essë* + *-nya/-lya*, *ná-* table
- [x] T009 [US1] "Mallo tulilyë?" section: dialogue, ablative table, verb table, *ma … ? ná / ui*
- [x] T010 [US1] "Nóti" section: numbers one to ten
- [x] T011 [US1] "Lammar" section: vowels, diphthongs, *c*, *qu*, *y* with example words from the chapter
- [x] T012 [US1] "Quettar" and "Essi" lists generated from the research data with Eldamo links and marks

**Checkpoint**: Chapter readable end to end; every word in the lists

---

## Phase 4: User Story 2 - Practise and check (Priority: P2)

- [x] T013 [US2] Eight exercises under "Carië": listen and write, fill in, order, answer, write about yourself, numbers, listen and repeat, speak with a partner
- [x] T014 [US2] Answer key under "Hanquentar" as a collapsible callout

---

## Phase 5: User Story 3 - Hear every dialogue (Priority: P3)

- [x] T015 [US3] Audio block for every reference (1.1–1.10) with an HTML-only player
- [x] T016 [P] [US3] `audio/carince_1/SCRIPT.md` with speakers, lines and file names for every reference

---

## Phase 6: User Story 4 - Produce the pictures (Priority: P4)

- [x] T017 [P] [US4] `raw_images/prompts/carince_1.md`: art direction, prompts, file names and alt texts (EN, PT) for every picture of the chapter
- [x] T018 [US4] `alt-text` maps in `_quarto-en.yml` and `_quarto-pt.yml` for the five pictures
- [x] T019 [P] [US4] Placeholder images `raw_images/carince_1_*.png` and `images/carince_1_*.jpg` with `.license` sidecars, so the render passes until the pictures are generated

---

## Phase 7: Polish & Cross-Cutting Concerns

- [x] T020 [P] "How to read this book" in `docs/en/intro.qmd` and `docs/pt/intro.qmd`
- [x] T021 [P] Chapter 1 row and table header in `docs/en/toc.qmd` and `docs/pt/toc.qmd`
- [x] T022 `quarto render --profile en` and `--profile pt` (HTML, PDF, EPUB) pass
- [x] T023 `reuse lint` and `lintquarto -l pylint -p .` pass
- [x] T024 Read the rendered chapter for stray non-Quenya text; check alt text per edition; confirm the EPUB has no `<audio>` element

---

## Dependencies & Execution Order

- Setup (T001–T003) and Foundational (T004–T005) come first; T005 blocks every chapter task.
- US1 (T006–T012) is the MVP. US2 depends on US1's dialogues. US3's script (T016) depends on the final dialogue text. US4's alt texts (T018) depend on the prompts (T017).
- Polish runs last; T022–T024 are the gates before the PR.

## Notes

- Open points for Bruno are listed in research.md: *mesta* (EQ.), the book title's *Quetelyë*, and the kindred/places setting.
