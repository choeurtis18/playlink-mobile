"use client";

import { usePathname } from "next/navigation";
import { ArrowSquareOutIcon, CaretRightIcon, MagnifyingGlassIcon } from "@phosphor-icons/react/dist/ssr";
import { activeItem } from "@/lib/nav";
import { OPEN_SEARCH_EVENT } from "./CommandPalette";

/** Barre du haut : fil d'Ariane (groupe › écran), recherche, lien vers
 * le site public. Collée en haut, fond flouté. */
export function Topbar({ siteUrl }: { siteUrl: string }) {
  const pathname = usePathname();
  const active = activeItem(pathname);
  const openSearch = () => window.dispatchEvent(new Event(OPEN_SEARCH_EVENT));

  return (
    <header className="sticky top-0 z-20 flex items-center gap-4 border-b border-hairline bg-ground/80 px-4 py-3 backdrop-blur-[14px] min-[900px]:px-8">
      {active && (
        <nav aria-label="Fil d’Ariane" className="min-w-0">
          <ol className="m-0 flex list-none items-center gap-2 p-0 text-[13px] text-neutral-faint">
            <li className="hidden whitespace-nowrap sm:block">{active.group.label}</li>
            <li aria-hidden className="hidden sm:block"><CaretRightIcon className="text-xs" /></li>
            <li aria-current="page" className="truncate font-medium text-ink">{active.item.label}</li>
          </ol>
        </nav>
      )}
      <div className="ml-auto flex items-center gap-2">
        <button
          type="button"
          onClick={openSearch}
          aria-label="Rechercher une carte, un jeu, une catégorie (⌘K)"
          aria-keyshortcuts="Meta+K Control+K"
          className="flex items-center gap-2 rounded-lg border border-hairline bg-surface px-2.5 py-[7px] text-[13px] text-neutral-faint transition-colors hover:border-hairline-firm hover:text-ink min-[900px]:w-[260px]"
        >
          <MagnifyingGlassIcon aria-hidden className="text-[15px]" />
          <span className="hidden flex-1 text-left min-[900px]:block">Rechercher une carte, un jeu…</span>
          <kbd className="hidden rounded border border-hairline-firm px-[5px] py-0.5 font-mono text-[10px] min-[900px]:block">⌘K</kbd>
        </button>
        <a
          href={siteUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-1.5 whitespace-nowrap rounded-lg border border-hairline px-3 py-[7px] text-[13px] font-medium text-ink-soft transition-colors hover:border-hairline-firm hover:text-ink"
        >
          <ArrowSquareOutIcon aria-hidden className="text-[15px]" />
          <span>Voir le site</span>
          <span className="sr-only">(nouvel onglet)</span>
        </a>
      </div>
    </header>
  );
}
