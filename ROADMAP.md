<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

# Roadmap

How *Ma Quetilyë Quenya?* gets written, by whom, in what order. This is the
working plan of the project, kept by the coordinator and revised whenever a
decision changes it. The rules (how to contribute, how reviews work, how
decisions are made) are in [CONTRIBUTING.md](CONTRIBUTING.md); the choices the
book has made (setting, cast, spelling, pronunciation) are in the
[style guide](STYLE_GUIDE.md). This file only says where the work stands and
what comes next.

## Where things stand (October 2026)

- **Chapter 1 is published** (release v0.2.0, 14 October 2026): five dialogues
  and three short exchanges, grammar tables, a pronunciation table, a Tengwar
  section, ten exercises with an answer key, twelve pictures drawn to the cast
  sheet, an Eldamo word list and a recording script for ten tracks. It was
  drafted with an AI assistant and reviewed by the coordinator only, so it has
  had **no independent Quenya review yet**. Its pictures were generated with
  Gemini as a demonstration and still have mismatches; they are placeholders
  until an illustrator fixes or replaces them. Open on [#23][i23]: the Quenya
  review, the pedagogy comparison with chapter 1 of *Schwätzt Dir
  Lëtzebuergesch?* A1, the pictures, the ten recordings (waiting on voices
  from [#38][i38]).
- **Chapters 2 to 6** are stubs ([#31][i31] to [#35][i35]). They wait for the
  syllabus decision below.
- **Contributor files**: CONTRIBUTING.md, this roadmap, the style guide, the
  pull request template, the issue forms and CONTRIBUTORS.md are in the
  repository. Labels, milestones and the project board are set up by the
  coordinator.
- **Audio**: issue [#38][i38] (volunteer voices) is open. The pronunciation
  standard is settled (style guide); the sister project
  [Quenya-TTS](https://github.com/brunopacheco1/Quenya-TTS) has the
  pronunciation rules in code, a 2,500-line recording script and a recorder.
  The limit is recorded audio, so human voices come first.

## Roles

Roles, what each one does and how to claim a task are defined in
CONTRIBUTING.md ("Ways to contribute", "How to pick up a task"). This table
says where each role starts today.

| Role | First tasks |
|---|---|
| Coordinator | Triage, assign, run the decisions and the monthly call, approve and merge every pull request |
| Quenya reviewer | Review chapter 1 word by word against Eldamo and open pull requests with the fixes |
| Pedagogy reviewer | Compare chapter 1 with *Schwätzt Dir Lëtzebuergesch?* A1 chapter 1, section by section, and propose the missing pieces |
| Author | A chapter 2 to 6 sub-issue, once the syllabus is agreed |
| Translator | Check that the editions still say the same after the chapter 1 merge; later, bring neologism notes and alt text into every edition |
| Illustrator | Fix or replace the chapter 1 pictures so they match the cast sheet; hand-drawn pictures in the book's style are welcome (see the style guide, "Pictures") |
| Voice | Issue #38: sign the consent and licence form, trial-record a few script lines, then the chapter 1 tracks 1.1 to 1.10 |
| Tech maintainer | Label sync, the credits page in the rendered book, the tooling items under "Contributor-facing files" |

Required reviews follow CONTRIBUTING.md, "Who reviews what". Authors never
review their own pull request; the coordinator does the final read and merges.

## How a chapter is split into tasks

Each chapter is one **parent issue** (#23, #31 to #35) with **sub-issues**, each
sized for one person and one pull request.

1. **Spec**: themes, communicative goals, grammar points, word list. A
   maintainer writes it with Spec Kit (`specs/00N-chapter-N/`); contributors
   work from the sub-issues and need neither Spec Kit nor AI tools.
2. **Vocabulary list**: every word with its Eldamo link and attestation mark
   (Q., MQ., EQ., NQ., `*`, `#`; see the style guide).
3. **Dialogues and texts**: same cast and setting as chapter 1.
4. **Grammar and pronunciation boxes**: the pronunciation box follows the
   pronunciation standard in the style guide.
5. **Exercises and answer key**: the reference book's exercise types.
6. **Tengwar section**: only the letters the chapter needs, one reading and one
   writing exercise, Namárië mode through the `tengwar` filter (chapter 1 shows
   the pattern).
7. **Pictures**: a separate sub-issue per chapter. Prompts in
   `raw_images/prompts/parande_N.md` built from the picture guide's blocks,
   generation or drawing, check against the cast sheet, alt text in every
   edition's `_quarto-<lang>.yml`. Generated pictures are placeholders until
   they pass that check.
8. **Recording script and recordings**: `audio/parande_N/SCRIPT.md` lands with
   the dialogues; the recordings come through #38 and are `blocked` until the
   consent form exists. Recorded once, used by the book and by Quenya-TTS.
9. **Translations**: one `translation` sub-issue per chapter brings the
   neologism notes, alt text and intro changes that earlier pull requests
   flagged as pending into every other edition. A word Eldamo lacks is proposed
   as a neologism inside the pull request that introduces it (CONTRIBUTING.md,
   ground rule 2); no separate issue.

Reviews are not a separate step: every pull request from 2 to 9 gets the
reviews CONTRIBUTING.md requires for its kind of change.

Order: 1 → 2 → 3 to 5 in parallel → 6 to 8 → 9 as the earlier pull requests
land → the coordinator's final read. Chapters 2 to 6 do not depend on each other
once the syllabus exists, so they can run in parallel if there are people.

## Decisions

Decided items are recorded in the [style guide](STYLE_GUIDE.md) and are not
reopened without a new decision. The open ones, in the order they block work:

1. **Syllabus for chapters 2 to 6**: topics and grammar per chapter, following
   the reference book's A1 progression. Critical path for every chapter 2 to 6
   task. Proposal: a maintainer drafts it from chapter 1 and the reference
   book's table of contents; the coordinator decides after a week of comments.
2. **Story arc**: the five questions at the end of the
   [picture guide](raw_images/prompts/README.md) must be answered before the
   chapter 2 pictures.
3. **Era policy**: whether words Eldamo marks Early or Middle Qenya may appear
   at all, and how they are marked if they do.
4. **Tengwar details** not confirmed by Tolkien: *rd* and *ld* as *arda* and
   *alda*, the *s*-hook. Chapter 1 avoids both.
5. **Credits in the rendered book**: a shared credits page in the front matter
   (recommended), or a section in each edition's introduction. The repository
   list is [CONTRIBUTORS.md](CONTRIBUTORS.md) either way.

Process: CONTRIBUTING.md, "Making decisions".

## Tracking on GitHub

- **Labels**: one per task type (`review`, `vocabulary`, `dialogue`, `grammar`,
  `exercises`, `tengwar`, `images`, `audio`, `translation`, `tech`), one per
  chapter (`chapter-1` to `chapter-6`), plus `decision`, `blocked`,
  `help wanted` and `good first issue`. They are defined in
  [`.github/labels.yml`](.github/labels.yml); the "Sync labels" workflow
  creates them whenever that file changes on `main`.
- **Milestones**: one per chapter, for the progress bars.
- **Project board**: Backlog → Ready (`help wanted`) → In progress → In review
  → Done, with the fields Role and Chapter.
- **Claiming**: CONTRIBUTING.md, "How to pick up a task". A task is stale after
  three weeks without activity and may be reassigned after one more week; one
  open task per person until it is in review. Work attached to an issue by
  someone who does not use Git is turned into a pull request by a maintainer,
  crediting the author.
- **Status**: every two weeks the coordinator posts a status as a comment on
  the pinned **Project status** issue: per chapter, what is done, in progress,
  in review and unassigned; stale tasks; open decisions and their comment
  deadlines; new contributors to welcome; agenda items for the next call.
- **Meetings**: a monthly call of up to one hour (CONTRIBUTING.md, "Community
  meetings").

## Contributor-facing files

| File | Purpose |
|---|---|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Roles, ground rules, how to claim a task, reviews, meetings, decisions, technical guide |
| [STYLE_GUIDE.md](STYLE_GUIDE.md) | The decisions log: setting and cast, words and forms, attestation marks, pronunciation standard, Tengwar, pictures, audio |
| [CONTRIBUTORS.md](CONTRIBUTORS.md) | Everyone who has contributed, in any role |
| [`.github/pull_request_template.md`](.github/pull_request_template.md) | The review checklist every pull request fills in |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE) | Forms: content task, Quenya error report, "I want to help" |
| [`raw_images/prompts/README.md`](raw_images/prompts/README.md) | Picture guide: style, town, cast, story arc |
| [`audio/README.md`](audio/README.md) | Audio layout and published format |
| [`.specify/memory/constitution.md`](.specify/memory/constitution.md) | The rules every change must respect |

Still to do: show CONTRIBUTORS.md inside the rendered editions once the credits
decision is made (`tech`); GitHub Discussions, once enabled, for questions,
introductions and meeting notes.

## Rollout

1. **Repository settings** (coordinator): check that the "Sync labels"
   workflow created the labels (it runs by itself when `.github/labels.yml`
   changes on `main`); create the milestones Chapter 1 to Chapter 6; create the
   project board; pin the **Project status** issue; pick the date of the first
   call. Optionally enable Discussions.
2. **Setup** (this roadmap, the style guide, the templates, the CI loop over
   every language profile, the chapter 1 sub-issues, the first status post).
3. **Pilot: chapter 1 reviewed by the community.** The first Quenya reviewer
   and the first pedagogy reviewer work on chapter 1 and open pull requests
   with their fixes; the first illustrator fixes the pictures; the first voices
   record tracks 1.1 to 1.10 under #38.
4. **Syllabus decision**, then the chapter 2 spec by a maintainer, then the
   chapter 2 to 6 sub-issues open; chapters run in parallel as people allow.
5. **Steady state**: fortnightly status, monthly call, decisions through the
   process in CONTRIBUTING.md, this roadmap revised when a decision changes it.

## Audio and Quenya-TTS, one track

- Human recordings first. The ten chapter 1 tracks
  ([`audio/parande_1/SCRIPT.md`](audio/parande_1/SCRIPT.md)) are the first
  lines of the Quenya-TTS recording script, so a recording session for #38
  produces the book's tracks and training data at the same time.
- Pipeline: masters as the recorder writes them (WAV, 48 kHz) stay with
  Quenya-TTS as training data; the book publishes an MP3 per track with a
  `.license` sidecar naming the speaker, as `audio/README.md` describes. No
  noise removal or effects on the masters.
- Before the first recording is merged: the voice has signed the consent and
  licence form of #38 (CC-BY-4.0 and permission to train a public synthetic
  voice), and a Quenya reviewer has listened.
- Synthetic audio in the book: human recordings are published where they
  exist. A synthetic track may fill a gap only when the coordinator accepts it
  after a Quenya reviewer has listened, and its sidecar says it is synthetic.
- Training, data licences and compute are Quenya-TTS matters and are planned
  there, not here.

## Changes to this plan

- 2026-10-08: first version, written when the book became a community project.
- 2026-10-09: CONTRIBUTING.md merged; the plan defers to it for roles,
  claiming, reviews, meetings and decisions.
- 2026-10-15: revised after the chapter 1 merge (v0.2.0) and the repository
  rename; Tengwar and pictures added to the chapter split; the audio track
  shared with Quenya-TTS.
- 2026-10-16: published in the repository as this file. Decided by the
  coordinator: status posts on a pinned issue; pictures as a separate sub-issue
  per chapter, generated pictures are placeholders; Code of Conduct reports
  through GitHub issues; WAV masters and published MP3; CI builds every
  language profile.

[i23]: https://github.com/brunopacheco1/ma-quetilye-quenya/issues/23
[i31]: https://github.com/brunopacheco1/ma-quetilye-quenya/issues/31
[i35]: https://github.com/brunopacheco1/ma-quetilye-quenya/issues/35
[i38]: https://github.com/brunopacheco1/ma-quetilye-quenya/issues/38
