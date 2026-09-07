import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/core/deck.dart';

class _Card {
  const _Card(this.id, this.intensity);
  final String id;
  final int intensity;
}

int _int(_Card c) => c.intensity;

void main() {
  group('intensityWeight — mêmes valeurs que le TS', () {
    test('distance 0 → 1', () => expect(intensityWeight(3, 3), 1.0));
    test('distance 1 → 1/2^1.5 ≈ 0.354', () {
      expect(intensityWeight(4, 3), closeTo(0.3536, 0.0005));
    });
    test('distance 4 → 1/5^1.5 ≈ 0.089', () {
      expect(intensityWeight(5, 1), closeTo(0.0894, 0.0005));
    });
    test('symétrique', () {
      expect(intensityWeight(1, 4), intensityWeight(4, 1));
    });
  });

  group('shuffle', () {
    test('ne mute pas et conserve les éléments', () {
      final src = [1, 2, 3, 4, 5];
      final out = shuffle(src, random: Random(1));
      expect(src, [1, 2, 3, 4, 5]);
      expect(out..sort(), [1, 2, 3, 4, 5]);
    });
    test('déterministe avec une graine', () {
      expect(shuffle([1, 2, 3, 4, 5, 6], random: Random(42)),
          shuffle([1, 2, 3, 4, 5, 6], random: Random(42)));
    });
  });

  group('pickWeighted', () {
    final cards = [
      for (var i = 1; i <= 5; i++)
        for (var k = 0; k < 4; k++) _Card('i$i-$k', i),
    ];

    test('coupe à count, sans doublon', () {
      final out = pickWeighted(cards, 3, 10, intensityOf: _int, random: Random(7));
      expect(out.length, 10);
      expect(out.map((c) => c.id).toSet().length, 10);
    });

    test('renvoie tout si count > taille', () {
      final out = pickWeighted(cards.take(3).toList(), 3, 10, intensityOf: _int);
      expect(out.length, 3);
    });

    test('jamais vide même sans carte à l\'intensité visée', () {
      final only5 = [const _Card('a', 5), const _Card('b', 5)];
      expect(pickWeighted(only5, 1, 10, intensityOf: _int).length, 2);
    });

    test('favorise l\'intensité visée sans exclure les autres', () {
      final counts = <int, int>{};
      for (var seed = 0; seed < 300; seed++) {
        for (final c in pickWeighted(cards, 1, 5, intensityOf: _int, random: Random(seed))) {
          counts[c.intensity] = (counts[c.intensity] ?? 0) + 1;
        }
      }
      // Toutes les intensités apparaissent, et 1 domine nettement 5.
      for (var i = 1; i <= 5; i++) {
        expect(counts[i], greaterThan(0), reason: 'intensité $i jamais tirée');
      }
      expect(counts[1]!, greaterThan(counts[5]! * 3));
    });

    test('déterministe avec une graine', () {
      final a = pickWeighted(cards, 3, 10, intensityOf: _int, random: Random(9));
      final b = pickWeighted(cards, 3, 10, intensityOf: _int, random: Random(9));
      expect(a.map((c) => c.id), b.map((c) => c.id));
    });
  });

  test('buildDeck = shuffle + pickWeighted, 10 cartes par défaut', () {
    final cards = [for (var i = 0; i < 40; i++) _Card('c$i', 1 + i % 5)];
    final deck = buildDeck(cards, target: intensityDefault, count: cardsPerGameDefault, intensityOf: _int, random: Random(3));
    expect(deck.length, 10);
    expect(deck.map((c) => c.id).toSet().length, 10);
  });
}
