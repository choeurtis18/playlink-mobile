// Miroir documentaire des règles d'attribution des badges.
//
// La règle elle-même est une fonction Dart (apps/mobile/lib/core/badges.dart,
// `badgeDefs`), évaluée sur l'appareil en fin de partie ; le back-office ne
// gère que les métadonnées, reliées par la clé. Cette table l'explique à
// l'éditeur et fournit les valeurs par défaut (mêmes que
// scripts/seed-badges.ts) pour créer en un clic un badge prévu mais absent.
// À tenir à jour avec badges.dart.

export type BadgeRule = {
  key: string;
  /** Condition de déblocage, telle que codée dans l'app. */
  rule: string;
  /** false : la règle existe mais ne peut pas encore se déclencher. */
  live: boolean;
  defaults: { name: string; description: string; icon: string };
};

export const BADGE_RULES: BadgeRule[] = [
  { key: "first_win", rule: "Premier point marqué, tous jeux confondus", live: true,
    defaults: { name: "Première victoire", description: "Tu as marqué ton tout premier point.", icon: "🏆" } },
  { key: "party_legend", rule: "20 points cumulés sur l’appareil", live: true,
    defaults: { name: "Légende de soirée", description: "20 points cumulés. La soirée se souvient de toi.", icon: "👑" } },
  { key: "social_butterfly", rule: "5 parties jouées à 4 joueurs ou plus", live: true,
    defaults: { name: "Papillon social", description: "5 parties jouées à 4 joueurs ou plus.", icon: "🦋" } },
  { key: "truth_seeker", rule: "10 cartes taguées « vérité » remportées", live: true,
    defaults: { name: "Chercheur de vérité", description: "10 cartes de vérité remportées.", icon: "🔍" } },
  { key: "three_peat", rule: "3 victoires d’affilée d’un même joueur, toutes sessions confondues", live: true,
    defaults: { name: "Triplé", description: "3 parties gagnées d’affilée.", icon: "🔥" } },
  { key: "explorer", rule: "Au moins une partie dans 8 jeux différents", live: true,
    defaults: { name: "Explorateur", description: "Au moins une partie dans chacun des 8 jeux.", icon: "🧭" } },
  { key: "night_owl", rule: "Une partie terminée entre 2 h et 5 h du matin", live: true,
    defaults: { name: "Oiseau de nuit", description: "Une partie terminée entre 2 h et 5 h du matin.", icon: "🦉" } },
  { key: "author", rule: "5 cartes personnalisées créées — pas encore débloquable (cartes perso à venir)", live: false,
    defaults: { name: "Auteur", description: "5 cartes personnalisées créées.", icon: "✍️" } },
  { key: "polyglot", rule: "Des parties jouées en français et en anglais", live: true,
    defaults: { name: "Polyglotte", description: "Tu as joué en français et en anglais.", icon: "🌍" } },
  { key: "curator", rule: "20 cartes likées — pas encore débloquable (compte requis)", live: false,
    defaults: { name: "Curateur", description: "20 cartes likées.", icon: "💖" } },
  { key: "centurion", rule: "100 points cumulés sur l’appareil", live: true,
    defaults: { name: "Centurion", description: "100 points cumulés, tous jeux confondus.", icon: "💯" } },
  { key: "marathon", rule: "50 parties terminées", live: true,
    defaults: { name: "Marathonien", description: "50 parties terminées.", icon: "🏃" } },
];

export const badgeRule = (key: string) => BADGE_RULES.find((r) => r.key === key);
