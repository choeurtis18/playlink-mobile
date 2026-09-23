// Seul point de contact avec le contenu : apps/web ne parle jamais
// directement à Neon (plan landing §01). Le back-office invalide ces
// données via revalidateTag("site-config"/"preview-content") à chaque
// publication — pas de TTL court à deviner ici.

const BACKOFFICE_URL = process.env.BACKOFFICE_URL ?? "http://localhost:3000";

export type FeaturedGame = {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  icon: string | null;
  colorMain: string;
  colorSecondary: string;
};

export type SiteConfig = {
  releaseDate: string | null;
  heroImageUrl: string | null;
  heroImageAlt: string | null;
  social: { instagram: string | null; tiktok: string | null; reddit: string | null };
  translations: Record<string, { heroTitle: string; heroLede: string; ctaLabel: string }>;
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
  game: { slug: string; name: string; colorMain: string; colorSecondary: string; icon: string | null };
  translations: Record<string, { name: string }>;
  cards: PreviewCard[];
};

export type PreviewContent = { categories: PreviewCategory[] };

async function fetchJson<T>(path: string, fallback: T): Promise<T> {
  try {
    const res = await fetch(`${BACKOFFICE_URL}${path}`, { next: { revalidate: 3600 } });
    if (!res.ok) return fallback;
    return (await res.json()) as T;
  } catch {
    // Le back-office peut être temporairement indisponible : la landing
    // reste utilisable avec un contenu de repli plutôt qu'un écran d'erreur
    // (cohérent avec la règle offline-first — "aucun écran d'erreur réseau
    // bloquant", CLAUDE.md — même si ce n'est pas l'app ici).
    return fallback;
  }
}

export function getSiteConfig() {
  return fetchJson<SiteConfig>("/api/site-config", {
    releaseDate: null,
    heroImageUrl: null,
    heroImageAlt: null,
    social: { instagram: null, tiktok: null, reddit: null },
    translations: {},
    featuredGames: [],
  });
}

export function getPreviewContent() {
  return fetchJson<PreviewContent>("/api/preview-content", { categories: [] });
}
