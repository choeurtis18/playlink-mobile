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

// Héros de secours, utilisé à deux endroits : quand le back-office est
// injoignable, et quand il répond mais qu'aucune traduction n'a encore été
// saisie. Dans les deux cas, une page sans titre serait pire que ce texte
// générique — pour le visiteur comme pour l'indexation.
export const FALLBACK_HERO: Record<string, { heroTitle: string; heroLede: string; ctaLabel: string }> = {
  fr: {
    heroTitle: "Les jeux de soirée qui manquaient à votre téléphone",
    heroLede:
      "8 jeux, des centaines de cartes, jouables entre amis sans connexion. Playlink arrive bientôt sur iOS et Android.",
    ctaLabel: "Prévenez-moi au lancement",
  },
  en: {
    heroTitle: "The party games your phone was missing",
    heroLede:
      "8 games, hundreds of cards, playable with friends with no connection needed. Playlink is coming soon to iOS and Android.",
    ctaLabel: "Notify me at launch",
  },
};

// Sans jeux : mieux vaut une page courte mais juste qu'une page qui
// promet des jeux qu'elle ne peut pas décrire.
const FALLBACK_SITE: SiteConfig = {
  releaseDate: null,
  heroImageUrl: null,
  heroImageAlt: null,
  social: { instagram: null, tiktok: null, reddit: null },
  translations: FALLBACK_HERO,
  featuredGames: [],
};

export function getSiteConfig() {
  return fetchJson<SiteConfig>("/api/site-config", FALLBACK_SITE);
}

export function getPreviewContent() {
  return fetchJson<PreviewContent>("/api/preview-content", { categories: [] });
}
