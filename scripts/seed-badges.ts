// Crée les badges du §01 absents de la base et ordonne l'ensemble.
//
// Métadonnées seulement : la règle d'attribution est une fonction Dart
// identifiée par `key`, évaluée sur l'appareil en fin de partie.
// Idempotent — rejouable sans créer de doublon.

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Ordre = progression ressentie : les badges faciles d'abord.
const BADGES = [
  { key: 'first_win',        name: 'Première victoire',   description: 'Tu as marqué ton tout premier point.',                    icon: '🏆' },
  { key: 'party_legend',     name: 'Légende de soirée',   description: '20 points cumulés. La soirée se souvient de toi.',        icon: '👑' },
  { key: 'social_butterfly', name: 'Papillon social',     description: '5 parties jouées à 4 joueurs ou plus.',                   icon: '🦋' },
  { key: 'truth_seeker',     name: 'Chercheur de vérité', description: '10 cartes de vérité remportées.',                         icon: '🔍' },
  { key: 'three_peat',       name: 'Triplé',              description: '3 parties gagnées d\'affilée.',                           icon: '🔥' },
  { key: 'explorer',         name: 'Explorateur',         description: 'Au moins une partie dans chacun des 8 jeux.',             icon: '🧭' },
  { key: 'night_owl',        name: 'Oiseau de nuit',      description: 'Une partie terminée entre 2 h et 5 h du matin.',          icon: '🦉' },
  { key: 'author',           name: 'Auteur',              description: '5 cartes personnalisées créées.',                        icon: '✍️' },
  { key: 'polyglot',         name: 'Polyglotte',          description: 'Tu as joué en français et en anglais.',                   icon: '🌍' },
  { key: 'curator',          name: 'Curateur',            description: '20 cartes likées.',                                      icon: '💖' },
  { key: 'centurion',        name: 'Centurion',           description: '100 points cumulés, tous jeux confondus.',                icon: '💯' },
  { key: 'marathon',         name: 'Marathonien',         description: '50 parties terminées.',                                  icon: '🏃' },
];

async function main() {
  let created = 0, updated = 0;

  for (const [i, b] of BADGES.entries()) {
    const existing = await prisma.badge.findUnique({ where: { key: b.key } });
    if (existing) {
      // Ne touche qu'à l'ordre : un nom déjà retouché au back-office ne doit
      // pas être écrasé par ce script.
      await prisma.badge.update({ where: { key: b.key }, data: { order: i } });
      updated++;
    } else {
      await prisma.badge.create({ data: { ...b, order: i } });
      created++;
      console.log(`  + ${b.icon}  ${b.key.padEnd(18)} ${b.name}`);
    }
  }

  console.log(`\ncréés     ${created}`);
  console.log(`réordonnés ${updated}`);
  console.log(`total     ${await prisma.badge.count()}`);
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
