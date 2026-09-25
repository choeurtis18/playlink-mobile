"use client";

import { useEffect, useRef, useTransition } from "react";
import { usePathname, useRouter } from "next/navigation";

type Params = Record<string, string | undefined>;

const SEARCH_DELAY_MS = 300;

/** Filtres de liste appliqués en direct dans l'URL : lien partageable,
 * retour arrière du navigateur, et la page serveur relit la base.
 * `apply` ramène en page 1 ; `applyLater` attend une pause dans la frappe
 * (recherche). */
export function useUrlFilters(current: Params) {
  const router = useRouter();
  const pathname = usePathname();
  const [pending, start] = useTransition();
  const timer = useRef<number | undefined>(undefined);

  useEffect(() => () => window.clearTimeout(timer.current), []);

  const go = (params: Params) => {
    const search = new URLSearchParams();
    for (const [k, v] of Object.entries(params)) if (v) search.set(k, v);
    start(() => router.replace(`${pathname}${search.size ? `?${search}` : ""}`, { scroll: false }));
  };

  const apply = (over: Params) => {
    window.clearTimeout(timer.current);
    go({ ...current, ...over, page: undefined });
  };

  const applyLater = (over: Params) => {
    window.clearTimeout(timer.current);
    timer.current = window.setTimeout(() => go({ ...current, ...over, page: undefined }), SEARCH_DELAY_MS);
  };

  /** Retire tous les filtres sauf ceux listés (ex. le mode d'affichage). */
  const reset = (keep: Params = {}) => { window.clearTimeout(timer.current); go(keep); };

  return { apply, applyLater, reset, pending };
}
