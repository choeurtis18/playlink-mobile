"use server";

import { redirect } from "next/navigation";
import { postBackoffice } from "@/lib/backoffice";

/** Bouton « Me désinscrire ». Server Action (origine vérifiée par Next) ;
 * fonctionne sans JavaScript : le résultat revient par redirection. */
export async function unsubscribe(form: FormData) {
  const locale = form.get("locale") === "en" ? "en" : "fr";
  const id = String(form.get("id") ?? "");
  const token = String(form.get("t") ?? "");
  const res = id && token ? await postBackoffice<{ ok: boolean }>("/api/landing/unsubscribe", { id, token }) : null;
  redirect(`/${locale}/desinscription?etat=${res?.ok ? "ok" : "ko"}`);
}
