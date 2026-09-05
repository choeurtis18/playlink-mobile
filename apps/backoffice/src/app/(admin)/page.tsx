import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

export default async function Home() {
  const [games, categories, cards, slides, badges, release, untranslated] = await Promise.all([
    prisma.game.count(),
    prisma.category.count(),
    prisma.card.count({ where: { active: true } }),
    prisma.gameRuleSlide.count(),
    prisma.badge.count(),
    prisma.contentRelease.findFirst({ orderBy: { version: "desc" } }),
    prisma.card.count({ where: { translations: { none: { locale: "en" } } } }),
  ]);

  const stats = [
    { label: "Jeux", value: games },
    { label: "Catégories", value: categories },
    { label: "Cartes actives", value: cards },
    { label: "Slides de règles", value: slides },
    { label: "Badges", value: badges },
    { label: "Version publiée", value: release ? `v${release.version}` : "—" },
  ];

  return (
    <>
      <h1 className="mb-6 text-2xl font-semibold">Tableau de bord</h1>
      <div className="grid grid-cols-2 gap-3 md:grid-cols-3">
        {stats.map((s) => (
          <div key={s.label} className="rounded-lg border border-hairline bg-surface p-4">
            <div className="text-2xl font-semibold">{s.value}</div>
            <div className="text-sm text-neutral-faint">{s.label}</div>
          </div>
        ))}
      </div>

      <div className="mt-6 rounded-lg border border-hairline bg-surface p-4">
        <div className="text-sm text-ink-soft">
          <strong className="text-ink">{untranslated}</strong> cartes sans traduction anglaise
          {cards > 0 && <> — couverture {Math.round(((cards - untranslated) / cards) * 100)} %</>}
        </div>
      </div>

      <p className="mt-8 max-w-prose text-sm text-neutral-faint">
        Les statistiques d&apos;usage (DAU, parties, rétention) arriveront en phase 5,
        alimentées par le cron horaire d&apos;agrégation.
      </p>
    </>
  );
}
