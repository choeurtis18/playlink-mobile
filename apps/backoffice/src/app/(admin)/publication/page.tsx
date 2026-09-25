import Link from "next/link";
import type { Icon } from "@phosphor-icons/react";
import {
  ArrowsDownUpIcon, BrowserIcon, PencilSimpleIcon, PlusCircleIcon, RocketLaunchIcon, ToggleRightIcon,
  TranslateIcon, TrashIcon, UploadSimpleIcon,
} from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { Card, PageHeader } from "@/components/ui";
import { pendingWhere } from "@/lib/shell";
import { recentActivity, relativeTime, type ActivityIcon } from "@/lib/activity";
import { PublishButton } from "./PublishForm";

export const dynamic = "force-dynamic";

const nf = new Intl.NumberFormat("fr-FR");
const ENTITY_LABELS: Record<string, [string, string]> = {
  card: ["carte", "cartes"], category: ["catégorie", "catégories"], game: ["jeu", "jeux"],
  slide: ["slide", "slides"], badge: ["badge", "badges"],
};
const ICONS: Record<ActivityIcon, Icon> = {
  edit: PencilSimpleIcon, create: PlusCircleIcon, delete: TrashIcon, import: UploadSimpleIcon, publish: RocketLaunchIcon,
  site: BrowserIcon, order: ArrowsDownUpIcon, translate: TranslateIcon, toggle: ToggleRightIcon,
};
const dateFmt = new Intl.DateTimeFormat("fr-FR", { timeZone: "Europe/Paris", day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" });

export default async function Publication() {
  const latest = await prisma.contentRelease.findFirst({ orderBy: { version: "desc" } });
  const where = pendingWhere(latest?.publishedAt);

  const [releases, cards, byEntity, pendingCount, pendingLogs] = await Promise.all([
    prisma.contentRelease.findMany({ orderBy: { version: "desc" }, take: 20 }),
    prisma.card.count({ where: { active: true } }),
    prisma.auditLog.groupBy({ by: ["entity"], where, _count: true }),
    prisma.auditLog.count({ where }),
    recentActivity(8, where),
  ]);
  const now = new Date();

  return (
    <>
      <PageHeader
        title="Publication"
        description="L’app ne consomme jamais le contenu en direct : elle télécharge une version figée. Rien de nouveau n’est servi tant qu’une version n’est pas publiée."
      />

      <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,400px),1fr))] items-start gap-4">
        <Card className="flex flex-col gap-4">
          <div className="flex items-center gap-3.5">
            <span className="font-display text-[44px] font-semibold leading-none tracking-[-0.03em]">{latest ? `v${latest.version}` : "—"}</span>
            <span className="flex flex-col gap-0.5 text-[13px] text-neutral-faint">
              <span className="font-semibold text-ink">{latest ? "Version en ligne" : "Aucune version publiée"}</span>
              {nf.format(cards)} cartes actives
            </span>
          </div>

          <section aria-labelledby="recap" className="flex flex-col gap-2.5">
            <h2 id="recap" className="m-0 text-[13px] font-semibold">
              {pendingCount > 0
                ? `${pendingCount} modification${pendingCount > 1 ? "s" : ""} depuis ${latest ? `la v${latest.version}` : "le début"}`
                : "Aucune modification depuis la dernière version"}
            </h2>
            {byEntity.length > 0 && (
              <ul className="m-0 grid list-none grid-cols-[repeat(auto-fill,minmax(100px,1fr))] gap-2.5 p-0">
                {byEntity.map((e) => {
                  const [one, many] = ENTITY_LABELS[e.entity] ?? [e.entity, e.entity];
                  return (
                    <li key={e.entity} className="flex flex-col gap-0.5 rounded-[10px] bg-raised p-3">
                      <span className="text-[22px] font-semibold text-accent-deep">{nf.format(e._count)}</span>
                      <span className="text-xs text-neutral-faint">{e._count > 1 ? many : one}</span>
                    </li>
                  );
                })}
              </ul>
            )}
            {pendingLogs.length > 0 && (
              <ol className="m-0 list-none p-0 text-[13px]">
                {pendingLogs.map((a) => {
                  const I = ICONS[a.icon];
                  return (
                    <li key={a.id} className="flex items-center gap-2.5 border-t border-hairline py-2 first:border-t-0">
                      <I aria-hidden className="shrink-0 text-neutral-faint" />
                      <span className="min-w-0 flex-1 truncate"><span className="font-medium">{a.label}</span>{a.detail && <span className="text-ink-soft"> — {a.detail}</span>}</span>
                      <time dateTime={a.createdAt.toISOString()} className="whitespace-nowrap font-mono text-[11px] text-neutral-faint">{relativeTime(a.createdAt, now)}</time>
                    </li>
                  );
                })}
                {pendingCount > pendingLogs.length && (
                  <li className="border-t border-hairline pt-2 text-xs text-neutral-faint">… et {pendingCount - pendingLogs.length} autre{pendingCount - pendingLogs.length > 1 ? "s" : ""}</li>
                )}
              </ol>
            )}
          </section>

          <PublishButton changes={pendingCount} nextVersion={(latest?.version ?? 0) + 1} />
          <p className="m-0 text-xs text-neutral-faint">
            Import en masse : bouton « Importer » des écrans <Link href="/cartes" className="text-accent-deep underline underline-offset-2 hover:text-ink">Cartes</Link> et <Link href="/jeux" className="text-accent-deep underline underline-offset-2 hover:text-ink">Jeux</Link>.
          </p>
        </Card>

        <Card>
          <h2 className="m-0 mb-2 text-[15px] font-semibold">Historique des versions</h2>
          {releases.length === 0 ? (
            <p className="m-0 text-sm text-neutral-faint">Aucune version publiée pour l’instant.</p>
          ) : (
            <ol className="m-0 list-none p-0">
              {releases.map((r, i) => (
                <li key={r.id} className="grid grid-cols-[56px_minmax(0,1fr)] items-baseline gap-3 border-t border-hairline py-2.5 first:border-t-0">
                  <span className={`font-mono text-[13px] font-semibold ${i === 0 ? "text-accent-deep" : "text-neutral-faint"}`}>v{r.version}</span>
                  <span className="flex min-w-0 flex-col gap-0.5">
                    <span className={`text-[13.5px] ${r.changelog ? "" : "text-neutral-faint"}`}>{r.changelog || "Sans description"}</span>
                    <time dateTime={r.publishedAt.toISOString()} className="font-mono text-[11px] text-neutral-faint">
                      {dateFmt.format(r.publishedAt)}{i === 0 && " · en ligne"}
                    </time>
                  </span>
                </li>
              ))}
            </ol>
          )}
        </Card>
      </div>
    </>
  );
}
