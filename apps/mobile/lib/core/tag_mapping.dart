// Portage de `packages/content-schema/src/tag-mapping.ts`.
//
// Doit produire EXACTEMENT les mêmes résultats que le TS : la migration a
// pré-calculé `canonicalTags` avec cette table, et l'archétype d'un joueur
// ne doit jamais diverger entre le back-office et l'app. Les tests de
// `test/core/tag_mapping_test.dart` reprennent ceux du package TS.

const List<String> canonicalTags = [
  'amitié', 'humour', 'vérité', 'action', 'stratégie', 'créativité',
  'courage', 'mystère', 'flirt', 'tabou', 'société', 'ambition', 'famille', 'nostalgie',
];

const Map<String, String> _tagMap = {
  // amitié
  'amitié': 'amitié', 'ami': 'amitié', 'groupe': 'amitié', 'relation': 'amitié', 'confiance': 'amitié',
  'solidarité': 'amitié', 'bienveillance': 'amitié', 'lien': 'amitié', 'social': 'amitié',
  // humour
  'humour': 'humour', 'rire': 'humour', 'drôle': 'humour', 'fun': 'humour', 'absurde': 'humour',
  'imitation': 'humour', 'taquinerie': 'humour', 'acting': 'humour', 'vocal': 'humour',
  // vérité
  'vérité': 'vérité', 'honnêteté': 'vérité', 'confession': 'vérité', 'secret': 'vérité', 'transparent': 'vérité',
  'introspection': 'vérité', 'vulnérabilité': 'vérité', 'sincérité': 'vérité', 'mensonge': 'vérité',
  'philosophie': 'vérité', 'valeurs': 'vérité', 'morale': 'vérité',
  // action
  'action': 'action', 'défi': 'action', 'physique': 'action', 'activité': 'action', 'mime': 'action',
  'mouvement': 'action', 'geste': 'action', 'sport': 'action',
  // stratégie
  'stratégie': 'stratégie', 'réflexion': 'stratégie', 'planification': 'stratégie', 'choix': 'stratégie',
  'dilemme': 'stratégie', 'pragmatisme': 'stratégie', 'analyse': 'stratégie', 'décision': 'stratégie',
  // créativité
  'créativité': 'créativité', 'imagination': 'créativité', 'invention': 'créativité', 'art': 'créativité',
  'expression': 'créativité', 'originalité': 'créativité', 'simulation': 'créativité',
  // courage
  'courage': 'courage', 'audace': 'courage', 'peur': 'courage', 'risque': 'courage', 'dépassement': 'courage',
  'téméraire': 'courage', 'osé': 'courage', 'engagement': 'courage',
  // mystère
  'mystère': 'mystère', 'énigme': 'mystère', 'inconnu': 'mystère', 'surprise': 'mystère', 'caché': 'mystère',
  'abstrait': 'mystère', 'profond': 'mystère',
  // flirt
  'flirt': 'flirt', 'amour': 'flirt', 'attirance': 'flirt', 'séduction': 'flirt', 'romantique': 'flirt',
  'baiser': 'flirt', 'intimité': 'flirt', 'sensualité': 'flirt', 'désir': 'flirt', 'sexe': 'flirt',
  'sexualité': 'flirt', 'fantasme': 'flirt',
  // tabou
  'tabou': 'tabou', 'interdit': 'tabou', 'limite': 'tabou', 'choquant': 'tabou', 'provocant': 'tabou',
  'gêne': 'tabou', 'honte': 'tabou', 'nudité': 'tabou', 'strip': 'tabou', 'ex': 'tabou',
  'insécurité': 'tabou', 'toxicité': 'tabou', 'manipulation': 'tabou',
  // société
  'société': 'société', 'politique': 'société', 'technologie': 'société', 'environnement': 'société',
  'travail': 'société', 'monde': 'société', 'actualité': 'société', 'justice': 'société',
  'inégalité': 'société', 'culture': 'société', 'génération': 'société',
  // ambition
  'ambition': 'ambition', 'réussite': 'ambition', 'carrière': 'ambition', 'argent': 'ambition',
  'succès': 'ambition', 'objectif': 'ambition', 'motivation': 'ambition', 'croissance': 'ambition',
  'transformation': 'ambition', 'potentiel': 'ambition',
  // famille
  'famille': 'famille', 'parent': 'famille', 'enfant': 'famille', 'frère': 'famille', 'sœur': 'famille',
  'héritage': 'famille', 'éducation': 'famille', 'mariage': 'famille', 'foyer': 'famille',
  // nostalgie
  'nostalgie': 'nostalgie', 'souvenir': 'nostalgie', 'passé': 'nostalgie', 'enfance': 'nostalgie',
  'mémoire': 'nostalgie', 'regret': 'nostalgie', 'voyage': 'nostalgie', 'rêve': 'nostalgie',
};

String? normalizeTag(String raw) => _tagMap[raw.trim().toLowerCase()];

/// Dédoublonne en conservant l'ordre de première apparition (comme un Set JS).
List<String> normalizeTags(Iterable<String> rawTags) {
  final result = <String>{};
  for (final t in rawTags) {
    final c = normalizeTag(t);
    if (c != null) result.add(c);
  }
  return result.toList();
}

const Map<String, String> tagTypeMap = {
  'amitié': 'Le Cœur de la bande',
  'humour': 'Le Clown de service',
  'vérité': "L'Honnête brutal",
  'action': "L'Aventurier",
  'stratégie': 'Le Stratège',
  'créativité': "L'Artiste",
  'courage': 'Le Téméraire',
  'mystère': "L'Énigmatique",
  'flirt': 'Le Séducteur',
  'tabou': 'Le Provocateur',
  'société': 'Le Citoyen engagé',
  'ambition': "L'Ambitieux",
  'famille': 'Le Pilier familial',
  'nostalgie': 'Le Nostalgique',
};

const String playerTypeUnknown = 'Le Mystérieux';
const String playerTypeUnclassified = "L'Inclassable";

/// Archétype = tag dominant du profil. En cas d'égalité, le premier inséré
/// gagne — c'est ce que fait le tri stable de V8 dans l'implémentation TS.
String getPlayerType(Map<String, int> tagScores) {
  String? bestKey;
  var bestValue = 0;
  for (final e in tagScores.entries) {
    if (bestKey == null || e.value > bestValue) {
      bestKey = e.key;
      bestValue = e.value;
    }
  }
  if (bestKey == null || bestValue == 0) return playerTypeUnknown;
  return tagTypeMap[bestKey] ?? playerTypeUnclassified;
}
