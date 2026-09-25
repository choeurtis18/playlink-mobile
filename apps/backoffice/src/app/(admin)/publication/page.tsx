import { prisma } from "@/lib/prisma";
import { PublishButton } from "./PublishForm";

export const dynamic = "force-dynamic";

export default async function Publication() {
  const latest = await prisma.contentRelease.findFirst({ orderBy: { version: "desc" } });
  const since = latest?.publishedAt;

  const [releases, cards, changedCards, changedSlides, recentLogs] = await Promise.all([
    prisma.contentRelease.findMany({ orderBy: { version: "desc" }, take: 20 }),
    prisma.card.count({ where: { active: true } }),
    since ? prisma.card.count({ where: { updatedAt: { gt: since } } }) : 0,
    since ? prisma.gameRuleSlide.count({ where: { updatedAt: { gt: since } } }) : 0,
    prisma.auditLog.findMany({ orderBy: { createdAt: "desc" }, take: 10 }),
  ]);
  const changes = changedCards + changedSlides;

  return (
    <>
      <h1 className="mb-2 font-display text-[32px] font-semibold tracking-[-0.025em]">Publication</h1>
      <p className="mb-6 max-w-prose text-sm text-neutral-faint">
        L&apos;app ne consomme jamais le contenu live : elle télécharge une release
        figée. Rien n&apos;est servi tant qu&apos;une version n&apos;est pas publiée.
      </p>

      <div className="mb-6 rounded-lg border border-hairline bg-surface p-4">
        <div className="mb-4 text-sm text-ink-soft">
          Version courante : <strong className="text-ink">{latest ? `v${latest.version}` : "aucune"}</strong>
          {" · "}{cards} cartes actives
          {changes > 0
            ? <> · <span className="text-accent">{changedCards} cartes et {changedSlides} slides modifiées depuis</span></>
            : latest && <> · <span className="text-neutral-faint">aucune modification depuis</span></>}
        </div>
        <PublishButton changes={changes} />
      </div>

      <p className="mb-6 text-sm text-neutral-faint">
        Import en masse : bouton « Importer » sur les pages{" "}
        <a href="/cartes" className="text-accent hover:underline">Cartes</a> et{" "}
        <a href="/jeux" className="text-accent hover:underline">Jeux</a>.
      </p>

      <h2 className="mb-3 font-medium">Historique des versions</h2>
      <div className="mb-6 overflow-x-auto rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr><th className="p-3">Version</th><th className="p-3">Publiée le</th><th className="p-3">Changelog</th></tr>
          </thead>
          <tbody>
            {releases.map((r) => (
              <tr key={r.id} className="border-t border-hairline">
                <td className="p-3 font-medium">v{r.version}</td>
                <td className="whitespace-nowrap p-3 text-ink-soft">{r.publishedAt.toLocaleString("fr-FR")}</td>
                <td className="p-3 text-ink-soft">{r.changelog}</td>
              </tr>
            ))}
            {!releases.length && <tr><td colSpan={3} className="p-3 text-neutral-faint">Aucune release</td></tr>}
          </tbody>
        </table>
      </div>

      {recentLogs.length > 0 && (
        <>
          <h2 className="mb-3 font-medium">Activité récente</h2>
          <div className="overflow-x-auto rounded-lg border border-hairline">
            <table className="w-full text-sm">
              <tbody>
                {recentLogs.map((l) => (
                  <tr key={l.id} className="border-t border-hairline first:border-t-0">
                    <td className="whitespace-nowrap p-2 text-xs text-neutral-faint">{l.createdAt.toLocaleString("fr-FR")}</td>
                    <td className="p-2"><code className="text-xs">{l.action}</code></td>
                    <td className="p-2 text-xs text-ink-soft">{l.entity}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </>
  );
}
