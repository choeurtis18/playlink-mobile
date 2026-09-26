// Mesure d'audience de la landing : PostHog Cloud EU, projet dédié.
//
// - La bibliothèque n'est téléchargée qu'après consentement (import
//   dynamique) : sans accord, aucun script tiers, aucun cookie `ph_*`.
// - Aucune donnée personnelle : jamais d'identify, pas de profils,
//   pas d'enregistrement de session, pas d'autocapture (seuls les
//   événements listés ici partent).
// - Retrait du consentement : arrêt immédiat et suppression des cookies.

import type { PostHog } from "posthog-js";

const KEY = process.env.NEXT_PUBLIC_POSTHOG_KEY_LANDING;
const HOST = process.env.NEXT_PUBLIC_POSTHOG_HOST_LANDING ?? "https://eu.i.posthog.com";
// Envoi par le relais du site (voir next.config.ts), moins filtré par les
// bloqueurs de publicité. `ui_host` : liens vers l'interface PostHog
// (barre d'outils), qui ne passent pas par le relais.
const RELAY = "/relais";
const UI_HOST = HOST.replace(/^https:\/\/(\w+)\.i\.posthog\.com\/?$/, "https://$1.posthog.com");

/** Événements suivis, et leurs propriétés. Rien d'autre ne part. */
export type AnalyticsEvents = {
  $pageview: { locale: string };
  demo_opened: { gameSlug: string };
  demo_started: { gameSlug: string; category: string; intensity: number; deckSize: number };
  demo_card_revealed: { gameSlug: string; cardIndex: number };
  demo_vote_submitted: { gameSlug: string; cardIndex: number; point: boolean };
  demo_completed: { gameSlug: string; category: string; timeSpentS: number };
  preregister_submitted: { locale: string; pending: boolean };
  social_link_clicked: { platform: string };
  cta_clicked: { cta: string };
};

let client: PostHog | null = null;
let loading: Promise<PostHog | null> | null = null;
let queue: [string, Record<string, unknown>][] = [];
let allowed = false;

export function isAnalyticsConfigured() {
  return Boolean(KEY);
}

/** Appelé quand le consentement change (et au chargement s'il existe). */
export async function setAnalyticsConsent(granted: boolean) {
  allowed = granted && Boolean(KEY);
  if (!allowed) {
    queue = [];
    if (client) {
      client.opt_out_capturing();
      // Sans ça, PostHog réécrit son cookie juste après qu'on l'a effacé.
      // Pas de reset() : il redemande les feature flags au serveur, soit
      // une requête après le retrait du consentement. Effacer le stockage
      // suffit — un nouvel accord repartira d'un identifiant neuf.
      client.set_config({ disable_persistence: true });
    }
    clearPosthogCookies();
    return;
  }
  const ph = await load();
  if (!ph) return;
  ph.set_config({ disable_persistence: false });
  ph.opt_in_capturing();
  for (const [event, props] of queue) ph.capture(event, props);
  queue = [];
}

export function capture<E extends keyof AnalyticsEvents>(event: E, props: AnalyticsEvents[E]) {
  if (!allowed) return;
  if (client) client.capture(event, props);
  // Consentement donné mais bibliothèque encore en chargement : on garde
  // l'événement pour ne pas perdre la première page vue.
  else queue.push([event, props]);
}

function load(): Promise<PostHog | null> {
  loading ??= import("posthog-js")
    .then(({ default: posthog }) => {
      posthog.init(KEY!, {
        api_host: RELAY,
        ui_host: UI_HOST,
        person_profiles: "never",
        autocapture: false,
        capture_pageview: false, // envoyé à la main, avec la langue
        capture_pageleave: false,
        disable_session_recording: true,
        disable_surveys: true,
        persistence: "localStorage+cookie",
      });
      client = posthog;
      return posthog;
    })
    .catch((e) => {
      console.error("[analytics] PostHog n'a pas pu être chargé", e);
      loading = null;
      return null;
    });
  return loading;
}

/** Cookies `ph_*` posés par PostHog : supprimés au retrait du consentement. */
function clearPosthogCookies() {
  for (const c of document.cookie.split("; ")) {
    const name = c.split("=")[0];
    if (name.startsWith("ph_")) document.cookie = `${name}=; Max-Age=0; Path=/`;
  }
  try {
    for (const k of Object.keys(localStorage)) if (k.startsWith("ph_")) localStorage.removeItem(k);
  } catch {
    // Stockage indisponible (navigation privée) : rien à effacer.
  }
}
