<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

# Picture guide

The pictures in this book come from an image generator, one prompt per
picture, in one file per chapter (such as [parande_1.md](parande_1.md)). This
guide keeps them consistent: one style, one town, and the same five people,
who change only as their story moves on. Every prompt is built from the
blocks below, copied word for word.

## Adding a picture

1. Paste the prompt from the chapter's prompt file into the generator, with
   the negative prompt below. If the generator accepts reference images, also
   give it `raw_images/parande_1_essi.jpeg`, which shows the style and all five
   characters.
2. Check the result against the prompt and the cast below: the right people,
   clothes and ears, and nothing written anywhere. Regenerate or retouch until
   it matches, and remove any generator watermark.
3. Save it as `raw_images/<name>.jpeg` with a `.license` sidecar (copy an
   existing one). If a file with the same name and another extension is
   there, such as `greetings.png`, delete it: the script would write both to
   the same JPG.
4. If the picture needs labels or a title, add them in an image editor. Save
   the labelled version as `raw_images/<name>.jpeg` and keep the unlabelled
   original in `raw_images/unlabelled/`, which the script does not read.
5. Run `python compress_images.py` to make the JPG in `images/`.
6. Write the alt text in every language profile (`_quarto-en.yml`,
   `_quarto-pt.yml`, …) and in the chapter's prompt file.
7. Render the book and look at the picture in HTML and PDF.

## Style

```text
Warm ink-and-watercolour illustration on lightly textured cream paper; thin
warm-brown outlines; flat, soft pastel washes; airy composition with open
cream space; friendly cartoon realism. Present day: contemporary clothes,
streets and furniture.
```

- Thin warm-brown lines, not black; soft pastel colours, not saturated; lots
  of open cream paper. `raw_images/parande_1_essi.jpeg` is the reference.
- Scenes are landscape 16:9, the cover portrait 2:3, at the largest size the
  generator offers (the chapter 1 pictures are 1376 × 768).
- People in the background are of all ages and skin tones, in present-day
  clothes. Elves have pointed ears, Men round ones.

Nothing in a picture may be written, because generators misspell, and the book
adds any Quenya or Tengwar label itself in an image editor:

```text
No text, letters, numbers or writing anywhere: no signs, no labels, no
readable pages, no clock numerals. Speech bubbles, if any, are empty.
```

Negative prompt for every picture:

```text
text, letters, words, numbers, writing, signage, captions, watermark, logo,
signature, photo-realistic, 3D render, anime, heavy black outlines, saturated
colours, medieval clothes, tunic, sash, armour, swords, dark fantasy, extra
fingers
```

## Avallónë

The story takes place in Avallónë, a small harbour town where Quenya is simply
the language people speak. Outdoor scenes use the town block, the class uses
the classroom block.

```text
Setting: Avallónë, a small present-day harbour town: white clapboard and
plaster houses with grey and terracotta roofs, a stone quay with rope
bollards, a café with a pink-and-white striped awning, a slim white lighthouse
with a red top on a rocky headland, a pale stone tower on the green hill above
the town, calm blue sea, gulls.
```

```text
Setting: a bright community-centre classroom in Avallónë: light cream walls, a
large empty whiteboard on a wheeled stand, light wooden chairs,
floor-to-ceiling windows onto the sea, the lighthouse on the headland and the
stone tower on the hill.
```

Places that come back: the quay where the ferry docks, the café with the
striped awning, the street with the ten paper lanterns (`parande_1_noti`), the
community-centre classroom, the lighthouse on the headland and the stone tower
on the hill.

## The cast

The Elves have long, leaf-shaped pointed ears whose tips stick out past the
hair. That is how the generated chapter 1 pictures draw all four Elves, so it
replaces the "slightly pointed" ears of the first art direction. Elendil is a
Man and has round ears.

### Rúmil

Rúmil is the teacher of the welcome class. Colour key: taupe-grey cardigan, cream shirt, silver hair, round glasses.

```text
Rúmil, an elderly elf man who looks about seventy, tall and slim, fair warm
skin, lined clean-shaven face, warm smile, round thin dark-brown wire glasses;
long silver-white hair swept back, the top part in a small bun at the back of
the head, the rest loose past the shoulders; long leaf-shaped pointed elf ears
angled up and back, tips showing past the hair; open taupe-grey knit cardigan
with ribbed cuffs over a cream collared shirt, brown leather belt, tan
trousers, brown leather lace-up shoes.
```

**Watch for.** Generators turn the cardigan cocoa brown, add a waistcoat, or tie all the hair into a low ponytail (all three happened in `parande_1_mallo`).

**Seen in** `parande_1_essi` (reference view), `parande_1_mallo`.

### Elenwë

Elenwë is a student, new in town. Colour key: mustard yellow, white, light-blue jeans, golden hair.

```text
Elenwë, a slim young elf woman in her early twenties, fair peach skin, rosy
cheeks, oval face, large dark-brown eyes, thin light-brown brows, small nose,
warm smile; long straight golden-blonde hair worn loose past the shoulders;
long slender pointed elf ears poking out sideways through the hair; open
mustard-yellow hip-length jacket with banded cuffs and hem over a white
T-shirt; light-blue cuffed jeans; mustard-yellow low-top canvas sneakers with
white toe caps.
```

**Watch for.** The short open jacket turns into a long closed rain jacket when seen from behind. In travel scenes she carries a mustard-yellow backpack.

**Seen in** `parande_1_essi` (reference view), `parande_1_mallo`.

### Nerdanel

Nerdanel is Elenwë's old friend. Colour key: sage green, oatmeal grey, coral sneakers, copper curls.

```text
Nerdanel, an elf woman in her early thirties, soft medium build, fair peachy
skin, rosy cheeks, soft round face, dark-brown eyes, thin arched auburn brows,
small upturned nose; voluminous bright copper-orange curly hair worn loose
past the shoulders; long sharply pointed elf ears angled up and back through
the curls; sage-green dungarees with a bib pocket, brass buckles and rolled
cuffs over a pale oatmeal-grey short-sleeved crew-neck T-shirt; coral-red
canvas high-top sneakers with white toe caps.
```

**Watch for.** The T-shirt turns ochre or mustard (`parande_1_noti`), which blurs her copper hair. For long sleeves, use a long-sleeved top in the same oatmeal grey.

**Seen in** `parande_1_essi` (reference view), `parande_1_noti`.

### Voronwë

Voronwë is an officer on the ferry. Colour key: navy coat with gold trim, striped shirt, cream trousers.

```text
Voronwë, a slim elf man about thirty, light warm peach skin, clean-shaven oval
face, straight nose, thick straight dark brows, small dark-brown eyes; short
tousled near-black hair with a side-swept fringe, ears uncovered; pointed elf
ears with tips swept up and back to eyebrow height; muted navy-blue
double-breasted mid-thigh ferry officer's coat with six brass buttons, gold
stripes on both cuffs and gold-striped shoulder boards, over a white crew-neck
shirt with blue horizontal stripes; cream-white trousers; slate blue-grey
leather shoes.
```

**Watch for.** Generators drop the gold cuff stripes and shoulder boards and let his hair grow to the collar (`parande_1_noti`). Name the gold trim in every prompt.

**Seen in** `parande_1_essi` (reference view), `parande_1_noti`.

### Elendil

Elendil is a Man from Númenórë, just arrived. Colour key: camel coat, sage-green T-shirt, charcoal trousers, brown boots, silver-streaked beard.

```text
Elendil, a tall broad-shouldered human man in his late forties with round
human ears, not pointed; light warm skin, long face, straight nose, thick dark
brows, no glasses; wavy shoulder-length grey-brown hair swept back with silver
streaks; full grey-brown beard with a silver streak down the chin; open
below-knee camel-tan coat with wide lapels over a sage-green crew-neck
T-shirt; charcoal-grey trousers tucked into tall brown cuffed boots.
```

**Watch for.** Generators give him a laced tunic and a sash (`parande_1_mallo`), which look medieval, or slightly pointed ears. Always write "round human ears, not pointed". In chapter 1 he carries a vintage tan leather suitcase.

**Seen in** `parande_1_essi` (reference view), `parande_1_mallo`.

<!-- STORY-ARC -->

## Prompt template

A prompt is these parts, in this order, each one a paragraph:

```text
[the style block]
[the town block or the classroom block]
[one cast block for each character in the picture]
[the scene: who does what, where, at what time of day and in which season]
[the no-text block]
[the format, such as "Landscape 16:9."]
```

Describe the scene in plain words and name the characters in it, since their
blocks above say who they are. Keep each character's season clothes and props
from the story arc, and change nothing else about them.
