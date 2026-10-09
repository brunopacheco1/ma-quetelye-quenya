<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)

SPDX-License-Identifier: CC-BY-4.0
-->

# Carincë 1 – image prompts

Prompts for the pictures of chapter 1, to be run through an image generator.
Save each result as the PNG named below in `raw_images/`, add its `.license`
sidecar, and run `compress_images.py` to produce the JPG in `images/`. Until
then, a neutral placeholder with the same name keeps the book rendering.

The alt texts below are the ones in `_quarto-en.yml` and `_quarto-pt.yml`;
if a generated picture differs from the prompt, update both.

## Art direction (all pictures)

Match `images/greetings.jpg` and `images/daytime.jpg`:

- Warm watercolour and ink illustration on lightly textured paper, soft
  pastel palette, clean dark-brown outlines, friendly cartoon realism.
- Present day. Quenya is simply the language people speak; clothes, streets
  and furniture are contemporary. People of all ages and skin tones. Elves
  are told apart only by slightly pointed ears; nothing medieval.
- The recurring characters: **Rúmil** (teacher, 60s, long silver hair tied
  back, round glasses, cardigan), **Elenwë** (20s, golden hair, yellow
  jacket), **Nerdanel** (30s, red curly hair, green apron or overalls),
  **Voronwë** (30s, dark hair, blue sailor's coat), **Elendil** (40s, tall,
  grey-streaked beard, traveller's coat and suitcase).
- **No written text anywhere in the picture**: no signs, labels, books with
  readable titles or speech-bubble text. Empty speech bubbles are fine (see
  `greetings.jpg`). Any label in Quenya or Tengwar is added afterwards in an
  image editor, as in `daytime.jpg`.
- Landscape 16:9 for scenes, at least 2048 px wide.

Suggested negative prompt: `text, letters, words, signage, captions,
watermark, logo, photo-realistic, 3D render, medieval armour, swords, dark
fantasy, extra fingers`.

## Existing pictures (keep)

| File | Used in | Alt text (EN / PT) |
|------|---------|--------------------|
| `greetings.jpg` | *Aiya!... ar Namárië!* | Four scenes of people greeting each other: two students waving in front of a school, a woman and a man talking at an office desk, two elderly neighbours chatting over a garden fence, and a young man at a reception counter. The speech bubbles are empty. / Quatro cenas de pessoas se cumprimentando: dois estudantes acenam em frente a uma escola, uma mulher e um homem conversam em uma mesa de escritório, dois vizinhos idosos conversam por cima de uma cerca de jardim e um jovem está no balcão de uma recepção. Os balões de fala estão vazios. |
| `daytime.jpg` | *Lúmë* | Six panels of the times of day, each labelled in Tengwar and Latin letters: a sunny landscape (aurë), a starry night (lómë), a boy waking at dawn (amaurë), children playing in the afternoon (apárilë), a boy drawing in the kitchen in the evening (sinyë) and the boy asleep at night (lómë). / Seis painéis com as horas do dia, cada um com legenda em Tengwar e em letras latinas: uma paisagem solarenga (aurë), uma noite estrelada (lómë), um menino acordando ao amanhecer (amaurë), crianças brincando à tarde (apárilë), um menino desenhando na cozinha ao entardecer (sinyë) e o menino dormindo à noite (lómë). |

## 1. `carince_1_essi.png` – *Mana esselya?*

**Scene.** The first lesson. A bright community-centre classroom with large
windows onto a seaside town; a whiteboard with nothing written on it. Rúmil
stands beside the board, one hand on his chest, introducing himself with a
smile. Four adult learners sit in a half circle on light wooden chairs:
Elenwë, Nerdanel, Voronwë and Elendil, each with a blank name tag on their
chest. Elenwë is half-raised, hand on her chest, answering. Empty speech
bubbles above Rúmil and Elenwë.

**Prompt.** `Warm watercolour and ink illustration, soft pastel palette,
clean brown outlines, friendly cartoon realism on textured paper. A bright
modern community-centre classroom with big windows showing a sunny seaside
town; an empty whiteboard. An older teacher with long silver hair tied back,
round glasses and a cardigan stands by the board with one hand on his chest,
smiling as he introduces himself; an empty speech bubble above him. Four
adult students of different ages and skin tones sit in a half circle on light
wooden chairs, each wearing a blank name tag: a young woman with golden hair
and a yellow jacket, half standing with her hand on her chest and an empty
speech bubble; a woman with red curly hair in green overalls; a man with dark
hair in a blue sailor's coat; a tall bearded man in a traveller's coat with a
suitcase beside his chair. All have slightly pointed ears except the bearded
man. No text, no letters, no writing anywhere. 16:9.`

**Alt text (EN).** A teacher with long silver hair and round glasses stands
by an empty whiteboard, hand on his chest, introducing himself to four adult
students sitting in a half circle; a young woman with golden hair answers him
with her hand on her chest. All wear blank name tags.

**Alt text (PT).** Um professor de cabelo comprido prateado e óculos redondos
está junto a um quadro branco vazio, com a mão no peito, a apresentar-se a
quatro alunos adultos sentados em meio círculo; uma jovem de cabelo dourado
responde a ele com a mão no peito. Todos usam crachás em branco.

## 2. `carince_1_mallo.png` – *Mallo tulilyë?*

**Scene.** Arrivals at the harbour of Avallónë on a bright morning. A quay
with white houses and a small lighthouse. A modern ferry is moored on the
right; a small white boat with a swan-shaped prow on the left. Travellers
come down the gangway with suitcases and backpacks: Elendil (bearded, coat,
suitcase) is greeted by Rúmil, who waves. Elenwë with a yellow backpack
checks a paper map that shows only coastlines and dots, no names. Gulls,
rope bollards, a café awning.

**Prompt.** `Warm watercolour and ink illustration, soft pastel palette,
clean brown outlines, friendly cartoon realism on textured paper. A sunny
morning on the quay of a small seaside town with white houses and a little
lighthouse. On the right a modern passenger ferry is moored; on the left a
small white boat with a swan-shaped prow. Travellers walk down a gangway with
suitcases and backpacks. A tall bearded man in a traveller's coat with a
suitcase is greeted by an older man with long silver hair and round glasses
who waves to him. A young woman with golden hair and a yellow backpack looks
at a paper map that shows only blank coastlines and dots. Gulls, rope
bollards, a café awning. No text, no letters, no signs, no writing anywhere.
16:9.`

**Alt text (EN).** Travellers with suitcases come down a ferry gangway onto a
sunny quay with white houses and a small lighthouse; a bearded man is greeted
by an older man with silver hair who waves, and a young woman with a yellow
backpack reads a paper map. A small boat with a swan-shaped prow is moored
nearby.

**Alt text (PT).** Viajantes com malas descem a rampa de uma balsa para um
cais ensolarado com casas brancas e um pequeno farol; um homem de barba é
recebido por um homem mais velho de cabelo prateado que acena para ele, e uma
jovem de mochila amarela consulta um mapa de papel. Um pequeno barco com proa
em forma de cisne está atracado ao lado.

## 3. `carince_1_noti.png` – *Nóti*

**Scene.** A pedestrian street at dusk with exactly **ten** round paper
lanterns strung in one straight line across the street, evenly spaced, each a
different soft colour, every one fully visible and clearly countable. Below,
Nerdanel and Voronwë sit at a café table and point up at the lanterns,
counting on their fingers. Keep the lanterns large and the background simple
so the count is unmistakable. (Check the count before using the picture;
regenerate if it is not ten.)

**Prompt.** `Warm watercolour and ink illustration, soft pastel palette,
clean brown outlines, friendly cartoon realism on textured paper. A quiet
pedestrian street at dusk. Exactly ten round paper lanterns hang in one
straight evenly spaced line across the street, each a different soft colour,
all fully visible, none overlapping, large and easy to count. Below them a
woman with red curly hair in green overalls and a man with dark hair in a blue
sailor's coat sit at a small café table and point up at the lanterns,
counting on their fingers. Simple background, no other lights. No text, no
letters, no signs, no writing anywhere. 16:9.`

**Alt text (EN).** Ten round paper lanterns in different colours hang in a
straight line across a street at dusk; below them a woman and a man at a café
table point up at the lanterns and count on their fingers.

**Alt text (PT).** Dez lanternas de papel redondas de cores diferentes
pendem em linha reta sobre uma rua ao anoitecer; por baixo, uma mulher e um
homem em uma mesa de café apontam para as lanternas e contam pelos dedos.
