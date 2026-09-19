// Moteur d'attribution des badges (D4, §01/§09 du blueprint) : la règle vit
// dans l'app, jamais côté serveur — le back-office ne définit que les
// métadonnées (clé, nom, icône, description). Chaque badge est une fonction
// pure évaluée contre un instantané des données de l'appareil, jamais
// contre la base directement (le repository en `data/` s'occupe du
// chargement — voir `badges_repository.dart`).
//
// Rattachés à l'APPAREIL, pas à un profil précis : en V1 sans compte,
// l'appareil tient lieu de compte (§01 : « les badges sont rattachés au
// compte »).

/// Une partie terminée, résumée pour l'évaluation des badges — un par
/// (session, joueur), donc plusieurs lignes par partie multijoueur.
class BadgeGameRecord {
  const BadgeGameRecord({
    required this.gameId,
    required this.locale,
    required this.playerCount,
    required this.finishedAt,
    required this.playerId,
    required this.score,
    required this.isWinner,
    required this.tagsGained,
  });

  final String gameId;
  final String locale;
  final int playerCount;
  final DateTime finishedAt;
  final String playerId;
  final int score;
  /// true si ce joueur a le meilleur score de CETTE partie (égalité incluse
  /// — chacun des meilleurs est considéré gagnant).
  final bool isWinner;
  /// Tags canoniques des cartes gagnées par ce joueur, cette partie
  /// (répétés autant de fois que gagnés — pour compter les occurrences).
  final List<String> tagsGained;
}

/// Tout ce dont les règles ont besoin, déjà agrégé par le repository — les
/// fonctions de ce fichier ne touchent jamais drift directement.
class BadgeContext {
  const BadgeContext({
    required this.totalScore,
    required this.gamesPlayed,
    required this.records,
    required this.customCardsCreated,
    required this.likedCardsCount,
  });

  /// Cumulé sur TOUS les joueurs de l'appareil (les badges sont à
  /// l'appareil, pas au profil — un seul joueur ou plusieurs, peu importe).
  final int totalScore;
  final int gamesPlayed;
  /// Une ligne par (session, joueur) — permet de recalculer explorer,
  /// night_owl, polyglot, social_butterfly, three_peat, truth_seeker.
  final List<BadgeGameRecord> records;
  /// Pas encore construit (Phase 3, C1-C3) — toujours 0 pour l'instant :
  /// `author` reste verrouillé tant que les cartes perso n'existent pas.
  final int customCardsCreated;
  /// Pas encore construit (Phase 4, compte requis) — toujours 0 :
  /// `curator` reste verrouillé tant qu'il n'y a pas de compte.
  final int likedCardsCount;
}

typedef BadgeRule = bool Function(BadgeContext ctx);

class BadgeDef {
  const BadgeDef(this.key, this.rule);
  final String key;
  final BadgeRule rule;
}

bool _firstWin(BadgeContext ctx) => ctx.totalScore > 0;
bool _partyLegend(BadgeContext ctx) => ctx.totalScore >= 20;
bool _centurion(BadgeContext ctx) => ctx.totalScore >= 100;
bool _marathon(BadgeContext ctx) => ctx.gamesPlayed >= 50;

bool _socialButterfly(BadgeContext ctx) =>
    ctx.records.where((r) => r.playerCount >= 4).length >= 5;

bool _truthSeeker(BadgeContext ctx) =>
    ctx.records.fold(0, (n, r) => n + r.tagsGained.where((t) => t == 'vérité').length) >= 10;

bool _explorer(BadgeContext ctx) => ctx.records.map((r) => r.gameId).toSet().length >= 8;

bool _nightOwl(BadgeContext ctx) => ctx.records.any((r) {
      final h = r.finishedAt.hour;
      return h >= 2 && h < 5;
    });

bool _polyglot(BadgeContext ctx) {
  final locales = ctx.records.map((r) => r.locale).toSet();
  return locales.contains('fr') && locales.contains('en');
}

/// 3 victoires d'affilée, TOUTES sessions confondues (pas nécessairement le
/// même adversaire) — triées chronologiquement, une suite de 3 `isWinner`
/// consécutifs pour un même joueur suffit.
bool _threePeat(BadgeContext ctx) {
  final byPlayer = <String, List<BadgeGameRecord>>{};
  for (final r in ctx.records) {
    byPlayer.putIfAbsent(r.playerId, () => []).add(r);
  }
  for (final list in byPlayer.values) {
    list.sort((a, b) => a.finishedAt.compareTo(b.finishedAt));
    var streak = 0;
    for (final r in list) {
      streak = r.isWinner ? streak + 1 : 0;
      if (streak >= 3) return true;
    }
  }
  return false;
}

bool _author(BadgeContext ctx) => ctx.customCardsCreated >= 5;
bool _curator(BadgeContext ctx) => ctx.likedCardsCount >= 20;

/// Ordre = progression ressentie (voir `scripts/seed-badges.ts`, même
/// ordre) : les badges faciles d'abord.
const badgeDefs = [
  BadgeDef('first_win', _firstWin),
  BadgeDef('party_legend', _partyLegend),
  BadgeDef('social_butterfly', _socialButterfly),
  BadgeDef('truth_seeker', _truthSeeker),
  BadgeDef('three_peat', _threePeat),
  BadgeDef('explorer', _explorer),
  BadgeDef('night_owl', _nightOwl),
  BadgeDef('author', _author),
  BadgeDef('polyglot', _polyglot),
  BadgeDef('curator', _curator),
  BadgeDef('centurion', _centurion),
  BadgeDef('marathon', _marathon),
];

/// Toutes les clés désormais débloquées (déjà acquises + nouvellement
/// méritées) — le repository ne persiste que celles pas déjà dans
/// `alreadyEarned`.
Set<String> evaluateBadges(BadgeContext ctx, Set<String> alreadyEarned) {
  final unlocked = Set<String>.of(alreadyEarned);
  for (final def in badgeDefs) {
    if (!unlocked.contains(def.key) && def.rule(ctx)) unlocked.add(def.key);
  }
  return unlocked;
}
