import type { LandingKey } from "@playlink/content-schema/landing-keys.ts";

// Données de l'éditeur « Contenu du site » : lues par la page (serveur),
// modifiées côté client, envoyées d'un bloc par publishSite.

export type SiteSettings = {
  /** AAAA-MM-JJ, vide = pas de date (« Bientôt »). */
  releaseDate: string;
  featuredGameIds: string[];
  demoDeckSize: number;
  demoMaxIntensity: number;
  doubleOptIn: boolean;
  instagramUrl: string;
  tiktokUrl: string;
  redditUrl: string;
};

export type SiteTexts = Record<LandingKey, { fr: string; en: string }>;

export type SiteDraft = {
  texts: SiteTexts;
  settings: SiteSettings;
  /** Catégorie → jouable dans la démo de la landing. */
  eligible: Record<string, boolean>;
  /** Clé → l'anglais publié n'a pas suivi le FR (FR modifié après l'EN).
   * Passe à `false` avec « L'anglais est à jour » : l'EN est alors
   * réenregistré tel quel à la publication. */
  enStale: Partial<Record<LandingKey, boolean>>;
};

export type EditorCategory = {
  id: string;
  name: string;
  /** Cartes actives par intensité (index 0 = intensité 1). */
  byIntensity: number[];
  /** Une vraie carte de la catégorie, pour l'aperçu de la démo. */
  sample: { text: string; intensity: number } | null;
};

export type EditorGame = {
  id: string;
  name: string;
  icon: string | null;
  active: boolean;
  colorMain: string;
  colorSecondary: string;
  nameEn: string | null;
  categories: EditorCategory[];
};
