// Mêmes cas que apps/mobile/test/core/deck_test.dart : la démo doit tirer
// comme l'app.
import { test } from "node:test";
import assert from "node:assert/strict";
import { buildDeck, intensityWeight, pickWeighted, shuffle, type Random } from "./deck.ts";

/** Générateur à graine (mulberry32) : tirages reproductibles. */
function seeded(seed: number): Random {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

type Card = { id: string; intensity: number };
const int = (c: Card) => c.intensity;
const cards: Card[] = [1, 2, 3, 4, 5].flatMap((i) => [0, 1, 2, 3].map((k) => ({ id: `i${i}-${k}`, intensity: i })));

test("intensityWeight — mêmes valeurs que l'app", () => {
  assert.equal(intensityWeight(3, 3), 1);
  assert.ok(Math.abs(intensityWeight(4, 3) - 0.3536) < 0.0005);
  assert.ok(Math.abs(intensityWeight(5, 1) - 0.0894) < 0.0005);
  assert.equal(intensityWeight(1, 4), intensityWeight(4, 1));
});

test("shuffle ne mute pas et conserve les éléments", () => {
  const src = [1, 2, 3, 4, 5];
  const out = shuffle(src, seeded(1));
  assert.deepEqual(src, [1, 2, 3, 4, 5]);
  assert.deepEqual([...out].sort(), [1, 2, 3, 4, 5]);
  assert.deepEqual(shuffle([1, 2, 3, 4, 5, 6], seeded(42)), shuffle([1, 2, 3, 4, 5, 6], seeded(42)));
});

test("pickWeighted coupe à count, sans doublon", () => {
  const out = pickWeighted(cards, 3, 10, int, seeded(7));
  assert.equal(out.length, 10);
  assert.equal(new Set(out.map((c) => c.id)).size, 10);
});

test("pickWeighted renvoie tout si count > taille, jamais vide", () => {
  assert.equal(pickWeighted(cards.slice(0, 3), 3, 10, int).length, 3);
  assert.equal(pickWeighted([{ id: "a", intensity: 5 }, { id: "b", intensity: 5 }], 1, 10, int).length, 2);
});

test("pickWeighted favorise l'intensité visée sans exclure les autres", () => {
  const counts: Record<number, number> = {};
  for (let seed = 0; seed < 300; seed++) {
    for (const c of pickWeighted(cards, 1, 5, int, seeded(seed))) counts[c.intensity] = (counts[c.intensity] ?? 0) + 1;
  }
  for (let i = 1; i <= 5; i++) assert.ok(counts[i] > 0, `intensité ${i} jamais tirée`);
  assert.ok(counts[1] > counts[5] * 3);
});

test("buildDeck déterministe avec une graine", () => {
  const a = buildDeck(cards, 3, 10, int, seeded(9)).map((c) => c.id);
  const b = buildDeck(cards, 3, 10, int, seeded(9)).map((c) => c.id);
  assert.deepEqual(a, b);
});
