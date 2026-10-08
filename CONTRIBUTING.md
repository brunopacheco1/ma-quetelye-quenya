<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)

SPDX-License-Identifier: CC-BY-4.0
-->

<!-- omit in toc -->

# Contributing to Ma Quetelyë Quenya?

Thank you for wanting to help! ❤️

*Ma Quetelyë Quenya?* is written by a community of Quenya learners, Tolkien
linguists, teachers, artists and developers. You don't need to be a Quenya expert
or a programmer to help: there are tasks for reviewers, writers, translators,
illustrators, voice recorders and developers.

<!-- omit in toc -->
## Contents

- [How the project is organised](#how-the-project-is-organised)
- [Ground rules for all content](#ground-rules-for-all-content)
- [Ways to contribute](#ways-to-contribute)
- [How to pick up a task](#how-to-pick-up-a-task)
- [Review process](#review-process)
- [Community meetings](#community-meetings)
- [Making decisions](#making-decisions)
- [Technical guide](#technical-guide)
- [Credit and licensing](#credit-and-licensing)
- [Code of Conduct](#code-of-conduct)

## How the project is organised

- **Coordinator:** Bruno Pacheco ([@brunopacheco1](https://github.com/brunopacheco1))
  runs the project. He triages issues, assigns tasks, runs the meetings and
  approves every merge.
- **Chapters** are the files `docs/carince_1.qmd` to `docs/carince_6.qmd`. Each
  chapter has a parent issue on GitHub, split into smaller tasks (sub-issues),
  each sized for one person and one pull request.
- **Worked example:** the draft pull request
  [#36](https://github.com/brunopacheco1/ma-quetelye-quenya/pull/36) shows what a
  full chapter looks like (dialogues, grammar boxes, exercises, audio script and
  image prompts). It stays open as a draft for everyone to comment on and improve.
- **Everything happens on GitHub:** issues for tasks, pull requests for changes,
  and discussions for questions and decisions.

## Ground rules for all content

1. **Chapters are written only in Quenya.** English, Portuguese and other
   languages appear only in the introductions (`docs/<lang>/intro.qmd`) and in
   the neologism notes (`docs/<lang>/neologisms.qmd`). Image alt text is the one
   exception, because it must be readable with a screen reader.
2. **[Eldamo](https://eldamo.org/) is the source of truth for every Quenya word.**
   For every word you add, link its Eldamo entry and mark it as one of these:
   - **attested:** Tolkien wrote this form.
   - **reconstructed:** built from attested material, as Eldamo records it.
   - **neologism:** a modern coinage, explained in the neologism notes.

   Never invent a word. If Eldamo has nothing usable, open an issue with the
   `vocabulary` label and the coordinator will decide.
3. **Cite your sources** for any other linguistic claim (for example
   *Parma Eldalamberon* or *The History of Middle-earth*).
4. **Languages stay in parallel.** If you change an introduction or a neologism
   note in one language, change it in the others too, or say in your pull request
   which languages still need the change.
5. **Pedagogy first.** Lessons follow the structure of *Schwätzt Dir
   Lëtzebuergesch?*: short, practical, communicative steps built around real-life
   situations and pictures, with grammar kept light.

These rules come from the project
[constitution](.specify/memory/constitution.md).

## Ways to contribute

Each task type below has a GitHub label, so you can filter the issues for the
kind of work you like.

### Quenya review (`review`)

Check a chapter or a pull request word by word against Eldamo. Confirm each
word's status (attested, reconstructed or neologism), its grammar and its
meaning. Suggest corrections as review comments on the pull request.
*You need:* a good working knowledge of Quenya and Eldamo.

### Pedagogy review (`review`)

Check that a lesson flows well for a beginner. Are new words introduced before
they are used? Does each exercise practise what the lesson just taught? Is the
level right for that point in the book?
*You need:* teaching or language-learning experience. Little Quenya is needed.

### Writing lesson content (`dialogue`, `grammar`, `exercises`, `vocabulary`)

Write one part of a chapter:

- **Vocabulary list:** the chapter's words, each with its Eldamo link and status.
- **Dialogues and texts:** short, everyday scenes using the chapter's words.
- **Grammar and pronunciation boxes:** short tables and examples.
- **Exercises and answer key:** practice for each part of the lesson.

Start from the chapter's spec issue, which lists the topics, grammar points and
words for that chapter.
*You need:* solid Quenya. Every text you write gets a Quenya review.

### Translation (`translation`)

Translate and keep up to date the introductions and neologism notes in English,
Portuguese or a new language (see [Adding a new language](#adding-a-new-language)).
*You need:* fluency in the target language.

### Illustration (`images`)

Draw the pictures for dialogues and exercises. Each chapter has image
descriptions (prompts) in `raw_images/prompts/` that say what each picture must
show.

- Submit your original artwork as PNG or JPG, at least 1600 px wide, and keep
  your source file in case changes are needed.
- Give each image alt text in English and in Portuguese.
- Images are published under CC-BY-4.0 (see
  [Credit and licensing](#credit-and-licensing)).
- If you used any generative tool, say so in the pull request.

### Audio recording (`audio`)

Record the dialogues and pronunciation examples. Each chapter has a recording
script that lists every recording, its text and its file name.

- Record in a quiet room, one file per recording, named as in the script.
- Use WAV or FLAC at 44.1 kHz or 48 kHz. Don't add music or effects.
- Follow the pronunciation guide for the chapter. A Quenya reviewer listens to
  every recording before it is merged.
- Recordings are published under CC-BY-4.0, credited with the name you choose.

### Technical work (`tech`)

Help with the Quarto build, the website, accessibility, CI, PDF and EPUB output,
or scripts. See the [Technical guide](#technical-guide).

### Reporting problems

Found a wrong word, a typo or a broken page? Open an issue and say where it is
(chapter and section, or page link) and what you think is wrong. This is
one of the most useful contributions, and a good first step.

## How to pick up a task

1. Browse the [open issues](https://github.com/brunopacheco1/ma-quetelye-quenya/issues).
   Issues labelled `help wanted` are ready to take, and `good first issue` marks
   small ones for newcomers.
2. Comment on the issue, for example "I'd like to take this". The coordinator
   assigns it to you. Please take one task at a time until it is in review.
3. Ask questions on the issue whenever something is unclear.
4. Open a pull request that says `Closes #<issue number>` in its description.
   Open it as a **draft** early if you want feedback before you finish.
5. If you can't continue, just say so on the issue. That's fine! If an assigned
   task has no activity for three weeks, the coordinator asks how it's going,
   and after another week may unassign it so someone else can pick it up.

**Not comfortable with Git?** You can still help. Attach your text, images or
recordings to the issue, and a maintainer will add them in a pull request that
credits you.

## Review process

Every change is merged through a pull request. Reviews are the core of this
project, because they keep the Quenya accurate.

### Who reviews what

| Change | Required reviews (besides the coordinator) |
|---|---|
| Lesson text (dialogues, grammar, exercises, vocabulary) | 1 Quenya review + 1 pedagogy review |
| Neologism notes | 1 Quenya review + 1 review per language changed |
| Introductions and other translations | 1 review by a fluent speaker of that language |
| Audio | 1 Quenya review (pronunciation) |
| Images | 1 review that the picture matches its prompt and its alt text |
| Technical changes | 1 technical review |

The author of a pull request can't review it themselves.

### Steps

1. **Author:** open the pull request and fill in its checklist. Check the
   preview of the rendered book linked on the pull request.
2. **Automatic checks:** every pull request is built with Quarto and checked for
   license headers (REUSE). Fix any failing check, and ask for help if you're
   stuck.
3. **Reviewers:** volunteer on the pull request, or the coordinator asks someone.
   Leave comments, suggest changes inline, then mark the pull request as
   **Approve** or **Request changes**. Please try to respond within one week.
4. **Author:** address each comment, either by making the change or by replying
   with a reason.
5. **Coordinator:** once the required reviews have approved it and the checks pass,
   the coordinator does a final read and merges.

### Review checklist

- Every new Quenya word links to Eldamo and is marked attested, reconstructed or
  neologism.
- The chapter text has no language other than Quenya. Alt text is the one
  exception.
- New words and grammar are introduced before they are used.
- Exercises have answers in the answer key.
- Neologisms and introductions are updated in every language, or the missing
  languages are listed.
- New files have a REUSE license header or annotation.
- The rendered preview looks right, including at 200% zoom, and images have alt
  text.

### Disagreements

For word forms, Eldamo decides. When Eldamo leaves room for interpretation, or
for questions of style and pedagogy, discuss it on the pull request. If you
can't agree, the question goes to a [decision](#making-decisions).

## Community meetings

- **Monthly community call:** an online video call of up to one hour, once a
  month. The date and the link are announced in GitHub Discussions at least a
  week before, with a poll if the time needs to change.
- **Agenda:** what was done since the last call, open decisions, tasks that
  need people, and questions from newcomers. Anyone can add an item to the
  agenda thread before the call.
- **Notes:** the coordinator posts short notes and decisions in the same
  discussion thread after the call, so anyone who couldn't join can catch up.
- **Async status:** between calls, a short status update is posted in
  Discussions every two weeks: what's done, what's in review, and what's
  waiting for someone.

Nothing is decided only on the call. Anything decided there is posted in
Discussions and stays open for comments for a week.

## Making decisions

Some choices affect the whole book, such as the setting and characters, a
spelling convention, or how to handle a word Eldamo lacks.

1. Anyone can propose one in GitHub Discussions (category **Decisions**) or in an
   issue labelled `decision`.
2. Everyone has at least a week to comment.
3. The coordinator decides, explains why, and records the decision in the style
   guide or the constitution.

## Technical guide

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/)
- A TeX distribution for the PDF output (`quarto install tinytex` is the easiest)
- Optionally, [`reuse`](https://reuse.software/) to check license headers locally

### Workflow

1. Fork the repository and create a branch, for example
   `git checkout -b chapter-2-dialogues`.
2. Make your changes in the relevant `.qmd` files.
3. Preview the book while you edit:

   ```bash
   quarto preview                 # English edition
   quarto preview --profile pt    # Portuguese edition
   ```

4. Before you open a pull request, render every edition and check it:

   ```bash
   quarto render
   quarto render --profile pt
   reuse lint
   ```

5. Commit with a semantic message (see below), push to your fork and open a pull
   request.

Never commit generated or cache folders (`_book/`, `_site/`, `.quarto/`,
`.specify/extensions/.cache/`).

Maintainers plan larger features with [Spec Kit](https://github.com/github/spec-kit)
(see [specs/](specs/README.md)). You don't need it to contribute: the chapter's
spec issue gives you everything you need.

### Adding a new language

The book uses **Quarto profiles** for each language. Chapters are shared by
every language, so a new language only needs its own introduction, table of
contents and neologism notes:

1. Create `docs/<lang>/` with `intro.qmd`, `toc.qmd` and `neologisms.qmd`
   (copy them from `docs/en/`).
2. Create the profile file `_quarto-<lang>.yml` (copy `_quarto-pt.yml`).
3. Open an issue first, so the coordinator can plan the publishing and keep the
   language in parallel with the others.

### Semantic commit messages

The `CHANGELOG.md` is generated from commit messages, so please start each one
with a prefix:

- `feat:` new lessons or features (listed under **Added**)
- `fix:` corrections and typo fixes (listed under **Fixed**)
- `sec:` or `security:` security updates (listed under **Security**)
- `deprecate:` or `remove:` deprecations and removals
- `chore:`, `docs:`, `style:`, `test:`, `ci:`, `build:`, `refactor:`, `perf:`
  internal changes (listed under **Changed**)

*Example:* `git commit -m "fix: correct the plural of lassë in chapter 2"`

## Credit and licensing

- Everyone who contributes is credited in the book's contributors list, whatever their
  role (reviewers, illustrators and voices included).
- The project follows the [REUSE specification](https://reuse.software/). Every
  file has a license header, a `.license` file next to it, or an entry in
  `REUSE.toml`.
- **Creative content** (lessons, texts, exercises, images, audio, translations)
  is licensed under
  [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).
- **Code** (scripts, configuration, build and site tooling) is licensed under
  [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0).

By contributing, you agree that your contribution is published under the
matching license, and that you have the right to share it (it is your own work,
or it was already published under a compatible license).

## Code of Conduct

Please be respectful and constructive. We want a welcoming place for everyone
who loves Tolkien's languages, from first-time learners to experts. See the
[Code of Conduct](CODE_OF_CONDUCT.md).
