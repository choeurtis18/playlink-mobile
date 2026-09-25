"use client";

import { openCookieSettings } from "@/lib/consent";

/** « Gérer les cookies » du pied de page : rouvre le bandeau sur les
 * préférences. Le consentement doit pouvoir être retiré aussi facilement
 * qu'il a été donné (CNIL). */
export function ManageCookiesButton({ label }: { label: string }) {
  return (
    <button type="button" onClick={openCookieSettings} className="text-left text-neutral-faint underline-offset-2 transition-colors hover:text-ink">
      {label}
    </button>
  );
}
