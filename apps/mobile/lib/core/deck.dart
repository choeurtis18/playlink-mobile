import 'dart:math';

// Portage de `lib/intensity-deck.ts` + `gameStore.startDeck` de l'app web.
// Les tests de `test/core/deck_test.dart` valident le comportement ligne à
// ligne contre l'implémentation TypeScript (§02 du blueprint).

/// Constantes reprises de `packages/shared/src/utils/constants.ts`.
const int intensityMin = 1;
const int intensityMax = 5;
const int intensityDefault = 3;
const double intensityWeightExponent = 1.5;
const int cardsPerGameDefault = 10;

/// Libellés canoniques — ceux de l'app web et des slides de règles.
const Map<int, String> intensityLabels = {
  1: 'Soft',
  2: 'Léger',
  3: 'Normal',
  4: 'Chaud',
  5: 'Trash',
};

/// Poids d'une carte selon sa distance à l'intensité visée.
/// Distance 0 → 1, distance 1 → ~0.35, distance 4 → ~0.09 (k = 1.5).
/// Aucune carte n'a un poids nul : le deck n'est jamais vide, même si la
/// catégorie ne contient aucune carte à l'intensité demandée.
double intensityWeight(int cardIntensity, int target) {
  final distance = (cardIntensity - target).abs();
  return 1 / pow(1 + distance, intensityWeightExponent);
}

/// Fisher-Yates, sans muter la liste d'entrée.
List<T> shuffle<T>(List<T> items, {Random? random}) {
  final rng = random ?? Random();
  final a = List<T>.of(items);
  for (var i = a.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
  }
  return a;
}

/// Tirage pondéré sans remise : sélectionne `count` cartes en favorisant
/// celles proches de `target`, sans jamais exclure les autres.
List<T> pickWeighted<T>(
  List<T> cards,
  int target,
  int count, {
  required int Function(T card) intensityOf,
  Random? random,
}) {
  final rng = random ?? Random();
  final pool = List<T>.of(cards);
  final weights =
      pool.map((c) => intensityWeight(intensityOf(c), target)).toList();
  final picked = <T>[];

  while (picked.length < count && pool.isNotEmpty) {
    final total = weights.fold<double>(0, (s, w) => s + w);
    var r = rng.nextDouble() * total;
    var index = pool.length - 1;
    for (var i = 0; i < pool.length; i++) {
      r -= weights[i];
      if (r <= 0) {
        index = i;
        break;
      }
    }
    picked.add(pool[index]);
    pool.removeAt(index);
    weights.removeAt(index);
  }
  return picked;
}

/// `gameStore.startDeck` : mélange puis tirage pondéré, coupé à `count`.
List<T> buildDeck<T>(
  List<T> categoryCards, {
  required int target,
  required int count,
  required int Function(T card) intensityOf,
  Random? random,
}) {
  return pickWeighted(
    shuffle(categoryCards, random: random),
    target,
    count,
    intensityOf: intensityOf,
    random: random,
  );
}
