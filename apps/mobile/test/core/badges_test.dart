import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/core/badges.dart';

BadgeGameRecord _record({
  String gameId = 'g1',
  String locale = 'fr',
  int playerCount = 2,
  DateTime? finishedAt,
  String playerId = 'p1',
  int score = 1,
  bool isWinner = true,
  List<String> tagsGained = const [],
}) {
  return BadgeGameRecord(
    gameId: gameId,
    locale: locale,
    playerCount: playerCount,
    finishedAt: finishedAt ?? DateTime(2026, 1, 1, 20),
    playerId: playerId,
    score: score,
    isWinner: isWinner,
    tagsGained: tagsGained,
  );
}

const _empty = BadgeContext(
  totalScore: 0,
  gamesPlayed: 0,
  records: [],
  customCardsCreated: 0,
  likedCardsCount: 0,
);

void main() {
  group('first_win', () {
    test('débloqué dès le premier point marqué', () {
      final ctx = _empty;
      expect(evaluateBadges(ctx, {}), isNot(contains('first_win')));
      final withScore = BadgeContext(totalScore: 1, gamesPlayed: 1, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(withScore, {}), contains('first_win'));
    });
  });

  group('party_legend / centurion', () {
    test('seuils 20 et 100 points cumulés', () {
      final at19 = BadgeContext(totalScore: 19, gamesPlayed: 5, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      final at20 = BadgeContext(totalScore: 20, gamesPlayed: 5, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      final at100 = BadgeContext(totalScore: 100, gamesPlayed: 5, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(at19, {}), isNot(contains('party_legend')));
      expect(evaluateBadges(at20, {}), contains('party_legend'));
      expect(evaluateBadges(at20, {}), isNot(contains('centurion')));
      expect(evaluateBadges(at100, {}), containsAll(['party_legend', 'centurion']));
    });
  });

  group('marathon', () {
    test('50 parties terminées', () {
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 50, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('marathon'));
      final under = BadgeContext(totalScore: 0, gamesPlayed: 49, records: const [], customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(under, {}), isNot(contains('marathon')));
    });
  });

  group('social_butterfly', () {
    test('5 parties à 4 joueurs ou plus', () {
      final records = List.generate(5, (i) => _record(playerCount: 4));
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 5, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('social_butterfly'));
    });

    test('les parties à moins de 4 joueurs ne comptent pas', () {
      final records = [
        ..._recordsWithPlayerCount(4, 4),
        _record(playerCount: 3),
      ];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 5, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), isNot(contains('social_butterfly')));
    });
  });

  group('truth_seeker', () {
    test('10 cartes de vérité gagnées, cumulées sur plusieurs parties', () {
      final records = [
        _record(tagsGained: List.filled(6, 'vérité')),
        _record(tagsGained: List.filled(4, 'vérité')),
      ];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 2, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('truth_seeker'));
    });

    test('les autres tags ne comptent pas', () {
      final records = [_record(tagsGained: List.filled(10, 'humour'))];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 1, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), isNot(contains('truth_seeker')));
    });
  });

  group('three_peat', () {
    test('3 victoires consécutives dans l\'ordre chronologique', () {
      final records = [
        _record(finishedAt: DateTime(2026, 1, 1), isWinner: true),
        _record(finishedAt: DateTime(2026, 1, 2), isWinner: true),
        _record(finishedAt: DateTime(2026, 1, 3), isWinner: true),
      ];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 3, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('three_peat'));
    });

    test('une défaite au milieu casse la suite', () {
      final records = [
        _record(finishedAt: DateTime(2026, 1, 1), isWinner: true),
        _record(finishedAt: DateTime(2026, 1, 2), isWinner: false),
        _record(finishedAt: DateTime(2026, 1, 3), isWinner: true),
      ];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 3, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), isNot(contains('three_peat')));
    });
  });

  group('explorer', () {
    test('au moins une partie dans chacun des 8 jeux', () {
      final records = [for (var i = 1; i <= 8; i++) _record(gameId: 'g$i')];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 8, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('explorer'));
    });

    test('7 jeux différents ne suffisent pas', () {
      final records = [for (var i = 1; i <= 7; i++) _record(gameId: 'g$i')];
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 7, records: records, customCardsCreated: 0, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), isNot(contains('explorer')));
    });
  });

  group('night_owl', () {
    test('partie terminée entre 2h et 5h du matin', () {
      final ctx = BadgeContext(
        totalScore: 0, gamesPlayed: 1,
        records: [_record(finishedAt: DateTime(2026, 1, 1, 3, 30))],
        customCardsCreated: 0, likedCardsCount: 0,
      );
      expect(evaluateBadges(ctx, {}), contains('night_owl'));
    });

    test('à 5h pile, la fenêtre est fermée', () {
      final ctx = BadgeContext(
        totalScore: 0, gamesPlayed: 1,
        records: [_record(finishedAt: DateTime(2026, 1, 1, 5, 0))],
        customCardsCreated: 0, likedCardsCount: 0,
      );
      expect(evaluateBadges(ctx, {}), isNot(contains('night_owl')));
    });
  });

  group('polyglot', () {
    test('avoir joué en FR et en EN', () {
      final ctx = BadgeContext(
        totalScore: 0, gamesPlayed: 2,
        records: [_record(locale: 'fr'), _record(locale: 'en')],
        customCardsCreated: 0, likedCardsCount: 0,
      );
      expect(evaluateBadges(ctx, {}), contains('polyglot'));
    });

    test('seulement le FR ne suffit pas', () {
      final ctx = BadgeContext(
        totalScore: 0, gamesPlayed: 2,
        records: [_record(locale: 'fr'), _record(locale: 'fr')],
        customCardsCreated: 0, likedCardsCount: 0,
      );
      expect(evaluateBadges(ctx, {}), isNot(contains('polyglot')));
    });
  });

  group('author / curator — pas encore construits (Phase 3/4)', () {
    test('author : 5 cartes personnalisées créées', () {
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 0, records: const [], customCardsCreated: 5, likedCardsCount: 0);
      expect(evaluateBadges(ctx, {}), contains('author'));
      expect(evaluateBadges(_empty, {}), isNot(contains('author')));
    });

    test('curator : 20 cartes likées', () {
      final ctx = BadgeContext(totalScore: 0, gamesPlayed: 0, records: const [], customCardsCreated: 0, likedCardsCount: 20);
      expect(evaluateBadges(ctx, {}), contains('curator'));
      expect(evaluateBadges(_empty, {}), isNot(contains('curator')));
    });
  });

  test('evaluateBadges garde les clés déjà acquises même si la règle ne matche plus', () {
    // Un badge débloqué ne doit jamais redevenir verrouillé si l'état
    // sous-jacent change (ex. reset de state hypothétique).
    final result = evaluateBadges(_empty, {'first_win'});
    expect(result, contains('first_win'));
  });
}

List<BadgeGameRecord> _recordsWithPlayerCount(int count, int playerCount) =>
    List.generate(count, (_) => _record(playerCount: playerCount));
