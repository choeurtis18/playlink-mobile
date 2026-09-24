// Seul point de contact avec le contenu : apps/web ne parle jamais
// directement à Neon (plan landing §01). Le back-office invalide son propre
// cache à chaque modification ; ce site-ci garde sa copie au plus une heure
// (revalidate: 3600) — un texte publié apparaît donc dans l'heure.

import {
  DEFAULT_DEMO_SETTINGS,
  resolveLandingTexts,
  type DemoSettings,
  type LandingTexts,
} from "@playlink/content-schema/landing-keys.ts";

const BACKOFFICE_URL = process.env.BACKOFFICE_URL ?? "http://localhost:3000";

export type FeaturedGame = {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  icon: string | null;
  colorMain: string;
  colorSecondary: string;
  categoryCount: number;
  translations: Record<string, { name: string; description: string | null }>;
};

export type SiteStats = { games: number; categories: number; cards: number };

export type SiteConfig = {
  releaseDate: string | null;
  heroImageUrl: string | null;
  heroImageAlt: string | null;
  social: { instagram: string | null; tiktok: string | null; reddit: string | null };
  /** Partiel : passer par `landingTexts()` pour obtenir un jeu complet. */
  texts: Record<string, Record<string, string>>;
  demo: DemoSettings;
  stats: SiteStats | null;
  featuredGames: FeaturedGame[];
};

export type PreviewCard = {
  id: string;
  text: string;
  intensity: number;
  translations: Record<string, { text: string }>;
};

export type PreviewCategory = {
  slug: string;
  name: string;
  icon: string | null;
  game: { id: string; slug: string; name: string; colorMain: string; colorSecondary: string; icon: string | null };
  translations: Record<string, { name: string }>;
  cards: PreviewCard[];
};

export type PreviewContent = { categories: PreviewCategory[] };

async function fetchJson<T>(path: string, fallback: T): Promise<T> {
  try {
    const res = await fetch(`${BACKOFFICE_URL}${path}`, { next: { revalidate: 3600 } });
    if (!res.ok) {
      console.error(`[backoffice] ${path} → HTTP ${res.status}, contenu de repli utilisé`);
      return fallback;
    }
    return (await res.json()) as T;
  } catch (e) {
    // Une panne ne doit jamais produire une page vide : Google indexerait
    // une coquille et un visiteur partirait. Le repli ci-dessous porte donc
    // un vrai contenu. Le log rend la panne visible dans les logs Vercel —
    // sans lui, le site semblerait simplement "un peu vide".
    console.error(`[backoffice] ${path} injoignable (${BACKOFFICE_URL}), contenu de repli utilisé`, e);
    return fallback;
  }
}

// Sans jeux ni chiffres : mieux vaut une page courte mais juste qu'une page
// qui promet des jeux qu'elle ne peut pas décrire, ou des chiffres faux.
// Les textes, eux, retombent sur ceux de packages/content-schema.
const FALLBACK_SITE: SiteConfig = {
  releaseDate: null,
  heroImageUrl: null,
  heroImageAlt: null,
  social: { instagram: null, tiktok: null, reddit: null },
  texts: {},
  demo: DEFAULT_DEMO_SETTINGS,
  stats: null,
  featuredGames: [],
};

export async function getSiteConfig(): Promise<SiteConfig> {
  const site = await fetchJson<Partial<SiteConfig>>("/api/site-config", FALLBACK_SITE);
  // Un back-office encore à l'ancienne version renvoie un JSON sans ces
  // champs : on complète plutôt que de planter au rendu.
  return {
    ...FALLBACK_SITE,
    ...site,
    texts: site.texts ?? {},
    demo: site.demo ?? DEFAULT_DEMO_SETTINGS,
    stats: site.stats ?? null,
    featuredGames: (site.featuredGames ?? []).map((g) => ({ ...g, categoryCount: g.categoryCount ?? 0, translations: g.translations ?? {} })),
  };
}

/** Tous les textes de la page dans une langue, repli langue → FR → défaut. */
export function landingTexts(site: SiteConfig, locale: string): LandingTexts {
  return resolveLandingTexts(site.texts, locale);
}

export function getPreviewContent() {
  return fetchJson<PreviewContent>("/api/preview-content", { categories: [] });
}

/** Ancres de la landing, dans l'ordre de la page. */
export type LandingSectionId = "jeux" | "demo" | "apropos" | "notif" | "reseaux";

/** Sections réellement rendues, pour que le header ne propose jamais un
 * lien vers une section absente (réseaux sans lien, jeux non choisis…).
 * Calculé côté serveur : pas de lien qui apparaît ou disparaît après
 * hydratation. */
export function landingSections(site: SiteConfig): LandingSectionId[] {
  const hasSocial = Boolean(site.social.instagram || site.social.tiktok || site.social.reddit);
  return [
    site.featuredGames.length > 0 && "jeux",
    "demo",
    "apropos",
    "notif",
    hasSocial && "reseaux",
  ].filter((s): s is LandingSectionId => Boolean(s));
}

/** Écriture vers le back-office (pré-inscription…), serveur à serveur
 * uniquement : le secret ne quitte jamais le serveur du site. `null` si le
 * back-office est injoignable ou refuse — l'appelant affiche une erreur. */
export async function postBackoffice<T>(path: string, body: unknown): Promise<T | null> {
  try {
    const res = await fetch(`${BACKOFFICE_URL}${path}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.LANDING_API_SECRET ?? ""}`,
      },
      body: JSON.stringify(body),
      cache: "no-store",
    });
    if (!res.ok) {
      console.error(`[backoffice] POST ${path} → HTTP ${res.status}`);
      return null;
    }
    return (await res.json()) as T;
  } catch (e) {
    console.error(`[backoffice] POST ${path} injoignable (${BACKOFFICE_URL})`, e);
    return null;
  }
}
