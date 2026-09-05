import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { prisma } from "./prisma";
import type { Snapshot } from "@playlink/content-schema/snapshot.ts";

/** N'émet un bloc `translations` que s'il contient une langue autre que FR. */
function pack<T extends { locale: string }>(rows: T[], build: (r: T) => unknown) {
  const out: Record<string, unknown> = {};
  for (const r of rows) if (r.locale !== "fr") out[r.locale] = build(r);
  return Object.keys(out).length ? out : undefined;
}

export async function buildSnapshot(version: number): Promise<Snapshot> {
  const games = await prisma.game.findMany({
    where: { active: true },
    orderBy: { order: "asc" },
    include: {
      translations: true,
      ruleSlides: { orderBy: { order: "asc" }, include: { translations: true } },
      categories: {
        orderBy: { order: "asc" },
        include: {
          translations: true,
          cards: { where: { active: true }, orderBy: { order: "asc" }, include: { translations: true } },
        },
      },
    },
  });
  const badges = await prisma.badge.findMany({ orderBy: { order: "asc" }, include: { translations: true } });
  const legal = await prisma.legalContent.findMany();

  const manifestPath = join(process.cwd(), "../../apps/mobile/assets/content/assets-manifest.json");
  const assets = existsSync(manifestPath) ? JSON.parse(readFileSync(manifestPath, "utf8")) : [];

  return {
    version,
    generatedAt: new Date().toISOString(),
    originalLocale: "fr",
    locales: ["fr", "en"],
    games: games.map((g) => ({
      id: g.id, slug: g.slug, name: g.name, description: g.description,
      icon: g.icon, colorMain: g.colorMain, colorSecondary: g.colorSecondary, order: g.order,
      translations: pack(g.translations, (t) => ({ name: t.name, description: t.description })) as never,
      ruleSlides: g.ruleSlides.map((s) => ({
        id: s.id, order: s.order, title: s.title, content: s.content, imageRef: s.imageRef,
        translations: pack(s.translations, (t) => ({ title: t.title, content: t.content })) as never,
      })),
      categories: g.categories.map((c) => ({
        id: c.id, slug: c.slug, name: c.name, description: c.description,
        icon: c.icon, order: c.order, tier: c.tier,
        translations: pack(c.translations, (t) => ({ name: t.name, description: t.description })) as never,
        cards: c.cards.map((cd) => ({
          id: cd.id, text: cd.text, intensity: cd.intensity,
          tags: cd.tags, canonicalTags: cd.canonicalTags, order: cd.order, tier: cd.tier,
          translations: pack(cd.translations, (t) => t.text) as never,
        })),
      })),
    })),
    badges: badges.map((b) => ({
      key: b.key, name: b.name, description: b.description, icon: b.icon, order: b.order,
      translations: pack(b.translations, (t) => ({ name: t.name, description: t.description })) as never,
    })),
    legal: legal.map((l) => ({ key: l.key, locale: l.locale as "fr" | "en", title: l.title, content: l.content })),
    assets,
  };
}
