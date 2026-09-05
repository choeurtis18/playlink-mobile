// Portage de `packages/app/src/lib/tag-mapping.ts` (app web).
// Source de vérité partagée : la migration s'en sert pour pré-calculer
// `Card.canonicalTags`, et le portage Dart de la phase 2 doit produire des
// résultats identiques (tests ligne à ligne, §02).
//
// Ne pas modifier sans porter le changement côté Dart : un archétype qui
// diverge entre les deux implémentations serait invisible et faux.

export const CANONICAL_TAGS = [
  'amitié', 'humour', 'vérité', 'action', 'stratégie', 'créativité',
  'courage', 'mystère', 'flirt', 'tabou', 'société', 'ambition', 'famille', 'nostalgie',
] as const;
export type CanonicalTag = typeof CANONICAL_TAGS[number];

const TAG_MAP: Record<string, CanonicalTag> = {
  // amitié
  amitié: 'amitié', ami: 'amitié', groupe: 'amitié', relation: 'amitié', confiance: 'amitié',
  solidarité: 'amitié', bienveillance: 'amitié', lien: 'amitié', social: 'amitié',
  // humour
  humour: 'humour', rire: 'humour', drôle: 'humour', fun: 'humour', absurde: 'humour',
  imitation: 'humour', taquinerie: 'humour', acting: 'humour', vocal: 'humour',
  // vérité
  vérité: 'vérité', honnêteté: 'vérité', confession: 'vérité', secret: 'vérité', transparent: 'vérité',
  introspection: 'vérité', vulnérabilité: 'vérité', sincérité: 'vérité', mensonge: 'vérité',
  philosophie: 'vérité', valeurs: 'vérité', morale: 'vérité',
  // action
  action: 'action', défi: 'action', physique: 'action', activité: 'action', mime: 'action',
  mouvement: 'action', geste: 'action', sport: 'action',
  // stratégie
  stratégie: 'stratégie', réflexion: 'stratégie', planification: 'stratégie', choix: 'stratégie',
  dilemme: 'stratégie', pragmatisme: 'stratégie', analyse: 'stratégie', décision: 'stratégie',
  // créativité
  créativité: 'créativité', imagination: 'créativité', invention: 'créativité', art: 'créativité',
  expression: 'créativité', originalité: 'créativité', simulation: 'créativité',
  // courage
  courage: 'courage', audace: 'courage', peur: 'courage', risque: 'courage', dépassement: 'courage',
  téméraire: 'courage', osé: 'courage', engagement: 'courage',
  // mystère
  mystère: 'mystère', énigme: 'mystère', inconnu: 'mystère', surprise: 'mystère', caché: 'mystère',
  abstrait: 'mystère', profond: 'mystère',
  // flirt
  flirt: 'flirt', amour: 'flirt', attirance: 'flirt', séduction: 'flirt', romantique: 'flirt',
  baiser: 'flirt', intimité: 'flirt', sensualité: 'flirt', désir: 'flirt', sexe: 'flirt',
  sexualité: 'flirt', fantasme: 'flirt',
  // tabou
  tabou: 'tabou', interdit: 'tabou', limite: 'tabou', choquant: 'tabou', provocant: 'tabou',
  gêne: 'tabou', honte: 'tabou', nudité: 'tabou', strip: 'tabou', ex: 'tabou',
  insécurité: 'tabou', toxicité: 'tabou', manipulation: 'tabou',
  // société
  société: 'société', politique: 'société', technologie: 'société', environnement: 'société',
  travail: 'société', monde: 'société', actualité: 'société', justice: 'société',
  inégalité: 'société', culture: 'société', génération: 'société',
  // ambition
  ambition: 'ambition', réussite: 'ambition', carrière: 'ambition', argent: 'ambition',
  succès: 'ambition', objectif: 'ambition', motivation: 'ambition', croissance: 'ambition',
  transformation: 'ambition', potentiel: 'ambition',
  // famille
  famille: 'famille', parent: 'famille', enfant: 'famille', frère: 'famille', sœur: 'famille',
  héritage: 'famille', éducation: 'famille', mariage: 'famille', foyer: 'famille',
  // nostalgie
  nostalgie: 'nostalgie', souvenir: 'nostalgie', passé: 'nostalgie', enfance: 'nostalgie',
  mémoire: 'nostalgie', regret: 'nostalgie', voyage: 'nostalgie', rêve: 'nostalgie',
};

export function normalizeTag(raw: string): CanonicalTag | null {
  const key = raw.trim().toLowerCase();
  return TAG_MAP[key] ?? null;
}

/** Dédoublonne : deux tags bruts peuvent mener au même tag canonique. */
export function normalizeTags(rawTags: string[]): CanonicalTag[] {
  const result = new Set<CanonicalTag>();
  for (const t of rawTags) {
    const canonical = normalizeTag(t);
    if (canonical) result.add(canonical);
  }
  return [...result];
}

export const TAG_TYPE_MAP: Record<CanonicalTag, string> = {
  amitié:    'Le Cœur de la bande',
  humour:    'Le Clown de service',
  vérité:    "L'Honnête brutal",
  action:    "L'Aventurier",
  stratégie: 'Le Stratège',
  créativité:'L\'Artiste',
  courage:   'Le Téméraire',
  mystère:   "L'Énigmatique",
  flirt:     'Le Séducteur',
  tabou:     'Le Provocateur',
  société:   'Le Citoyen engagé',
  ambition:  'L\'Ambitieux',
  famille:   'Le Pilier familial',
  nostalgie: 'Le Nostalgique',
};

/** Archétype du profil = son tag dominant. Cumulatif sur toutes ses parties. */
export function getPlayerType(tagScores: Record<string, number>): string {
  const entries = Object.entries(tagScores).sort(([, a], [, b]) => b - a);
  if (!entries.length || entries[0][1] === 0) return 'Le Mystérieux';
  return TAG_TYPE_MAP[entries[0][0] as CanonicalTag] ?? "L'Inclassable";
}
