import { LANDING_FIELDS, LANDING_SECTIONS, landingEnGaps } from "@playlink/content-schema/landing-keys.ts";
import { prisma } from "@/lib/prisma";
import { SiteEditor } from "./SiteEditor";
import type { EditorGame, SiteDraft, SiteTexts } from "./types";

export const dynamic = "force-dynamic";
export const metadata = { title: "Contenu du site" };

/** Actions qui publient la landing (l'ancien formulaire en écrivait trois). */
const SITE_ACTIONS = ["published_site", "updated_landing_texts", "updated_landing_settings", "updated_site_content"];

export default async function Site({ searchParams }: { searchParams: Promise<{ sec?: string }> }) {
  const sp = await searchParams;
  const [site, rows, games, counts, samples, lastPublish] = await Promise.all([
    prisma.siteContent.findUnique({ where: { id: "default" } }),
    prisma.landingText.findMany({ select: { locale: true, key: true, value: true, updatedAt: true } }),
    prisma.game.findMany({
      orderBy: { order: "asc" },
      select: {
        id: true, name: true, icon: true, active: true, colorMain: true, colorSecondary: true,
        translations: { where: { locale: "en" }, select: { name: true } },
        categories: { orderBy: { order: "asc" }, select: { id: true, name: true, previewEligible: true } },
      },
    }),
    prisma.card.groupBy({ by: ["categoryId", "intensity"], where: { active: true }, _count: { _all: true } }),
    // Une carte par catégorie (la plus douce) pour l'aperçu de la démo.
    prisma.card.findMany({
      where: { active: true },
      distinct: ["categoryId"],
      orderBy: [{ categoryId: "asc" }, { intensity: "asc" }, { order: "asc" }],
      select: { categoryId: true, text: true, intensity: true },
    }),
    prisma.auditLog.findFirst({ where: { action: { in: SITE_ACTIONS } }, orderBy: { createdAt: "desc" }, select: { createdAt: true } }),
  ]);

  // Valeur affichée = valeur en base, sinon texte par défaut : c'est ce
  // que la landing montre aujourd'hui. Une valeur vide en base reste vide
  // (EN pas encore traduit).
  const stored = (locale: string, key: string) => rows.find((r) => r.locale === locale && r.key === key)?.value;
  const texts = Object.fromEntries(
    LANDING_FIELDS.map((f) => [f.key, { fr: stored("fr", f.key) ?? f.fr, en: stored("en", f.key) ?? f.en }]),
  ) as SiteTexts;

  const initial: SiteDraft = {
    texts,
    settings: {
      releaseDate: site?.releaseDate ? site.releaseDate.toISOString().slice(0, 10) : "",
      featuredGameIds: site?.featuredGameIds ?? [],
      demoDeckSize: site?.demoDeckSize ?? 5,
      demoMaxIntensity: site?.demoMaxIntensity ?? 3,
      doubleOptIn: site?.doubleOptIn ?? false,
      instagramUrl: site?.instagramUrl ?? "",
      tiktokUrl: site?.tiktokUrl ?? "",
      redditUrl: site?.redditUrl ?? "",
    },
    eligible: Object.fromEntries(games.flatMap((g) => g.categories.map((c) => [c.id, c.previewEligible]))),
    enStale: Object.fromEntries(landingEnGaps(rows).map((g) => [g.key, true])),
  };

  const editorGames: EditorGame[] = games.map((g) => ({
    id: g.id,
    name: g.name,
    icon: g.icon,
    active: g.active,
    colorMain: g.colorMain,
    colorSecondary: g.colorSecondary,
    nameEn: g.translations[0]?.name ?? null,
    categories: g.categories.map((c) => {
      const byIntensity = [1, 2, 3, 4, 5].map(
        (n) => counts.find((x) => x.categoryId === c.id && x.intensity === n)?._count._all ?? 0,
      );
      const sample = samples.find((s) => s.categoryId === c.id);
      return { id: c.id, name: c.name, byIntensity, sample: sample ? { text: sample.text, intensity: sample.intensity } : null };
    }),
  }));

  const section = LANDING_SECTIONS.find((s) => s.id === sp.sec)?.id ?? LANDING_SECTIONS[0].id;

  return (
    // L'en-tête (titre, statut, Annuler / Publier) vit dans l'éditeur :
    // ses boutons dépendent de l'état client.
    <SiteEditor
      initial={initial}
      games={editorGames}
      initialSection={section}
      lastPublishedAt={lastPublish?.createdAt.toISOString() ?? null}
    />
  );
}
