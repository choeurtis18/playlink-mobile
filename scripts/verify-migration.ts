// Vérification de la migration (§07) : compte les lignes source vs cible et
// liste les écarts. Produit AUSSI le décompte exact par jeu/catégorie/
// intensité — le blueprint exige qu'il vienne d'ici, pas d'une estimation.

import { readFileSync } from 'node:fs';
import { PrismaClient } from '@prisma/client';
import { parseDump, parsePgArray } from './parse-dump.ts';

const prisma = new PrismaClient();
const DUMP = new URL('./dumps/playlink_content.sql', import.meta.url).pathname;

let failures = 0;
function check(label: string, source: number, target: number) {
  const ok = source === target;
  if (!ok) failures++;
  console.log(`  ${ok ? '✓' : '✗'} ${label.padEnd(20)} source ${String(source).padStart(5)}  cible ${String(target).padStart(5)}`);
}

async function main() {
  const t = parseDump(readFileSync(DUMP, 'utf8'));
  const src = (n: string) => (t.get(n) ?? []).length;

  console.log('COMPTAGES SOURCE vs CIBLE\n');
  check('games', src('games'), await prisma.game.count());
  check('categories', src('categories'), await prisma.category.count());
  check('cards', src('cards'), await prisma.card.count());
  check('rule slides', src('game_rule_slides'), await prisma.gameRuleSlide.count());
  check('badges', src('badges'), await prisma.badge.count());
  check('legal contents', src('legal_contents'), await prisma.legalContent.count());

  console.log('\nINTÉGRITÉ\n');
  const noText = await prisma.card.count({ where: { text: '' } });
  check('cartes sans texte', 0, noText);
  const badIntensity = await prisma.card.count({ where: { OR: [{ intensity: { lt: 1 } }, { intensity: { gt: 5 } }] } });
  check('intensité hors 1-5', 0, badIntensity);
  const noCanonical = await prisma.card.count({ where: { canonicalTags: { isEmpty: true } } });
  check('sans tag canonique', 0, noCanonical);
  const slidesNoRef = await prisma.gameRuleSlide.count({ where: { imageRef: null } });
  check('slides sans image', 0, slidesNoRef);

  // Les id cuid d'origine doivent être conservés (§07) : c'est ce qui permet
  // un ré-import et garde les références d'assets valides.
  const srcIds = new Set((t.get('cards') ?? []).map((c) => c.id));
  const dbIds = (await prisma.card.findMany({ select: { id: true } })).map((c) => c.id);
  check('id cuid conservés', srcIds.size, dbIds.filter((id) => srcIds.has(id)).length);

  console.log('\nDÉCOMPTE PAR JEU\n');
  const games = await prisma.game.findMany({
    orderBy: { order: 'asc' },
    include: { categories: { include: { _count: { select: { cards: true } } } } },
  });
  let total = 0;
  for (const g of games) {
    const n = g.categories.reduce((s, c) => s + c._count.cards, 0);
    total += n;
    console.log(`  ${g.icon ?? ''} ${g.name.padEnd(20)} ${String(g.categories.length).padStart(2)} cat.  ${String(n).padStart(4)} cartes`);
  }
  console.log(`  ${''.padEnd(23)} ${String(games.length).padStart(2)} jeux ${String(total).padStart(5)} cartes`);

  console.log('\nRÉPARTITION PAR INTENSITÉ\n');
  const byIntensity = await prisma.card.groupBy({ by: ['intensity'], _count: true, orderBy: { intensity: 'asc' } });
  for (const r of byIntensity) console.log(`  intensité ${r.intensity}  ${String(r._count).padStart(5)} cartes`);

  console.log(failures === 0 ? '\n✅ MIGRATION VÉRIFIÉE — aucun écart' : `\n❌ ${failures} ÉCART(S) DÉTECTÉ(S)`);
  process.exit(failures === 0 ? 0 : 1);
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
