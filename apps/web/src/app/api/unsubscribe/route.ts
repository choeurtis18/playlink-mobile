import { NextResponse } from "next/server";
import { postBackoffice } from "@/lib/backoffice";

/** Désinscription « en un clic » (RFC 8058) : la messagerie (bouton « Se
 * désabonner » de Gmail, Apple Mail…) envoie un POST à l'adresse de
 * l'en-tête List-Unsubscribe de l'e-mail de bienvenue. Pas de page : la
 * messagerie n'affiche rien, seul le statut compte. */
export async function POST(req: Request) {
  const sp = new URL(req.url).searchParams;
  const id = sp.get("id") ?? "", token = sp.get("t") ?? "";
  const res = id && token ? await postBackoffice<{ ok: boolean }>("/api/landing/unsubscribe", { id, token }) : null;
  return NextResponse.json({ ok: Boolean(res?.ok) }, { status: res?.ok ? 200 : 400 });
}

/** Ouverte dans un navigateur (ancienne messagerie, lien copié) : renvoie
 * vers la page, qui demande un clic. */
export function GET(req: Request) {
  const url = new URL(req.url);
  return NextResponse.redirect(new URL(`/fr/desinscription${url.search}`, url.origin), 303);
}
