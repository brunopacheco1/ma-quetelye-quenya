<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.2.0] - 2026-10-14

### Added

- new apárilë panel on the times-of-day page
- chapter 1 pictures redrawn with the cast
- new cover with the cast and the title Ma Quetilyë Quenya?
- generate the chapter pictures through Gemini's API
- add the chapter 1 Tengwar section with reading and writing exercises
- write Quenya in Tengwar from Latin spelling
- call the chapters parandë and rename their files to match
- add the generated pictures for chapter 1
- draft a full chapter 1 in Quenya with dialogues, exercises and audio references

### Changed

- Merge pull request #39 from brunopacheco1/claude/project-thread-giui4h
- point links and output files at the renamed repository
- Merge pull request #36 from brunopacheco1/claude/project-thread-giui4h
- one speech-bubble rule and a painted sky for the daytime panels
- align the chapter 1 picture prompts with the cast after review
- list the Tengwar in the contents and the word record, and fix three notes
- add the six-chapter story arc to the picture guide
- add a picture guide with the style, the town and the cast
- add cast-based prompts for the remaining chapter 1 pictures
- drop the email from copyright headers and move to ma-quetilye-quenya.tolkien.lu
- Merge pull request #37 from brunopacheco1/claude/community-work-plan-qcoy1g
- review new neologisms in the pull request that proposes them
- describe the book as multi-language in the contributing guide
- rewrite the contributing guide for community contributors
- Merge pull request #30 from brunopacheco1/claude/project-thread-5wt9gx
- Merge branch 'main' into claude/project-thread-5wt9gx
- allow a manual publish to redeploy the latest release
- Create CNAME
- set up Spec Kit with the project constitution
- render on every PR, add PR previews and publish PT

### Fixed

- stop at once when the Gemini key has no image quota
- warn when a Tengwar span drops a note or link, and accept combining accents in letter names
- declare the EPUB Tengwar font in a stylesheet
- bring back the labelled times-of-day picture
- say Á na márië instead of mesta and retitle the book Ma Quetilyë Quenya?
- match two chapter 1 alt texts to the generated pictures
- add REUSE annotation for CNAME
- show the correct publication date


## [v0.1.2] - 2026-04-21

### Added

- add chapter 1

### Changed

- Merge pull request #21 from brunopacheco1/add-chapter-1


## [v0.1.1] - 2026-04-19

### Changed

- Merge pull request #19 from brunopacheco1/add-intro
- feat.: add introduction and new cover


## [v0.1.0] - 2026-04-17

### Changed

- Merge pull request #17 from brunopacheco1/revert-16-release/v0.1.0
- Revert "Release v0.1.0"

### Fixed

- standardise output filename


## [v0.0.4] - 2026-04-17

### Changed

- feed changelog from commits


## [v0.0.3] - 2026-04-17

### Changed

- prepare release v0.0.3
- publish to URL only released versions

## [v0.0.2] - 2026-04-17

### Changed

- prepare release v0.0.2

### Fixed

- render all formats at once

## [v0.0.1] - 2026-04-17

### Changed

- prepare release v0.0.1

### Fixed

- upload only en  content

## [v0.0.0] - 2026-04-17

### Changed

- prepare release v0.0.0
- add multilingual support
- publish book to gh pages
- initial commit
- Initial commit

### Fixed

- remove false chapter in pt
- fetch tags while preparing releases
- remove unused badges
- build quarto page and upload artifact

