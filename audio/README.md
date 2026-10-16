<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

# Recordings

Every dialogue, word list and pronunciation table in the book carries a
reference of the form **Á lasta!** `1.2`: the first number is the chapter, the
second the track. The website plays the recording in place; the PDF and EPUB
show only the reference.

## Layout

```text
audio/
├── README.md               # this file
└── parande_1/
    ├── SCRIPT.md           # what to record, line by line
    ├── 1-1.mp3             # track 1.1
    ├── 1-1.mp3.license     # REUSE sidecar (CC-BY-4.0)
    └── ...
```

- One folder per chapter: `audio/parande_<chapter>/`.
- One file per reference: `<chapter>-<track>.mp3`, e.g. `1-2.mp3` for 1.2.
- Each file gets a `.license` sidecar naming the speakers as copyright
  holders, licensed CC-BY-4.0, like the images in `images/`.
- `_quarto.yml` publishes `audio/**/*.mp3` as site resources; nothing else
  needs to change when a recording lands.

## Recording guidelines

- Masters: WAV at 48 kHz, as the Quenya-TTS recorder writes them, with no
  noise removal, music or effects. They are kept with
  [Quenya-TTS](https://github.com/brunopacheco1/Quenya-TTS) as training data
  (issue [#38](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/38)
  says where to send them) and are not committed here.
- Published files, made from the masters: MP3, mono, 44.1 kHz, 128 kbps;
  normalise to about −16 LUFS; trim silence to half a second at each end.
- Before a speaker's first recording is merged, they have signed the consent
  and licence form of #38.
- Natural conversational pace, a short pause between lines. Word lists are
  read once at normal speed, then once slowly.
- Pronunciation follows the
  [pronunciation standard](../STYLE_GUIDE.md#pronunciation-standard) of the
  style guide (Third Age Quenya, as in Appendix E of *The Lord of the Rings*):
  *c* is always /k/, *qu* is /kw/, *y* is /j/, long vowels (with an acute) are
  held about twice as long, and every *ë* is pronounced.
- A single speaker may voice several characters; keep the same voice for a
  character across the whole book.
