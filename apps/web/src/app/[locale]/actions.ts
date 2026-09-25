"use server";

import { postBackoffice } from "@/lib/backoffice";

export type PreRegisterState =
  | { status: "idle" }
  | { status: "done"; pending: boolean; email: string }
  | { status: "error"; reason: "email" | "consent" | "server" };

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
/** En dessous, c'est un robot : un humain ne tape pas un e-mail et ne
 * coche pas une case en moins d'une seconde et demie. */
const MIN_FILL_MS = 1500;

/** Pré-inscription. Server Action : Next vérifie l'origine de la requête
 * (protection CSRF intégrée), et le secret du back-office reste côté
 * serveur. Les robots (champ piège rempli, envoi instantané) reçoivent un
 * faux succès : leur répondre une erreur leur apprendrait à la contourner. */
export async function preRegister(_prev: PreRegisterState, form: FormData): Promise<PreRegisterState> {
  const email = String(form.get("email") ?? "").trim();
  const locale = form.get("locale") === "en" ? "en" : "fr";
  const startedAt = Number(form.get("startedAt") ?? 0);

  if (form.get("website") || !startedAt || Date.now() - startedAt < MIN_FILL_MS) {
    return { status: "done", pending: false, email };
  }
  if (!EMAIL_RE.test(email)) return { status: "error", reason: "email" };
  if (form.get("consent") !== "on") return { status: "error", reason: "consent" };

  const res = await postBackoffice<{ ok: boolean; pending: boolean }>("/api/landing/pre-register", {
    email,
    locale,
    consent: true,
  });
  if (!res?.ok) return { status: "error", reason: "server" };
  return { status: "done", pending: res.pending, email };
}
