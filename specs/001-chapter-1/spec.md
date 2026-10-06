# Feature Specification: Chapter 1 – Aiya! (greetings and introductions)

**Feature Branch**: `claude/project-thread-giui4h`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "The book is about learning Luxembourgish at European standard A1 level, divided in 6 chapters. Let's exercise your capacity to write a language learning book, in Quenya, without checking the book yet. You will review and draft the first chapter with more exercises and dialogs. Add references to recorded dialogs. For images, you must build prompts that will use later to generate images with image generators."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Learn the first words of Quenya from the chapter alone (Priority: P1)

A complete beginner opens chapter 1 and, with nothing but the pictures, the
dialogues, the pattern tables and the recordings, learns to greet and say
goodbye (formally and informally), to greet at each time of day, to ask and
tell a name, to say where they come from and which people they belong to, to
say which language they speak, and to count from one to ten. The chapter is in
Quenya only; when the reader needs a translation of a word, the word list at
the end links each word to its entry in Eldamo.

**Why this priority**: This is the chapter's reason to exist. Without it the
exercises, recordings and pictures have nothing to support.

**Independent Test**: Give the chapter to a reader who knows no Quenya and ask
them to greet, introduce themselves and count to ten; they can do it using only
the chapter and the Eldamo links.

**Acceptance Scenarios**:

1. **Given** a reader on the greetings section, **When** they read the two
   dialogues and listen to the recordings, **Then** they can tell apart the
   informal pair (*Alla* / *mesta*) from the formal pair (*Aiya* /
   *Namárië*).
2. **Given** the "Mana esselya?" section, **When** the reader follows the
   pattern table, **Then** they can produce *Essenya ná …* with their own name.
3. **Given** the "Mallo tulilyë?" section, **When** the reader follows the
   pattern table for *-llo / -ello*, **Then** they can say where they come
   from using one of the places taught.
4. **Given** any Quenya word in the chapter, **When** the reader looks it up in
   the *Quettar* list, **Then** it links to its Eldamo entry and shows its
   attestation mark.

---

### User Story 2 - Practise and check (Priority: P2)

The reader works through the exercises at the end of the chapter: listening
and matching, gap filling, putting a dialogue in order, answering questions on
the dialogues, writing about themselves, counting, pronunciation drill and a
role play with a partner. An answer key lets them check themselves.

**Why this priority**: A1 textbooks teach through practice; this is what the
current chapter lacks most.

**Independent Test**: A reader completes every exercise using only the chapter
and compares with the answer key.

**Acceptance Scenarios**:

1. **Given** the gap-fill exercise, **When** the reader fills every gap,
   **Then** every answer is a word that appears earlier in the chapter.
2. **Given** the answer key, **When** the reader opens it, **Then** it covers
   every exercise that has a single correct answer.

---

### User Story 3 - Hear every dialogue (Priority: P3)

Every dialogue, word list and pronunciation table carries a recording
reference (🔊 and a number). On the website the recording plays in place; in
the PDF and EPUB the reference still identifies the recording. A recording
script tells the voice actors what to record.

**Why this priority**: Recordings are how a reader of a Quenya-only book learns
the sound of the language, but they can be produced after the text.

**Independent Test**: Every 🔊 reference in the chapter has a matching entry
in the recording script, and the script contains the exact lines to record.

**Acceptance Scenarios**:

1. **Given** the chapter, **When** the recordings do not exist yet, **Then**
   the chapter still renders in all formats and the references remain readable.
2. **Given** a recording file placed at the path the script names, **When**
   the website is rebuilt, **Then** the player for that reference plays it.

---

### User Story 4 - Produce the pictures (Priority: P4)

An illustrator or the maintainer finds, for every picture the chapter needs, a
ready-to-use image-generation prompt, the target file name, and the alt text
in English and Portuguese. Screen-reader users hear the alt text in the
language of the edition they are reading.

**Why this priority**: Pictures carry meaning in a Quenya-only chapter, but
they can be generated after the text is agreed.

**Independent Test**: Each picture referenced by the chapter has a prompt
entry, and each rendered edition exposes alt text in its own language.

**Acceptance Scenarios**:

1. **Given** the Portuguese edition, **When** a screen reader reaches a
   picture in chapter 1, **Then** it reads Portuguese alt text.
2. **Given** the prompts file, **When** an image is generated from a prompt,
   **Then** the prompt forbids any written text in the image, so that no
   non-Quenya text enters the chapter.

---

### Edge Cases

- A word the chapter needs has no Eldamo entry: it is not used, and the gap is
  flagged to Bruno instead of being filled with an invented word.
- A word exists only as a Neo-Quenya neologism, a reconstruction, or in an
  early layer of the language: it may be used, but its mark says so.
- A recording file is missing: the reference and the dialogue text are still
  complete; only the player is silent.
- The reader uses a screen reader on a shared Quenya-only chapter: alt text is
  the one place where the reader's language appears.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The chapter body (headings, captions, dialogues, instructions,
  tables, exercises, answer key) MUST contain Quenya only. Image alt text is
  the one exception and MUST be in the reader's language.
- **FR-002**: Every Quenya word used in the chapter MUST appear in the
  *Quettar* list with a link to its Eldamo entry and an attestation mark using
  Eldamo's notation (Q., ᴹQ., ᴱQ., ᴺQ., `*`, `#`).
- **FR-003**: The chapter MUST contain at least four full dialogues and a set
  of short time-of-day exchanges, each with a recording reference.
- **FR-004**: The chapter MUST contain at least seven exercises covering
  listening, gap filling, ordering, comprehension questions, writing about
  oneself, counting, pronunciation and speaking with a partner, plus an answer
  key for every exercise with a single correct answer.
- **FR-005**: The chapter MUST teach the numbers one to ten and a
  pronunciation table of vowels, diphthongs and the spellings *c*, *qu* and
  *y*, each row with example words from the chapter and a recording reference.
- **FR-006**: A recording script MUST list every recording reference with its
  file path, speakers and the exact lines, and the repository MUST document
  the recording naming convention.
- **FR-007**: An image-prompts file MUST give, for each picture of the
  chapter, the target file name, the prompt (with a "no text" constraint) and
  the alt text in English and Portuguese.
- **FR-008**: The English and Portuguese introductions MUST explain how to
  read the book (Quenya-only chapters, the 🔊 reference, the Eldamo marks,
  where the answers are), and both tables of contents MUST describe chapter 1.
  Both languages are changed in the same change.
- **FR-009**: `quarto render` MUST pass for both profiles, and `reuse lint`
  MUST pass.

### Key Entities

- **Dialogue**: a numbered exchange between named characters, with a scene, a
  recording reference and a place in the chapter.
- **Recording reference**: a chapter-scoped number (1.1, 1.2, …) that names
  one audio file and one entry in the recording script.
- **Vocabulary entry**: a Quenya word, its Eldamo page and its attestation
  mark.
- **Picture**: an image file, its Quenya caption, its prompt and its alt text
  per language.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reader can complete all exercises using only the chapter, the
  recordings and the Eldamo links.
- **SC-002**: 100% of the Quenya words in the chapter are in the *Quettar* list
  with an Eldamo link.
- **SC-003**: Zero English or Portuguese words remain in the chapter body
  (checked by reading the rendered page and by searching for the former
  glosses).
- **SC-004**: Both editions render in HTML, PDF and EPUB without errors.
- **SC-005**: Every picture in the chapter has alt text in both English and
  Portuguese.
- **SC-006**: Every 🔊 reference in the chapter matches exactly one entry in
  the recording script.

## Assumptions

- The reference book is not consulted (per Bruno's request); the chapter
  follows the general shape of an A1 first lesson: greetings, names, origin,
  numbers, pronunciation, exercises.
- Only the polite second person (*-lyë*, *elyë*) is taught in chapter 1; the
  familiar forms come later.
- The characters are named after figures of the legendarium (Rúmil, Elenwë,
  Nerdanel, Voronwë, Elendil) for the sake of attested, pronounceable names;
  the chapter does not claim to follow their stories, and the scene is set in
  Avallónë, where Elves and Men met.
- *mesta* (ᴱQ.) is kept as the informal farewell already present in the
  chapter, marked as Early Qenya, pending Bruno's decision.
- The book title *Ma Quetelyë Quenya?* is not changed by this feature; the
  chapter uses the regular aorist form *quetilyë* (cf. attested *carilyë*,
  *tulil*), and the discrepancy is raised with Bruno separately.
- Recordings and generated images are produced later; this feature delivers
  the text, the references, the script and the prompts.
