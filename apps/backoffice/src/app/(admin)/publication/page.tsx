import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

export default async function Publication() {
  const [releases, cards, updatedSince] = await Promise.all([
    prisma.contentRelease.findMany({ orderBy: { version: "desc" }, take: 20 }),
    prisma.card.count({ where: { active: true } }),
    prisma.contentRelease.findFirst({ orderBy: { version: "desc" } }).then((r) =>
      r ? prisma.card.count({ where: { updatedAt: { gt: r.publishedAt } } }) : 0,
    ),
  ]);
  const latest = releases[0];

  return (
    <>
      <h1 className="mb-2 text-2xl font-semibold">Publication</h1>
      <p className="mb-6 max-w-prose text-sm text-neutral-faint">
        L&apos;app ne consomme jamais le contenu live : elle télécharge une
        release figée. Rien n&apos;est servi tant qu&apos;une version n&apos;est
        pas publiée — on édite tranquillement.
      </p>

      <div className="mb-6 rounded-lg border border-hairline bg-surface p-4">
        <div className="text-sm text-ink-soft">
          Version courante : <strong className="text-ink">{latest ? `v${latest.version}` : "aucune"}</strong>
          {" · "}{cards} cartes actives
          {updatedSince > 0 && (
            <> · <span className="text-accent">{updatedSince} cartes modifiées depuis</span></>
          )}
        </div>
        <div className="mt-3 text-xs text-neutral-faint">
          Publication via <code>pnpm --filter @playlink/scripts build:snapshot</code> puis{" "}
          <code>publish:release</code>. Le bouton « Publier » arrive en phase 5.
        </div>
      </div>

      <div className="overflow-hidden rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr><th className="p-3">Version</th><th className="p-3">Publiée le</th><th className="p-3">Changelog</th></tr>
          </thead>
          <tbody>
            {releases.map((r) => (
              <tr key={r.id} className="border-t border-hairline">
                <td className="p-3 font-medium">v{r.version}</td>
                <td className="p-3 text-ink-soft">{r.publishedAt.toLocaleString("fr-FR")}</td>
                <td className="p-3 text-ink-soft">{r.changelog}</td>
              </tr>
            ))}
            {!releases.length && (
              <tr><td colSpan={3} className="p-3 text-neutral-faint">Aucune release publiée</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </>
  );
}
