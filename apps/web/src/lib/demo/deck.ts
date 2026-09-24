// Port de apps/mobile/lib/core/deck.dart (lui-même port de
// `lib/intensity-deck.ts` de l'ancienne app web) : la démo tire ses cartes
// exactement comme l'app. Les tests (deck.test.ts) reprennent ceux de
// test/core/deck_test.dart. Toute évolution se fait des deux côtés.

export const INTENSITY_MIN = 1;
export const INTENSITY_MAX = 5;
export const INTENSITY_DEFAULT = 3;
const INTENSITY_WEIGHT_EXPONENT = 1.5;

/** Générateur aléatoire injectable ([0, 1[), pour des tests déterministes. */
export type Random = () => number;

/** Poids d'une carte selon sa distance à l'intensité visée.
 * Distance 0 → 1, distance 1 → ~0,35, distance 4 → ~0,09.
 * Aucun poids nul : le deck n'est jamais vide. */
export function intensityWeight(cardIntensity: number, target: number): number {
  const distance = Math.abs(cardIntensity - target);
  return 1 / Math.pow(1 + distance, INTENSITY_WEIGHT_EXPONENT);
}

/** Fisher-Yates, sans muter la liste d'entrée. */
export function shuffle<T>(items: readonly T[], random: Random = Math.random): T[] {
  const a = [...items];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

/** Tirage pondéré sans remise : `count` cartes, en favorisant celles
 * proches de `target`, sans jamais exclure les autres. */
export function pickWeighted<T>(
  cards: readonly T[],
  target: number,
  count: number,
  intensityOf: (card: T) => number,
  random: Random = Math.random,
): T[] {
  const pool = [...cards];
  const weights = pool.map((c) => intensityWeight(intensityOf(c), target));
  const picked: T[] = [];

  while (picked.length < count && pool.length > 0) {
    const total = weights.reduce((s, w) => s + w, 0);
    let r = random() * total;
    let index = pool.length - 1;
    for (let i = 0; i < pool.length; i++) {
      r -= weights[i];
      if (r <= 0) {
        index = i;
        break;
      }
    }
    picked.push(pool[index]);
    pool.splice(index, 1);
    weights.splice(index, 1);
  }
  return picked;
}

/** `gameStore.startDeck` : mélange puis tirage pondéré, coupé à `count`. */
export function buildDeck<T>(
  categoryCards: readonly T[],
  target: number,
  count: number,
  intensityOf: (card: T) => number,
  random: Random = Math.random,
): T[] {
  return pickWeighted(shuffle(categoryCards, random), target, count, intensityOf, random);
}
