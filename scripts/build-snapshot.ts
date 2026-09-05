// Génère `content_v{n}.json` depuis Neon (§06).
//
// Le snapshot est IMMUABLE : une fois publié, une version ne change plus.
// L'app en embarque un au build, puis télécharge les suivants. Elle ne lit
// jamais la base directement.
//
//   node --experimental-strip-types build-snapshot.ts [--version N] [--out chemin]

import { writeFileSync } from 'node:fs';
import { PrismaClient } from '@prisma/client';
import { SnapshotSchema, type Snapshot } from '@playlink/content-schema/snapshot.ts';

const prisma = new PrismaClient();
const args = process.argv.slice(2);
const argOf = (n: string) => { const i = args.indexOf(n); return i < 0 ? null : args[i + 1]; };


/** N'émet un bloc `translations` que s'il contient une langue autre que FR. */
function pack<T extends { locale: string }>(rows: T[], build: (r: T) => unknown) {
  const out: Record<string, unknown> = {};
  for (const r of rows) if (r.locale !== 'fr') out[r.locale] = build(r);
  return Object.keys(out).length ? out : undefined;
}

async function main() {
  const explicit = argOf('--version');
  const last = await prisma.contentRelease.findFirst({ orderBy: { version: 'desc' } });
  const version = explicit ? parseInt(explicit, 10) : (last?.version ?? 0) + 1;

  const games = await prisma.game.findMany({
    where: { active: true },
    orderBy: { order: 'asc' },
    include: {
      translations: true,
      ruleSlides: { orderBy: { order: 'asc' }, include: { translations: true } },
      categories: {
        orderBy: { order: 'asc' },
        include: {
          translations: true,
          cards: {
            where: { active: true },
            orderBy: { order: 'asc' },
            include: { translations: true },
          },
        },
      },
    },
  });

  const badges = await prisma.badge.findMany({ orderBy: { order: 'asc' }, include: { translations: true } });
  const legal = await prisma.legalContent.findMany();

  // Source unique avec le back-office : la table, pas le fichier. Le
  // back-office déployé n'a pas accès au dossier apps/mobile.
  const assetRows = await prisma.contentAsset.findMany({ orderBy: { ref: 'asc' } });
  const assets = assetRows.map((a) => ({ ref: a.ref, file: a.file, hash: a.hash, bytes: a.bytes, type: a.type }));
  if (!assets.length) console.warn('⚠ aucun asset en base — lance d\'abord fetch-assets.ts');

  const snapshot: Snapshot = {
    version,
    generatedAt: new Date().toISOString(),
    originalLocale: 'fr',
    locales: ['fr', 'en'],
    games: games.map((g) => ({
      id: g.id, slug: g.slug, name: g.name, description: g.description,
      icon: g.icon, colorMain: g.colorMain, colorSecondary: g.colorSecondary,
      order: g.order,
      translations: pack(g.translations, (t) => ({ name: t.name, description: t.description })) as never,
      ruleSlides: g.ruleSlides.map((s) => ({
        id: s.id, order: s.order, title: s.title, content: s.content,
        imageRef: s.imageRef,
        translations: pack(s.translations, (t) => ({ title: t.title, content: t.content })) as never,
      })),
      categories: g.categories.map((c) => ({
        id: c.id, slug: c.slug, name: c.name, description: c.description,
        icon: c.icon, order: c.order, tier: c.tier,
        translations: pack(c.translations, (t) => ({ name: t.name, description: t.description })) as never,
        cards: c.cards.map((cd) => ({
          id: cd.id, text: cd.text, intensity: cd.intensity,
          tags: cd.tags, canonicalTags: cd.canonicalTags,
          order: cd.order, tier: cd.tier,
          translations: pack(cd.translations, (t) => t.text) as never,
        })),
      })),
    })),
    badges: badges.map((b) => ({
      key: b.key, name: b.name, description: b.description, icon: b.icon, order: b.order,
      translations: pack(b.translations, (t) => ({ name: t.name, description: t.description })) as never,
    })),
    legal: legal.map((l) => ({ key: l.key, locale: l.locale as 'fr' | 'en', title: l.title, content: l.content })),
    assets,
  };

  // Valider AVANT d'écrire : un snapshot malformé publié casserait toutes
  // les apps qui le téléchargent.
  const parsed = SnapshotSchema.safeParse(snapshot);
  if (!parsed.success) {
    console.error('✗ snapshot invalide :');
    console.error(JSON.stringify(parsed.error.issues.slice(0, 10), null, 2));
    process.exit(1);
  }

  const out = argOf('--out')
    ?? new URL(`../apps/mobile/assets/content/content_v${version}.json`, import.meta.url).pathname;
  const json = JSON.stringify(snapshot);
  writeFileSync(out, json + '\n');

  const cards = snapshot.games.reduce((s, g) => s + g.categories.reduce((n, c) => n + c.cards.length, 0), 0);
  console.log(`version        v${version}`);
  console.log(`jeux           ${snapshot.games.length}`);
  console.log(`catégories     ${snapshot.games.reduce((s, g) => s + g.categories.length, 0)}`);
  console.log(`cartes         ${cards}`);
  console.log(`slides         ${snapshot.games.reduce((s, g) => s + g.ruleSlides.length, 0)}`);
  console.log(`badges         ${snapshot.badges.length}`);
  console.log(`assets         ${snapshot.assets.length}`);
  console.log(`poids JSON     ${(json.length / 1024 / 1024).toFixed(2)} Mo`);
  console.log(`\n→ ${out}`);
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
