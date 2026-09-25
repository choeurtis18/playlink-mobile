"use client";

import { useEffect, useId, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowRightIcon, MagnifyingGlassIcon } from "@phosphor-icons/react/dist/ssr";
import { Dialog } from "@/components/ui";
import { NAV } from "@/lib/nav";
import { searchContent, type SearchHit } from "@/lib/search";

export const OPEN_SEARCH_EVENT = "bo:open-search";

const DEBOUNCE_MS = 180;
const KIND_LABEL: Record<SearchHit["kind"], string> = { game: "Jeux", category: "Catégories", card: "Cartes" };

type Option = { id: string; group: string; label: string; detail?: string; icon?: string | null; href: string };

const PAGES: Option[] = NAV.flatMap((g) =>
  g.items.filter((i) => !i.soon).map((i) => ({ id: `page-${i.key}`, group: "Écrans", label: i.label, detail: g.label, href: i.href })),
);

const normalize = (s: string) => s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();

/** Palette de recherche (⌘K / Ctrl+K, ou le champ de la barre du haut) :
 * écrans du back-office, puis jeux, catégories et cartes. Flèches pour se
 * déplacer, Entrée pour ouvrir, Échap pour fermer. */
export function CommandPalette() {
  const router = useRouter();
  const titleId = useId();
  const listId = useId();
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [hits, setHits] = useState<SearchHit[]>([]);
  const [loading, setLoading] = useState(false);
  const [active, setActive] = useState(0);
  const request = useRef(0);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setOpen((o) => !o);
      }
    };
    const onOpen = () => setOpen(true);
    window.addEventListener("keydown", onKey);
    window.addEventListener(OPEN_SEARCH_EVENT, onOpen);
    return () => {
      window.removeEventListener("keydown", onKey);
      window.removeEventListener(OPEN_SEARCH_EVENT, onOpen);
    };
  }, []);

  // Recherche serveur, avec délai de frappe. Une réponse arrivée après
  // une frappe plus récente est ignorée.
  useEffect(() => {
    const q = query.trim();
    if (q.length < 2) { setHits([]); setLoading(false); return; }
    const id = ++request.current;
    setLoading(true);
    const t = window.setTimeout(async () => {
      try {
        const r = await searchContent(q);
        if (id === request.current) setHits(r);
      } finally {
        if (id === request.current) setLoading(false);
      }
    }, DEBOUNCE_MS);
    return () => window.clearTimeout(t);
  }, [query]);

  const options = useMemo<Option[]>(() => {
    const q = normalize(query.trim());
    const pages = q ? PAGES.filter((p) => normalize(p.label).includes(q)) : PAGES;
    return [
      ...pages,
      ...hits.map((h) => ({ id: `${h.kind}-${h.id}`, group: KIND_LABEL[h.kind], label: h.label, detail: h.detail, icon: h.icon, href: h.href })),
    ];
  }, [query, hits]);

  useEffect(() => setActive(0), [options]);

  const close = () => { setOpen(false); setQuery(""); setHits([]); };
  const go = (o: Option | undefined) => { if (!o) return; close(); router.push(o.href); };

  const q = query.trim();
  const empty = q.length >= 2 && !loading && options.length === 0;

  return (
    <Dialog open={open} onClose={close} labelledBy={titleId} placement="palette" className="max-w-[600px]">
      <h2 id={titleId} className="sr-only">Recherche</h2>
      <div className="flex items-center gap-2.5 border-b border-hairline px-4">
        <MagnifyingGlassIcon aria-hidden className="text-lg text-neutral-faint" />
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "ArrowDown") { e.preventDefault(); setActive((a) => Math.min(options.length - 1, a + 1)); }
            if (e.key === "ArrowUp") { e.preventDefault(); setActive((a) => Math.max(0, a - 1)); }
            if (e.key === "Enter") { e.preventDefault(); go(options[active]); }
          }}
          role="combobox"
          aria-expanded={options.length > 0}
          aria-controls={listId}
          aria-activedescendant={options[active] ? `${listId}-${options[active].id}` : undefined}
          aria-autocomplete="list"
          aria-label="Rechercher une carte, un jeu, une catégorie ou un écran"
          placeholder="Rechercher une carte, un jeu, un écran…"
          className="min-w-0 flex-1 bg-transparent py-4 text-[15px] text-ink outline-none placeholder:text-neutral-faint focus-visible:outline-none"
        />
        <kbd className="rounded border border-hairline-firm px-1.5 py-0.5 font-mono text-[10px] text-neutral-faint">Échap</kbd>
      </div>

      <ul id={listId} role="listbox" aria-label="Résultats" className="m-0 max-h-[min(420px,60vh)] list-none overflow-y-auto p-2">
        {options.map((o, i) => {
          const header = i === 0 || options[i - 1].group !== o.group;
          return (
            <li key={o.id} role="presentation">
              {header && (
                <p aria-hidden className="m-0 px-2.5 pb-1 pt-2.5 font-mono text-[10px] uppercase tracking-[0.14em] text-neutral-faint">{o.group}</p>
              )}
              <div
                id={`${listId}-${o.id}`}
                role="option"
                aria-selected={i === active}
                onMouseMove={() => setActive(i)}
                onClick={() => go(o)}
                className={`flex cursor-pointer items-center gap-3 rounded-lg px-2.5 py-2 ${i === active ? "bg-raised" : ""}`}
              >
                <span aria-hidden className="flex h-7 w-7 flex-none items-center justify-center rounded-md bg-sunk text-sm">
                  {o.icon ?? <ArrowRightIcon className="text-neutral-faint" />}
                </span>
                <span className="flex min-w-0 flex-1 flex-col">
                  <span className="truncate text-sm text-ink">{o.label}</span>
                  {o.detail && <span className="truncate text-xs text-neutral-faint">{o.detail}</span>}
                </span>
              </div>
            </li>
          );
        })}
      </ul>

      <p aria-live="polite" className="m-0 border-t border-hairline bg-sunk px-4 py-2.5 text-xs text-neutral-faint">
        {loading ? "Recherche…" : empty ? `Aucun résultat pour « ${q} ».` : q.length === 1 ? "Encore une lettre…" : "↑ ↓ pour choisir · Entrée pour ouvrir"}
      </p>
    </Dialog>
  );
}
