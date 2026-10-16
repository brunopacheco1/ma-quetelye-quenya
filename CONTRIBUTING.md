<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

<!-- omit in toc -->

# Contributing to Ma Quetilyë Quenya?

Thank you for wanting to help! ❤️

*Ma Quetilyë Quenya?* is written by a community of Quenya learners, Tolkien
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
- **Chapters** are the files `docs/parande_1.qmd` to `docs/parande_6.qmd`. Each
  chapter has a parent issue on GitHub, split into smaller tasks (sub-issues),
  each sized for one person and one pull request. The [roadmap](ROADMAP.md)
  says how a chapter is split and what comes next.
- **Worked example:** chapter 1 ([`docs/parande_1.qmd`](docs/parande_1.qmd),
  published at <https://ma-quetilye-quenya.tolkien.lu/>) shows what a full
  chapter looks like: dialogues, grammar tables, pronunciation and Tengwar
  sections, exercises with an answer key, pictures, word lists and a recording
  script. It has had no independent Quenya review yet, so reviewing it is one
  of the first tasks.
- **The [style guide](STYLE_GUIDE.md)** records the choices the book has made:
  setting and cast, words and forms, the pronunciation standard, Tengwar,
  pictures, audio. Follow it, and propose changes through a
  [decision](#making-decisions).
- **Many languages, one book:** the book is published in several language
  editions. The editions share the same Quenya chapters; only the introduction,
  the credits page, the table of contents, the neologism notes and the alt text
  of the pictures are written in each edition's language. The current editions are English and Portuguese, and new languages
  are welcome (see [Adding a new language](#adding-a-new-language)).
- **Everything happens on GitHub:** issues for tasks, questions and decisions,
  pull requests for changes, and the pinned **Project status** issue for news
  and meeting dates.

## Ground rules for all content

1. **Chapters are written only in Quenya.** The languages of the editions
   appear only in the introductions (`docs/<lang>/intro.qmd`), the credits
   pages (`docs/<lang>/credits.qmd`), the tables of contents
   (`docs/<lang>/toc.qmd`) and the neologism notes
   (`docs/<lang>/neologisms.qmd`). Image alt text is the one exception, because
   it must be readable with a screen reader; it lives in each edition's
   `_quarto-<lang>.yml`.
2. **[Eldamo](https://eldamo.org/) is the source of truth for every Quenya word.**
   For every word you add, link its Eldamo entry and give it Eldamo's mark,
   which says whether the word is:
   - **attested:** Tolkien wrote this form (Q., MQ. or EQ., by period).
   - **reconstructed:** built from attested material, as Eldamo records it
     (marked `*`).
   - **a neologism:** a modern coinage (NQ.), explained in the neologism notes.

   The [style guide](STYLE_GUIDE.md#words-and-forms) explains every mark,
   including `#`, and shows how to look a word up. Never invent a word
   silently. If Eldamo has nothing
   usable, propose a neologism directly in your pull request: mark it as a
   neologism, explain how it is formed (roots and Eldamo links) in the neologism
   notes, and say why it is needed. It is reviewed in that pull request like
   the rest of your change. No separate issue is needed.
3. **Cite your sources** for any other linguistic claim (for example
   *Parma Eldalamberon* or *The History of Middle-earth*).
4. **Languages stay in parallel.** If you change an introduction, a neologism
   note or alt text in one language, change it in every other edition too, or
   say in your pull request which languages still need the change, so that
   translators can pick it up.
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
word's mark (attested, reconstructed or neologism, in Eldamo's notation), its
grammar and its meaning. Suggest corrections as review comments on the pull request.
*You need:* a good working knowledge of Quenya and Eldamo.

### Pedagogy review (`review`)

Check that a lesson flows well for a beginner. Are new words introduced before
they are used? Does each exercise practise what the lesson just taught? Is the
level right for that point in the book?
*You need:* teaching or language-learning experience. Little Quenya is needed.

### Writing lesson content (`vocabulary`, `dialogue`, `grammar`, `exercises`, `tengwar`)

Write one part of a chapter:

- **Vocabulary list:** the chapter's words, each with its Eldamo link and mark.
- **Dialogues and texts:** short, everyday scenes using the chapter's words,
  with the cast and setting of the style guide.
- **Grammar and pronunciation boxes:** short tables and examples. Pronunciation
  follows the standard in the style guide.
- **Exercises and answer key:** practice for each part of the lesson.
- **Tengwar section:** the letters the chapter needs, in the mode the style
  guide describes, with a reading and a writing exercise in *Carië*.

Start from the chapter's spec issue, which lists the topics, grammar points and
words for that chapter, and from chapter 1, which shows each of these parts.
*You need:* solid Quenya. Every text you write gets a Quenya review.

### Translation (`translation`)

Translate and keep up to date the introduction, credits page, table of
contents, neologism notes and image alt text of one edition. You can join an existing edition
(currently English and Portuguese) or start a new one (see
[Adding a new language](#adding-a-new-language)).
*You need:* fluency in the target language.

### Illustration (`images`)

Draw, fix or check the pictures for dialogues and exercises. Each chapter has
its own pictures task (a sub-issue), and image descriptions (prompts) in
`raw_images/prompts/` that say what each picture must show. The
[picture guide](raw_images/prompts/README.md) gives the style, the town and the
cast.

- The chapter 1 pictures were generated with Gemini as a demonstration and
  some still do not match the cast or the prompt. They are placeholders: you
  can fix them, replace them with hand-drawn pictures in the same style, or
  write and check prompts for the coordinator to run through the generator.
- Submit artwork as JPG or PNG, at least 1600 px wide, with nothing written
  inside the picture (labels are added afterwards in an image editor). Keep
  your source file in case changes are needed.
- Describe each image in a short alt text, in any edition's language.
  Translators add it to the other editions.
- Every picture is reviewed against its prompt, the cast sheet and its alt
  text before it is merged.
- Images are published under CC-BY-4.0 (see
  [Credit and licensing](#credit-and-licensing)).
- If you used any generative tool, say so in the pull request.

### Audio recording (`audio`)

Record the dialogues and pronunciation examples. Each chapter has a recording
script (`audio/parande_<chapter>/SCRIPT.md`) that lists every recording, its
text and its file name. Volunteer voices are coordinated in issue
[#38](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/38).

- Before your first recording, sign the consent and licence form of #38: your
  recordings are published under CC-BY-4.0, credited with the name you choose,
  and they also train the open Quenya voice of
  [Quenya-TTS](https://github.com/brunopacheco1/Quenya-TTS), so you agree in
  writing to that use. The form ([#46](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/46))
  and the recording instructions ([#47](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/47))
  are still being written: until they exist, sign up on #38, and no recording
  can be accepted yet.
- Record in a quiet room with the same setup every time, one file per
  recording, named as in the script. Masters are WAV at 48 kHz, with no noise
  removal, music or effects; the recording instructions say where to send
  them. You hand in the WAV masters only: a maintainer makes the MP3 files and
  their `.license` sidecars, as [`audio/README.md`](audio/README.md) describes,
  and opens the pull request that credits you.
- Follow the [pronunciation standard](STYLE_GUIDE.md#pronunciation-standard)
  in the style guide. A Quenya reviewer listens to every recording before it
  is merged.

### Technical work (`tech`)

Help with the Quarto build, the website, accessibility, CI, PDF and EPUB output,
or scripts. See the [Technical guide](#technical-guide).

### Reporting problems

Found a wrong word, a typo or a broken page? Open an issue with the
**Quenya error or typo** form and say where it is (chapter and section, or
page link) and what you think is wrong. This is one of the most useful
contributions, and a good first step.

## How to pick up a task

1. Browse the [open issues](https://github.com/brunopacheco1/ma-quetilye-quenya/issues).
   Issues labelled `help wanted` are ready to take, and `good first issue` marks
   small ones for newcomers.
2. Comment on the issue, for example "I'd like to take this". The coordinator
   assigns it to you. Please take one task at a time until it is in review.
3. Ask questions on the issue whenever something is unclear.
4. Open a pull request that says `Closes #<issue number>` in its description
   and fill in the checklist of the pull request template. Open it as a
   **draft** early if you want feedback before you finish.
5. If you can't continue, just say so on the issue. That's fine! If an assigned
   task has no activity for three weeks, the coordinator asks how it's going,
   and after another week may unassign it so someone else can pick it up.

**Not comfortable with Git?** You can still help. Attach your text or images
to the issue (recordings go through #38), and a maintainer will add them in a
pull request that credits you.

## Review process

Every change is merged through a pull request. Reviews are the core of this
project, because they keep the Quenya accurate.

### Who reviews what

| Change | Required reviews (besides the coordinator) |
|---|---|
| Lesson text (dialogues, grammar, exercises, vocabulary, Tengwar section) | 1 Quenya review + 1 pedagogy review |
| New neologisms and neologism notes | 1 Quenya review of the coinage + 1 review per language changed, in the same pull request |
| Introductions and other translations | 1 review by a fluent speaker of that language |
| Audio | 1 Quenya review (pronunciation) |
| Images | 1 review that the picture matches its prompt, the cast sheet and its alt text |
| Technical changes | 1 technical review |

The author of a pull request can't review it themselves. While a kind of
reviewer has only one volunteer, that person's own pull requests cannot get the
review they need: the pull request says so, the coordinator's review counts in
its place, and the chapter's parent issue notes that the change still needs an
independent review.

### Steps

1. **Author:** open the pull request and fill in its checklist, then check
   the rendered book. A pull request from a branch of this repository gets a
   preview link. One from a fork does not, because GitHub gives forks a
   read-only token: download the `book` artifact of the pull request's
   **Test** run (on its Checks tab), or run `quarto preview --profile <lang>`
   locally.
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

The pull request template repeats this list as checkboxes.

- Every new Quenya word links to its Eldamo entry and carries its mark (Q.,
  MQ., EQ., NQ., `*`, `#`), as the style guide says.
- The chapter text has no language other than Quenya. Alt text is the one
  exception.
- New words and grammar are introduced before they are used.
- Exercises have answers in the answer key.
- Each new neologism is justified (Eldamo has nothing usable), built from
  attested roots with Eldamo links, and explained in the neologism notes.
- Per-language files (introductions, neologism notes, alt text) are updated in
  every edition, or the missing editions are listed.
- New files have a REUSE license header, a `.license` sidecar or a `REUSE.toml`
  entry, and the REUSE check passes.
- The rendered book (preview link, the Test run's `book` artifact or a local
  render) looks right, including at 200% zoom, and images have alt text.
- The author's line is in `CONTRIBUTORS.md`, and any generative tool used is
  named in the pull request.

### Disagreements

For word forms, Eldamo decides. When Eldamo leaves room for interpretation, or
for questions of style and pedagogy, discuss it on the pull request. If you
can't agree, the question goes to a [decision](#making-decisions).

## Community meetings

- **Monthly community call:** an online video call of up to one hour, once a
  month. The date and the link are announced on the pinned **Project status**
  issue at least a week before, with a poll if the time needs to change.
- **Agenda:** what was done since the last call, open decisions, tasks that
  need people, and questions from newcomers. Anyone can add an item by
  commenting on the **Project status** issue before the call.
- **Notes:** the coordinator posts short notes and decisions on the same
  issue after the call, so anyone who couldn't join can catch up.
- **Async status:** between calls, a short status update is posted every two
  weeks as a comment on the pinned **Project status** issue: what's done,
  what's in review, and what's waiting for someone.

Nothing is decided only on the call. Anything decided there is posted on
GitHub and stays open for comments for a week.

## Making decisions

Some choices affect the whole book, such as the setting and characters, a
spelling convention, or whether older (MQ. and EQ.) words may be used.

1. Anyone can propose one by opening an issue whose title starts with
   "Decision:"; the coordinator labels it `decision`. (GitHub Discussions,
   category **Decisions**, can be used too once it is enabled.)
2. Everyone has at least a week to comment.
3. The coordinator decides, explains why, and records the decision in the
   [style guide](STYLE_GUIDE.md) or the constitution. The open decisions are
   listed at the end of the style guide.

## Technical guide

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/)
- A TeX distribution for the PDF output (`quarto install tinytex` is the easiest)
- [`reuse`](https://reuse.software/), to run `reuse lint` locally (the Test
  check runs it on every pull request too)

### Workflow

1. Fork the repository and create a branch, for example
   `git checkout -b chapter-2-dialogues`.
2. Make your changes in the relevant `.qmd` files.
3. Preview the book while you edit:

   ```bash
   quarto preview                     # default edition (English)
   quarto preview --profile <lang>    # another edition, e.g. pt
   ```

4. Before you open a pull request, render every edition and check it:

   ```bash
   quarto render                      # default edition (English)
   quarto render --profile <lang>     # repeat for each other edition
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
every language, so a new language only needs its own introduction, credits
page, table of contents, neologism notes and the alt text of the pictures:

1. Open an issue first, so the coordinator can plan the new edition and find
   reviewers who speak the language.
2. Create `docs/<lang>/` with `intro.qmd`, `credits.qmd`, `toc.qmd` and
   `neologisms.qmd`, translated from an existing edition (for example
   `docs/en/`). Keep the `{{< contributors >}}` line of `credits.qmd`: it
   writes the list of people.
3. Create the profile file `_quarto-<lang>.yml`: copy `_quarto-pt.yml` and
   replace `pt` with the new language code everywhere in it (`output-dir`,
   `lang`, `url` and the `docs/<lang>/` chapter paths). Include the new
   introduction in `index.qmd` with
   `::: {.content-visible when-profile="<lang>"}`. In the new profile's
   language switcher (`sidebar: tools`), list every other edition (the default
   one at the root, the others at `/<lang>/`), and add the new edition to the
   switcher of every other profile.
4. In the new profile file, translate the alt text of every picture and the
   role names of the credits page (`credits-roles`, the `label` of each
   role; keep each `role` as it is).

Nothing needs to change in `.github/workflows/`: the workflows build every
`_quarto-<lang>.yml` they find on every pull request, and publish each edition
at `/<lang>/` on the website (the default edition at the root), with its PDF
and EPUB attached to every release.

From then on, the new edition is kept in parallel with the others like any
other language.

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

- Everyone who contributes is credited in [CONTRIBUTORS.md](CONTRIBUTORS.md),
  whatever their role (reviewers, illustrators and voices included). Add your
  own line in your first pull request; the coordinator adds reviewers and
  anyone whose work a maintainer submitted for them.
- The same list is printed on the credits page of every edition of the book,
  grouped by role. Write your roles exactly as in the list at the top of
  CONTRIBUTORS.md, separated by commas; the Test check fails on any other
  role.
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
[Code of Conduct](CODE_OF_CONDUCT.md). To report a problem, open an issue
addressed to the coordinator; the Code of Conduct says how to ask for a private
conversation instead.
