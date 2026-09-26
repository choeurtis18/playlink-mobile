"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { UserButton } from "@clerk/nextjs";
import type { Icon } from "@phosphor-icons/react";
import {
  BookOpenIcon, BrowserIcon, CardsIcon, ChartLineUpIcon, EnvelopeSimpleIcon, FoldersIcon,
  GameControllerIcon, MedalIcon, RocketLaunchIcon, SquaresFourIcon, TranslateIcon,
} from "@phosphor-icons/react/dist/ssr";
import { NAV, activeItem, type NavKey } from "@/lib/nav";
import type { ShellCounts } from "@/lib/shell";
import { Logo } from "./Logo";

const ICONS: Record<NavKey, Icon> = {
  home: SquaresFourIcon,
  jeux: GameControllerIcon,
  categories: FoldersIcon,
  cartes: CardsIcon,
  traductions: TranslateIcon,
  regles: BookOpenIcon,
  badges: MedalIcon,
  site: BrowserIcon,
  stats: ChartLineUpIcon,
  inscriptions: EnvelopeSimpleIcon,
  publication: RocketLaunchIcon,
};

const nf = new Intl.NumberFormat("fr-FR");

type BadgeTone = "count" | "todo" | "new";
const BADGE_TONE: Record<BadgeTone, string> = {
  count: "bg-raised text-neutral-faint",
  todo: "bg-warning/12 text-warning",
  new: "bg-accent/15 text-accent-deep",
};

/** Compteur affiché à droite d'une entrée :
 * - `count` (gris) : un total, toujours affiché ;
 * - `todo` (orange) : du travail à faire, disparaît quand c'est fait ;
 * - `new` (rose) : nouveautés, disparaissent une fois vues ou publiées.
 * `label` : lu par les lecteurs d'écran à la place du nombre seul. */
function badgeFor(key: NavKey, c: ShellCounts): { text: string; tone: BadgeTone; label: string } | null {
  const n = (v: number, one: string, many: string) => `${nf.format(v)} ${v > 1 ? many : one}`;
  switch (key) {
    case "jeux": return { text: nf.format(c.games), tone: "count", label: n(c.games, "jeu", "jeux") };
    case "categories": return { text: nf.format(c.categories), tone: "count", label: n(c.categories, "catégorie", "catégories") };
    case "cartes": return { text: nf.format(c.cards), tone: "count", label: n(c.cards, "carte active", "cartes actives") };
    case "regles": return { text: nf.format(c.slides), tone: "count", label: n(c.slides, "slide", "slides") };
    case "badges": return { text: nf.format(c.badges), tone: "count", label: n(c.badges, "badge", "badges") };
    case "traductions": return c.untranslated > 0 ? { text: nf.format(c.untranslated), tone: "todo", label: n(c.untranslated, "élément sans anglais", "éléments sans anglais") } : null;
    case "site": return c.siteEnGaps > 0 ? { text: nf.format(c.siteEnGaps), tone: "todo", label: n(c.siteEnGaps, "texte anglais à revoir", "textes anglais à revoir") } : null;
    case "inscriptions": return c.newSignups > 0 ? { text: `+${nf.format(c.newSignups)}`, tone: "new", label: n(c.newSignups, "nouvelle", "nouvelles") } : null;
    case "publication": return c.pending > 0 ? { text: nf.format(c.pending), tone: "new", label: n(c.pending, "modification à publier", "modifications à publier") } : null;
    default: return null;
  }
}

/** Sidebar : 4 groupes, compteurs, encart « à publier », éditeur connecté.
 * Sous 900 px, elle devient un bandeau : logo et compte en haut, puis les
 * entrées sur une ligne qui défile horizontalement. */
export function Sidebar({ counts, editorLabel }: { counts: ShellCounts; editorLabel: string }) {
  const pathname = usePathname();
  const current = activeItem(pathname)?.item.key;

  return (
    <aside className="flex w-full shrink-0 flex-col border-b border-hairline bg-sunk px-3.5 pb-3 pt-[18px] min-[900px]:sticky min-[900px]:top-0 min-[900px]:h-screen min-[900px]:w-[248px] min-[900px]:overflow-y-auto min-[900px]:border-b-0 min-[900px]:border-r min-[900px]:pb-[18px]">
      <div className="flex items-center justify-between px-2 pb-[18px] pt-1 min-[900px]:pb-[18px]">
        <Link href="/" aria-label="Playlink back-office — tableau de bord" className="rounded-md">
          <Logo />
        </Link>
        <div className="min-[900px]:hidden"><UserButton /></div>
      </div>

      <nav
        aria-label="Back-office"
        className="-mx-3.5 flex gap-0.5 overflow-x-auto px-3.5 pb-1 [scrollbar-width:none] min-[900px]:mx-0 min-[900px]:flex-col min-[900px]:overflow-visible min-[900px]:px-0 min-[900px]:pb-0"
      >
        {NAV.map((group) => (
          <div key={group.label} role="group" aria-label={group.label} className="contents min-[900px]:flex min-[900px]:flex-col min-[900px]:gap-0.5">
            <p aria-hidden className="m-0 hidden whitespace-nowrap px-2.5 pb-1.5 pt-4 font-mono text-[10px] uppercase tracking-[0.14em] text-neutral-faint min-[900px]:block">
              {group.label}
            </p>
            {group.items.map((item) => {
              const Icon = ICONS[item.key];
              const on = item.key === current;
              // Pas de compteur sur un écran à venir : il inviterait à cliquer.
              const badge = item.soon ? null : badgeFor(item.key, counts);
              const body = (
                <>
                  <span aria-hidden className={`absolute -left-3.5 bottom-2 top-2 hidden w-[3px] rounded-r-[3px] bg-accent transition-opacity min-[900px]:block ${on ? "opacity-100" : "opacity-0"}`} />
                  <Icon aria-hidden weight={on ? "fill" : "regular"} className={`shrink-0 text-lg ${on ? "text-accent-deep" : "text-neutral-faint"}`} />
                  <span className="flex-1">{item.label}</span>
                  {item.soon && <span className="font-mono text-[9.5px] uppercase tracking-[0.1em] text-neutral-faint">bientôt</span>}
                  {badge && (
                    <span className={`rounded-full px-1.5 py-0.5 font-mono text-[10px] font-semibold ${BADGE_TONE[badge.tone]}`}>
                      <span aria-hidden>{badge.text}</span>
                      <span className="sr-only">{badge.label}</span>
                    </span>
                  )}
                </>
              );
              const cls = "relative flex shrink-0 items-center gap-2.5 whitespace-nowrap rounded-lg px-2.5 py-2 text-left text-sm font-medium transition-colors";
              return item.soon ? (
                <span key={item.key} aria-disabled="true" title="Écran à venir" className={`${cls} cursor-default text-ink-soft opacity-50`}>
                  {body}
                </span>
              ) : (
                <Link
                  key={item.key}
                  href={item.href}
                  aria-current={on ? "page" : undefined}
                  className={`${cls} ${on ? "bg-raised text-ink" : "text-ink-soft hover:bg-surface hover:text-ink"}`}
                >
                  {body}
                </Link>
              );
            })}
          </div>
        ))}
      </nav>

      <div className="mt-auto hidden flex-col gap-3 pt-5 min-[900px]:flex">
        <PublishCard counts={counts} />
        <div className="flex items-center gap-2.5 border-t border-hairline px-2 pb-0.5 pt-2.5">
          <UserButton />
          <span className="flex min-w-0 flex-1 flex-col">
            <span className="truncate text-[13px] font-semibold">{editorLabel}</span>
            <span className="text-[11px] text-neutral-faint">Connecté via Clerk</span>
          </span>
        </div>
      </div>
    </aside>
  );
}

/** Encart « N modifications à publier » : modifications du contenu de
 * l'app postérieures à la dernière version publiée (l'app ne les voit
 * qu'après publication). */
function PublishCard({ counts }: { counts: ShellCounts }) {
  const { pending, version } = counts;
  const title = pending > 0
    ? `${pending} modification${pending > 1 ? "s" : ""} à publier`
    : "Tout est publié";
  const text = pending > 0
    ? version ? `Depuis la v${version} · l’app ne les voit pas encore.` : "Aucune version publiée pour l’instant."
    : version ? `v${version} en ligne dans l’app.` : "Aucune version publiée pour l’instant.";
  return (
    <Link
      href="/publication"
      className={`flex flex-col gap-1.5 rounded-xl border p-3 text-ink transition-colors hover:border-accent hover:text-ink ${
        pending > 0 ? "border-accent/40 bg-accent/[0.06]" : "border-hairline bg-surface"
      }`}
    >
      <span className="flex items-center gap-2 text-[13px] font-semibold">
        <span
          aria-hidden
          className={`h-[7px] w-[7px] rounded-full ${pending > 0 ? "bg-accent motion-safe:animate-[bo-pulse_2s_infinite]" : "bg-success"}`}
        />
        {title}
      </span>
      <span className="text-xs leading-[1.45] text-neutral-faint">{text}</span>
    </Link>
  );
}
