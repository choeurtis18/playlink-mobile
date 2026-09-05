// Migration du contenu de l'ancienne base Playlink vers Neon (§07).
//
// Migre UNIQUEMENT le contenu : games, categories, cards, rule slides, badges,
// legal contents. Pas les joueurs/utilisateurs (consigne produit, §02).
//
// Idempotent : rejouer le script ne crée pas de doublons (upsert sur les id
// cuid d'origine, qui sont conservés — §07).
//
//   node --experimental-strip-types migrate-content.ts [--dry-run]

import { readFileSync } from 'node:fs';
import { PrismaClient } from '@prisma/client';
import { parseDump, parsePgArray, bool, int, date } from './parse-dump.ts';
import { normalizeTags } from '@playlink/content-schema/tag-mapping.ts';

const DRY = process.argv.includes('--dry-run');
const DUMP = new URL('./dumps/playlink_content.sql', import.meta.url).pathname;

const prisma = new PrismaClient();

async function main() {
  const tables = parseDump(readFileSync(DUMP, 'utf8'));
  const get = (t: string) => tables.get(t) ?? [];

  console.log(DRY ? '— SIMULATION, aucune écriture —\n' : '— IMPORT VERS NEON —\n');

  // Ordre imposé par les clés étrangères : games → categories → cards.
  const games = get('games');
  for (const g of games) {
    const data = {
      name: g.name!, slug: g.slug!, description: g.description,
      icon: g.icon, colorMain: g.colorMain!, colorSecondary: g.colorSecondary!,
      active: bool(g.active), order: int(g.order),
      originalLocale: 'fr',
      createdAt: date(g.createdAt), updatedAt: date(g.updatedAt),
    };
    if (!DRY) await prisma.game.upsert({ where: { id: g.id! }, create: { id: g.id!, ...data }, update: data });
  }
  console.log(`games            ${games.length}`);

  const categories = get('categories');
  for (const c of categories) {
    const data = {
      gameId: c.gameId!, name: c.name!, slug: c.slug!,
      description: c.description, icon: c.icon, order: int(c.order),
      originalLocale: 'fr',
      createdAt: date(c.createdAt), updatedAt: date(c.updatedAt),
    };
    if (!DRY) await prisma.category.upsert({ where: { id: c.id! }, create: { id: c.id!, ...data }, update: data });
  }
  console.log(`categories       ${categories.length}`);

  // Les tags bruts sont conservés tels quels ; les tags canoniques sont
  // pré-calculés ici pour que l'app n'ait pas à normaliser au runtime (§07).
  const cards = get('cards');
  let unknownTags = 0;
  for (const c of cards) {
    const raw = parsePgArray(c.tags);
    const canonical = normalizeTags(raw);
    if (raw.length && !canonical.length) unknownTags++;
    const data = {
      categoryId: c.categoryId!, text: c.text!,
      intensity: int(c.intensity) || 3,
      tags: raw, canonicalTags: canonical,
      active: bool(c.active), order: int(c.order),
      originalLocale: 'fr',
      createdAt: date(c.createdAt), updatedAt: date(c.updatedAt),
    };
    if (!DRY) await prisma.card.upsert({ where: { id: c.id! }, create: { id: c.id!, ...data }, update: data });
  }
  console.log(`cards            ${cards.length}${unknownTags ? `  (⚠ ${unknownTags} sans tag canonique)` : ''}`);

  // `imageUrl` → `imageRef` en `asset://{fichier}` : l'app résout la référence
  // contre sa table `assets` locale, jamais une URL réseau (offline strict).
  const slides = get('game_rule_slides');
  for (const s of slides) {
    const file = s.imageUrl ? s.imageUrl.split('/').pop()!.split('?')[0] : null;
    const data = {
      gameId: s.gameId!, order: int(s.order),
      title: s.title!, content: s.content!,
      imageRef: file ? `asset://${file}` : null,
      createdAt: date(s.createdAt), updatedAt: date(s.updatedAt),
    };
    if (!DRY) await prisma.gameRuleSlide.upsert({ where: { id: s.id! }, create: { id: s.id!, ...data }, update: data });
  }
  console.log(`rule slides      ${slides.length}`);

  // game_rules est vide en prod : les règles vivent entièrement dans les
  // slides illustrées. Rien à migrer (confirmé produit).
  const rules = get('game_rules');
  if (rules.length) console.log(`⚠ game_rules contient ${rules.length} lignes, non migrées`);

  const badges = get('badges');
  for (const b of badges) {
    const data = { key: b.key!, name: b.name!, description: b.description!, icon: b.icon! };
    if (!DRY) await prisma.badge.upsert({ where: { id: b.id! }, create: { id: b.id!, ...data }, update: data });
  }
  console.log(`badges           ${badges.length}`);

  const legal = get('legal_contents');
  for (const l of legal) {
    const data = { key: l.key!, locale: 'fr', title: l.title!, content: l.content!, updatedAt: date(l.updatedAt) };
    if (!DRY) await prisma.legalContent.upsert({
      where: { key_locale: { key: l.key!, locale: 'fr' } },
      create: { id: l.id!, ...data }, update: data,
    });
  }
  console.log(`legal contents   ${legal.length}`);

  console.log(DRY ? '\nSimulation terminée.' : '\nImport terminé.');
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
