import type { Icon } from "@phosphor-icons/react";
import {
  ArrowsDownUpIcon, BookOpenIcon, BrowserIcon, CardsIcon, CaretRightIcon, CheckCircleIcon, EnvelopeSimpleIcon,
  FoldersIcon, GameControllerIcon, MedalIcon, PencilSimpleIcon, PlusCircleIcon, RocketLaunchIcon,
  ToggleRightIcon, TranslateIcon, TrashIcon, UploadSimpleIcon, WarningIcon,
} from "@phosphor-icons/react/dist/ssr";
import { landingEnGaps } from "@playlink/content-schema/landing-keys.ts";
import { prisma } from "@/lib/prisma";
import { getShellCounts } from "@/lib/shell";
import { parisDay, recentActivity, relativeTime, type ActivityIcon } from "@/lib/activity";
import { Card, PageHeader, Stat } from "@/components/ui";

export const dynamic = "force-dynamic";

const DAY = 24 * 60 * 60 * 1000;
const SPARK_DAYS = 14;
const nf = new Intl.NumberFormat("fr-FR");

export default async function Home() {
  const now = new Date();
  const [shell, categories, slides, badges, totalCards, untranslated, landingRows, signups, activity] = await Promise.all([
    getShellCounts(),
    prisma.category.count(),
    prisma.gameRuleSlide.count(),
    prisma.badge.count(),
    prisma.card.count(),
    prisma.card.count({ where: { translations: { none: { locale: "en" } } } }),
    prisma.landingText.findMany({ select: { locale: true, key: true, value: true } }),
    // Volume faible (pré-inscriptions de 14 jours) : regroupées ici par
    // jour. Les stats détaillées liront des agrégats (écran Stats).
    prisma.landingPreRegistration.findMany({
      where: { createdAt: { gte: new Date(now.getTime() - SPARK_DAYS * DAY) } },
      select: { createdAt: true },
    }),
    recentActivity(6),
  ]);

  const stats: { label: string; value: string; icon: Icon; href: string }[] = [
    { label: "Jeux", value: nf.format(shell.games), icon: GameControllerIcon, href: "/jeux" },
    { label: "Catégories", value: nf.format(categories), icon: FoldersIcon, href: "/categories" },
    { label: "Cartes actives", value: nf.format(shell.cards), icon: CardsIcon, href: "/cartes" },
    { label: "Slides de règles", value: nf.format(slides), icon: BookOpenIcon, href: "/regles" },
    { label: "Badges", value: nf.format(badges), icon: MedalIcon, href: "/badges" },
    { label: "Version publiée", value: shell.version ? `v${shell.version}` : "—", icon: RocketLaunchIcon, href: "/publication" },
  ];

  // Pré-inscriptions : 7 derniers jours contre les 7 précédents, et une
  // courbe jour par jour (heure de Paris) sur 14 jours.
  const days = Array.from({ length: SPARK_DAYS }, (_, i) => parisDay(new Date(now.getTime() - (SPARK_DAYS - 1 - i) * DAY)));
  const perDay = days.map((d) => signups.filter((s) => parisDay(s.createdAt) === d).length);
  const last7 = perDay.slice(7).reduce((a, b) => a + b, 0);
  const prev7 = perDay.slice(0, 7).reduce((a, b) => a + b, 0);

  const gaps = landingEnGaps(landingRows);
  const coverage = totalCards ? Math.round(((totalCards - untranslated) / totalCards) * 100) : 100;

  const todos: Todo[] = [
    untranslated > 0
      ? { icon: TranslateIcon, tone: "blue", title: `${nf.format(untranslated)} carte${untranslated > 1 ? "s" : ""} sans traduction EN`, sub: `Couverture ${coverage} %`, href: "/traductions" }
      : { icon: CheckCircleIcon, tone: "success", title: "Toutes les cartes sont traduites", sub: "Couverture 100 %", href: "/traductions" },
    shell.pending > 0
      ? { icon: RocketLaunchIcon, tone: "accent", title: `${shell.pending} modification${shell.pending > 1 ? "s" : ""} non publiée${shell.pending > 1 ? "s" : ""}`, sub: shell.version ? `Version en ligne : v${shell.version}` : "Aucune version publiée", href: "/publication" }
      : { icon: CheckCircleIcon, tone: "success", title: "Rien à publier", sub: shell.version ? `v${shell.version} en ligne dans l’app` : "Aucune version publiée", href: "/publication" },
    gaps.length > 0
      ? { icon: WarningIcon, tone: "warning", title: `${gaps.length} texte${gaps.length > 1 ? "s" : ""} EN à mettre à jour sur le site`, sub: "Modifiés en FR, l’anglais affiche encore l’ancien texte", href: `/site?sec=${gaps[0].sectionId}` }
      : { icon: CheckCircleIcon, tone: "success", title: "Site traduit", sub: "Les textes EN suivent le FR", href: "/site" },
    {
      icon: EnvelopeSimpleIcon, tone: "success",
      title: shell.newSignups > 0 ? `${shell.newSignups} nouvelle${shell.newSignups > 1 ? "s" : ""} pré-inscription${shell.newSignups > 1 ? "s" : ""}` : "Aucune nouvelle pré-inscription",
      sub: "Dernières 24 h",
      href: null,
    },
  ];

  return (
    <>
      <PageHeader title="Tableau de bord" description="Contenu de l’app, landing et diffusion — en un coup d’œil." />

      <div className="grid grid-cols-[repeat(auto-fit,minmax(160px,1fr))] gap-3">
        {stats.map((s) => (
          <Stat key={s.label} icon={<s.icon />} value={s.value} label={s.label} href={s.href} />
        ))}
      </div>

      <div className="mt-4 grid grid-cols-[repeat(auto-fit,minmax(min(100%,420px),1fr))] gap-4">
        <Card className="flex flex-col gap-4">
          <h2 className="m-0 flex items-center gap-2 text-[15px] font-semibold">
            <span aria-hidden className="h-[7px] w-[7px] rounded-full bg-success motion-safe:animate-[bo-pulse_2s_infinite]" />
            Landing — 7 derniers jours
          </h2>
          <dl className="m-0 grid grid-cols-[repeat(auto-fit,minmax(110px,1fr))] gap-3">
            <Kpi label="Pré-inscriptions" value={nf.format(last7)} delta={delta(last7, prev7)} />
            <Kpi label="Dernières 24 h" value={nf.format(shell.newSignups)} />
            <Kpi label="Sur 14 jours" value={nf.format(last7 + prev7)} />
          </dl>
          <Sparkline values={perDay} label={`Pré-inscriptions par jour sur ${SPARK_DAYS} jours : ${perDay.join(", ")}`} />
          <p className="m-0 text-xs text-neutral-faint">
            Vues, démos jouées et taux de conversion arriveront avec l’écran Stats.
          </p>
        </Card>

        <Card className="flex flex-col gap-1.5">
          <h2 className="m-0 mb-1.5 text-[15px] font-semibold">À traiter</h2>
          <ul className="m-0 flex list-none flex-col p-0">
            {todos.map((t) => <TodoRow key={t.title} {...t} />)}
          </ul>
        </Card>
      </div>

      <Card className="mt-4">
        <h2 className="m-0 mb-2.5 text-[15px] font-semibold">Activité récente</h2>
        {activity.length === 0 ? (
          <p className="m-0 text-sm text-neutral-faint">Aucune modification enregistrée pour l’instant.</p>
        ) : (
          <ol className="m-0 list-none p-0">
            {activity.map((a, i) => {
              const IconCmp = ACTIVITY_ICONS[a.icon];
              return (
                <li key={a.id} className={`grid grid-cols-[28px_minmax(0,1fr)] items-center gap-x-2.5 gap-y-0.5 py-[9px] sm:grid-cols-[28px_minmax(0,1fr)_auto] ${i ? "border-t border-hairline" : ""}`}>
                  <IconCmp aria-hidden className="text-base text-neutral-faint" />
                  <span className="min-w-0 text-[13px]">
                    <span className="font-medium text-ink">{a.label}</span>
                    {a.detail && <span className="text-ink-soft"> — {a.detail}</span>}
                    <span className="ml-2 font-mono text-[11px] text-accent-deep">{a.code}</span>
                    {a.editor && <span className="text-neutral-faint"> · {a.editor}</span>}
                  </span>
                  <time dateTime={a.createdAt.toISOString()} className="col-start-2 whitespace-nowrap font-mono text-[11px] text-neutral-faint sm:col-start-auto">
                    {relativeTime(a.createdAt, now)}
                  </time>
                </li>
              );
            })}
          </ol>
        )}
      </Card>

      <p className="mt-5 text-[13px] text-neutral-faint">
        Les statistiques d’usage de l’app (DAU, parties, rétention) arriveront en phase 5, alimentées par le cron horaire d’agrégation.
      </p>
    </>
  );
}

const ACTIVITY_ICONS: Record<ActivityIcon, Icon> = {
  edit: PencilSimpleIcon,
  create: PlusCircleIcon,
  delete: TrashIcon,
  import: UploadSimpleIcon,
  publish: RocketLaunchIcon,
  site: BrowserIcon,
  order: ArrowsDownUpIcon,
  translate: TranslateIcon,
  toggle: ToggleRightIcon,
};

/** Variation en %, ou « nouveau » quand la période précédente est vide. */
function delta(current: number, previous: number): { text: string; up: boolean } | null {
  if (previous === 0) return current > 0 ? { text: "nouveau", up: true } : null;
  const pct = Math.round(((current - previous) / previous) * 100);
  return { text: `${pct > 0 ? "+" : pct < 0 ? "−" : "±"}${Math.abs(pct)} %`, up: pct >= 0 };
}

function Kpi({ label, value, delta }: { label: string; value: string; delta?: { text: string; up: boolean } | null }) {
  return (
    <div className="flex flex-col gap-0.5">
      <dt className="text-xs text-neutral-faint">{label}</dt>
      <dd className="m-0 text-xl font-semibold">{value}</dd>
      {delta && (
        <dd className={`m-0 text-xs ${delta.up ? "text-success" : "text-warning"}`}>
          {delta.text} <span className="sr-only">par rapport aux 7 jours précédents</span>
        </dd>
      )}
    </div>
  );
}

/** Courbe compacte (aire + ligne), mise à l'échelle sur le maximum. */
function Sparkline({ values, label }: { values: number[]; label: string }) {
  const W = 600, H = 80, PAD = 4;
  const max = Math.max(1, ...values);
  const x = (i: number) => (values.length > 1 ? (i / (values.length - 1)) * W : 0);
  const y = (v: number) => H - PAD - (v / max) * (H - 2 * PAD);
  const line = values.map((v, i) => `${i ? "L" : "M"}${x(i).toFixed(1)},${y(v).toFixed(1)}`).join(" ");
  return (
    <svg viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" role="img" aria-label={label} className="block h-20 w-full">
      <path d={`${line} L${W},${H} L0,${H} Z`} fill="rgb(242 58 107 / 0.12)" />
      <path d={line} fill="none" stroke="#f23a6b" strokeWidth={2} vectorEffect="non-scaling-stroke" />
    </svg>
  );
}

type Todo = {
  icon: Icon;
  tone: "blue" | "accent" | "warning" | "success";
  title: string;
  sub: string;
  /** Écran concerné ; null tant qu'il n'existe pas encore. */
  href: string | null;
};

const TONES: Record<Todo["tone"], string> = {
  blue: "bg-blue/15 text-blue",
  accent: "bg-accent/15 text-accent-deep",
  warning: "bg-warning/15 text-warning",
  success: "bg-success/15 text-success",
};

function TodoRow({ icon: IconCmp, tone, title, sub, href }: Todo) {
  const body = (
    <>
      <span aria-hidden className={`flex h-[30px] w-[30px] flex-none items-center justify-center rounded-lg ${TONES[tone]}`}>
        <IconCmp className="text-base" />
      </span>
      <span className="flex min-w-0 flex-1 flex-col gap-px">
        <span className="text-sm font-medium text-ink">{title}</span>
        <span className="text-xs text-neutral-faint">{sub}</span>
      </span>
      {href && <CaretRightIcon aria-hidden className="text-neutral-faint" />}
    </>
  );
  const cls = "-mx-2.5 flex items-center gap-3 rounded-[10px] p-2.5";
  return (
    <li>
      {href ? (
        <a href={href} className={`${cls} transition-colors hover:bg-raised`}>{body}</a>
      ) : (
        <div className={cls}>{body}</div>
      )}
    </li>
  );
}
