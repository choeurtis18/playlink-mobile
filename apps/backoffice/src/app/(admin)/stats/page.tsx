import Link from "next/link";
import type { Icon } from "@phosphor-icons/react";
import {
  ChartLineUpIcon, EnvelopeSimpleIcon, EyeIcon, PercentIcon, PlayCircleIcon, UsersIcon,
} from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { Card, EmptyState, PageHeader } from "@/components/ui";
import { breakdown } from "@/lib/landing-stats-core";
import { landingRows, lastDays, lastLandingSync, parisDay } from "@/lib/landing-stats";
import { posthogConfig } from "@/lib/posthog";
import { relativeTime } from "@/lib/activity";
import { TrendCharts } from "./TrendCharts";
import { SyncButton } from "./SyncButton";

export const dynamic = "force-dynamic";

const PERIODS = [7, 30, 90] as const;
const nf = new Intl.NumberFormat("fr-FR");
const pctFmt = new Intl.NumberFormat("fr-FR", { style: "percent", maximumFractionDigits: 1 });
const regionName = new Intl.DisplayNames(["fr"], { type: "region" });
const SOURCE_LABELS: Record<string, string> = {
  organic: "Recherche", social: "Réseaux sociaux", direct: "Direct", email: "E-mail", referral: "Autres sites",
};
const LOCALE_LABELS: Record<string, string> = { fr: "Français", en: "Anglais" };

const flag = (cc: string) => String.fromCodePoint(...[...cc.toUpperCase()].map((c) => 0x1f1a5 + c.charCodeAt(0)));

export default async function Stats({ searchParams }: { searchParams: Promise<{ p?: string }> }) {
  const sp = await searchParams;
  const period = PERIODS.find((p) => String(p) === sp.p) ?? 30;
  const all = lastDays(period * 2);
  const current = all.slice(period);
  const previous = all.slice(0, period);

  const [rows, signups, games, categories, lastSync] = await Promise.all([
    landingRows(all[0]),
    prisma.landingPreRegistration.findMany({
      where: { createdAt: { gte: new Date(`${all[0]}T00:00:00Z`) } },
      select: { createdAt: true },
    }),
    prisma.game.findMany({ select: { slug: true, name: true, icon: true, colorMain: true, colorSecondary: true } }),
    prisma.category.findMany({ select: { slug: true, name: true, game: { select: { slug: true, name: true } } } }),
    lastLandingSync(),
  ]);

  const dayOf = (d: Date) => d.toISOString().slice(0, 10);
  const inCurrent = new Set(current);
  const cur = rows.filter((r) => inCurrent.has(dayOf(r.day)));
  const prev = rows.filter((r) => !inCurrent.has(dayOf(r.day)));
  const sum = (list: typeof rows, metric: string) => list.filter((r) => r.metric === metric).reduce((s, r) => s + r.value, 0);
  const perDay = (metric: string) => current.map((d) => rows.filter((r) => r.metric === metric && dayOf(r.day) === d).reduce((s, r) => s + r.value, 0));

  const signupDays = signups.map((s) => parisDay(s.createdAt));
  const signupsCur = signupDays.filter((d) => inCurrent.has(d)).length;
  const signupsPrev = signupDays.filter((d) => previous.includes(d)).length;
  const signupsPerDay = current.map((d) => signupDays.filter((x) => x === d).length);

  const kpi = (metric: string) => ({ cur: sum(cur, `landing.${metric}`), prev: sum(prev, `landing.${metric}`) });
  const views = kpi("views"), visitors = kpi("visitors"), demos = kpi("demo_started");
  const conv = { cur: visitors.cur ? signupsCur / visitors.cur : 0, prev: visitors.prev ? signupsPrev / visitors.prev : 0 };

  const kpis: { label: string; icon: Icon; value: string; delta: string | null; up: boolean; hint?: string }[] = [
    { label: "Vues", icon: EyeIcon, value: nf.format(views.cur), ...delta(views.cur, views.prev) },
    { label: "Visiteurs", icon: UsersIcon, value: nf.format(visitors.cur), ...delta(visitors.cur, visitors.prev), hint: "Somme des visiteurs uniques de chaque jour" },
    { label: "Démos lancées", icon: PlayCircleIcon, value: nf.format(demos.cur), ...delta(demos.cur, demos.prev) },
    { label: "Pré-inscriptions", icon: EnvelopeSimpleIcon, value: nf.format(signupsCur), ...delta(signupsCur, signupsPrev) },
    { label: "Conversion", icon: PercentIcon, value: pctFmt.format(conv.cur), ...pointDelta(conv.cur, conv.prev), hint: "Pré-inscriptions ÷ visiteurs" },
  ];

  // Démo : jeux les plus testés, part des lancements et abandon avant la fin du deck.
  const started = breakdown(cur, "game_started");
  const completed = new Map(breakdown(cur, "game_completed").map((r) => [r.key, r.value]));
  const totalStarted = started.reduce((s, r) => s + r.value, 0);
  const gameBySlug = new Map(games.map((g) => [g.slug, g]));
  const demoRows = started.map((r) => {
    const g = gameBySlug.get(r.key);
    const done = Math.min(r.value, completed.get(r.key) ?? 0);
    return { key: r.key, label: g?.name ?? r.key, icon: g?.icon ?? null, value: r.value, share: totalStarted ? r.value / totalStarted : 0, abandon: r.value ? 1 - done / r.value : 0 };
  });

  const catName = new Map(categories.map((c) => [`${c.game.slug}/${c.slug}`, `${c.name} · ${c.game.name}`]));
  const lists = [
    { title: "Catégories favorites", rows: breakdown(cur, "category").slice(0, 6).map((r) => ({ label: catName.get(r.key) ?? r.key, value: r.value })) },
    { title: "Sources de trafic", rows: breakdown(cur, "source").map((r) => ({ label: SOURCE_LABELS[r.key] ?? r.key, value: r.value })) },
    { title: "Sites d’origine", rows: breakdown(cur, "referrer").slice(0, 6).map((r) => ({ label: r.key, value: r.value })) },
    { title: "Pays", rows: breakdown(cur, "country").slice(0, 6).map((r) => ({ label: `${flag(r.key)} ${regionName.of(r.key) ?? r.key}`, value: r.value })) },
    { title: "Langues", rows: breakdown(cur, "locale").map((r) => ({ label: LOCALE_LABELS[r.key] ?? r.key, value: r.value })) },
  ];

  const configured = !!posthogConfig();
  const empty = rows.length === 0;

  return (
    <>
      <PageHeader
        title="Stats landing"
        description="Événements PostHog de la landing — uniquement les visiteurs ayant accepté la mesure d’audience. Mis à jour chaque nuit."
        actions={
          <>
            <span className="text-xs text-neutral-faint">{lastSync ? `Synchronisé ${relativeTime(lastSync)}` : "Jamais synchronisé"}</span>
            {configured && !empty && <SyncButton days={Math.min(period, 30)} />}
            <nav aria-label="Période" className="inline-flex gap-0.5 rounded-[9px] border border-hairline bg-surface p-[3px]">
              {PERIODS.map((p) => (
                <Link key={p} href={`/stats?p=${p}`} aria-current={p === period ? "page" : undefined}
                  className={`rounded-md px-3 py-1 text-[13px] font-medium transition-colors ${p === period ? "bg-hairline text-ink" : "text-neutral-faint hover:text-ink"}`}>
                  {p} j
                </Link>
              ))}
            </nav>
          </>
        }
      />

      {empty ? (
        configured ? (
          <EmptyState icon={<ChartLineUpIcon />} title="Aucune statistique pour l’instant"
            action={<SyncButton days={90} label="Récupérer les 90 derniers jours" variant="primary" />}>
            La synchro automatique tourne chaque nuit. Lance-la maintenant pour importer l’historique déjà présent dans PostHog.
          </EmptyState>
        ) : (
          <EmptyState icon={<ChartLineUpIcon />} title="PostHog n’est pas configuré">
            Ajoute POSTHOG_PERSONAL_API_KEY (accès « Query : Read ») et POSTHOG_PROJECT_ID au projet Vercel du back-office, puis redéploie.
          </EmptyState>
        )
      ) : (
        <>
          <ul className="m-0 grid list-none grid-cols-[repeat(auto-fit,minmax(170px,1fr))] gap-3 p-0">
            {kpis.map((k) => (
              <li key={k.label} className="flex flex-col gap-1.5 rounded-[14px] border border-hairline bg-surface p-4" title={k.hint}>
                <span className="flex items-center gap-1.5 text-xs text-neutral-faint"><k.icon aria-hidden className="text-sm" />{k.label}</span>
                <span className="text-[26px] font-semibold tracking-[-0.02em]">{k.value}</span>
                <span className={`text-xs ${k.delta === null ? "text-neutral-faint" : k.up ? "text-success" : "text-warning"}`}>
                  {k.delta ?? "—"} <span className="text-neutral-faint">vs {period} j précédents</span>
                </span>
              </li>
            ))}
          </ul>

          <Card className="mt-4">
            <h2 className="m-0 mb-3.5 text-[15px] font-semibold">Vues et pré-inscriptions</h2>
            <TrendCharts days={current} views={perDay("landing.views")} signups={signupsPerDay} />
          </Card>

          <div className="mt-4 grid grid-cols-[repeat(auto-fit,minmax(min(100%,360px),1fr))] items-start gap-4">
            <Card className="flex flex-col gap-3.5">
              <h2 className="m-0 text-[15px] font-semibold">Démo — jeux les plus testés</h2>
              {demoRows.length === 0 ? <p className="m-0 text-sm text-neutral-faint">Aucune démo lancée sur la période.</p> : (
                <table className="w-full border-collapse text-[13px]">
                  <thead className="font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint">
                    <tr>
                      <th className="pb-1 text-left font-medium">Jeu · démos</th>
                      <th className="pb-1 text-right font-medium"><span aria-hidden>Part</span><span className="sr-only">Part des démos lancées</span></th>
                      <th className="pb-1 text-right font-medium" title="Démos lancées mais pas terminées">Abandon</th>
                    </tr>
                  </thead>
                  <tbody>
                    {demoRows.map((d) => (
                      <tr key={d.key}>
                        <td className="py-1.5 pr-2.5">
                          <div className="flex items-center gap-2.5">
                            <span aria-hidden className="w-5">{d.icon}</span>
                            <div className="flex min-w-0 flex-1 flex-col gap-1">
                              <span className="truncate">{d.label} <span className="text-neutral-faint">· {nf.format(d.value)}</span></span>
                              <span aria-hidden className="h-1.5 overflow-hidden rounded-sm bg-raised"><span className="block h-full rounded-sm bg-accent" style={{ width: `${d.share * 100}%` }} /></span>
                            </div>
                          </div>
                        </td>
                        <td className="w-12 py-1.5 text-right font-semibold tabular-nums">{pctFmt.format(d.share)}</td>
                        <td className={`w-20 py-1.5 text-right tabular-nums ${d.abandon > 0.5 ? "text-warning" : "text-neutral-faint"}`}>{pctFmt.format(d.abandon)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
              <p className="m-0 text-xs text-neutral-faint">Abandon : démos lancées mais pas terminées (le deck n’a pas été joué jusqu’au bout).</p>
            </Card>

            {lists.map((l) => <BarList key={l.title} title={l.title} rows={l.rows} />)}
          </div>
        </>
      )}
    </>
  );
}

/** Classement : libellé, barre (une seule teinte = magnitude) et valeur. */
function BarList({ title, rows }: { title: string; rows: { label: string; value: number }[] }) {
  const max = Math.max(1, ...rows.map((r) => r.value));
  const total = rows.reduce((s, r) => s + r.value, 0);
  return (
    <Card className="flex flex-col gap-3">
      <h2 className="m-0 text-[15px] font-semibold">{title}</h2>
      {rows.length === 0 ? <p className="m-0 text-sm text-neutral-faint">Pas encore de données.</p> : (
        <ul className="m-0 flex list-none flex-col gap-2 p-0 text-[13px]">
          {rows.map((r) => (
            <li key={r.label} className="grid grid-cols-[minmax(0,1fr)_auto] items-center gap-x-3 gap-y-1">
              <span className="truncate">{r.label}</span>
              <span className="text-right tabular-nums"><strong className="font-semibold">{nf.format(r.value)}</strong> <span className="text-xs text-neutral-faint">{pctFmt.format(total ? r.value / total : 0)}</span></span>
              <span aria-hidden className="col-span-2 h-1.5 overflow-hidden rounded-sm bg-raised"><span className="block h-full rounded-sm bg-accent/80" style={{ width: `${(r.value / max) * 100}%` }} /></span>
            </li>
          ))}
        </ul>
      )}
    </Card>
  );
}

/** Variation relative ; « nouveau » si la période précédente était vide. */
function delta(cur: number, prev: number) {
  if (!prev) return { delta: cur ? "nouveau" : null, up: true };
  const p = Math.round(((cur - prev) / prev) * 100);
  return { delta: `${p > 0 ? "+" : p < 0 ? "−" : "±"}${Math.abs(p)} %`, up: p >= 0 };
}

/** Variation d'un taux, en points. */
function pointDelta(cur: number, prev: number) {
  if (!prev && !cur) return { delta: null, up: true };
  const pts = Math.round((cur - prev) * 1000) / 10;
  return { delta: `${pts > 0 ? "+" : pts < 0 ? "−" : "±"}${nf.format(Math.abs(pts))} pt`, up: pts >= 0 };
}
