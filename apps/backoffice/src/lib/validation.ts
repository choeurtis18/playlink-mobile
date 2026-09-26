import { z } from "zod";

// Les bornes reflètent celles du snapshot (packages/content-schema) : une
// valeur acceptée ici mais refusée à la génération bloquerait la publication.

export const CardInput = z.object({
  text: z.string().trim().min(1, "Le texte est obligatoire").max(500),
  intensity: z.coerce.number().int().min(1).max(5),
  categoryId: z.string().min(1),
  tags: z.string().transform((s) => s.split(",").map((t) => t.trim()).filter(Boolean)),
  active: z.coerce.boolean(),
  order: z.coerce.number().int().min(0).default(0),
});

export const CategoryInput = z.object({
  name: z.string().trim().min(1).max(120),
  slug: z.string().trim().min(1).max(120).regex(/^[a-z0-9-]+$/, "minuscules, chiffres et tirets"),
  description: z.string().trim().max(500).nullable(),
  icon: z.string().trim().max(16).nullable(),
  order: z.coerce.number().int().min(0).default(0),
  gameId: z.string().min(1),
});

export const GameInput = z.object({
  name: z.string().trim().min(1).max(120),
  slug: z.string().trim().min(1).max(120).regex(/^[a-z0-9-]+$/),
  description: z.string().trim().max(1000).nullable(),
  icon: z.string().trim().max(16).nullable(),
  colorMain: z.string().regex(/^#[0-9A-Fa-f]{6}$/, "format #RRGGBB"),
  colorSecondary: z.string().regex(/^#[0-9A-Fa-f]{6}$/, "format #RRGGBB"),
  active: z.coerce.boolean(),
  order: z.coerce.number().int().min(0).default(0),
});

export const BadgeInput = z.object({
  key: z.string().trim().min(1).regex(/^[a-z0-9_]+$/, "minuscules et underscores"),
  name: z.string().trim().min(1).max(120),
  description: z.string().trim().min(1).max(500),
  icon: z.string().trim().min(1).max(16),
  order: z.coerce.number().int().min(0).default(0),
});

export const SlideInput = z.object({
  gameId: z.string().min(1),
  title: z.string().trim().min(1).max(200),
  content: z.string().trim().min(1).max(2000),
  order: z.coerce.number().int().min(0).default(0),
});

export const TranslationInput = z.object({
  cardId: z.string().min(1),
  locale: z.enum(["en"]),
  text: z.string().trim().min(1).max(500),
});

/** Traduction anglaise d'un contenu autre qu'une carte. Mêmes bornes que
 * les champs d'origine (snapshot). Champs facultatifs : vide = null. */
const optionalText = (max: number) => z.string().trim().max(max).transform((v) => v || null);
export const ContentTranslationInput = {
  game: z.object({ name: z.string().trim().min(1, "Le nom anglais est obligatoire").max(100), description: optionalText(500) }),
  category: z.object({ name: z.string().trim().min(1, "Le nom anglais est obligatoire").max(120), description: optionalText(500) }),
  slide: z.object({ title: z.string().trim().min(1, "Le titre anglais est obligatoire").max(200), content: z.string().trim().min(1, "Le contenu anglais est obligatoire").max(2000) }),
  badge: z.object({ name: z.string().trim().min(1, "Le nom anglais est obligatoire").max(100), description: z.string().trim().min(1, "La description anglaise est obligatoire").max(300) }),
} as const;
export type ContentKind = keyof typeof ContentTranslationInput;

// ── Landing (SiteContent, une seule ligne id "default") ───────────────

/** URL de réseau social : vide = réseau masqué sur la landing. */
const socialUrl = z
  .string()
  .trim()
  .transform((v) => v || null)
  .pipe(z.string().url("Lien invalide — il doit commencer par https://").nullable());

/** Réglages de la landing publiés avec les textes (éditeur « Contenu du
 * site »). Les textes, eux, sont validés clé par clé par
 * LandingTextInputSchema (content-schema). */
export const SiteSettingsInput = z.object({
  releaseDate: z
    .string()
    .trim()
    .transform((v) => (v ? new Date(`${v}T00:00:00Z`) : null))
    .refine((d) => d === null || !Number.isNaN(d.getTime()), "Date de sortie invalide"),
  featuredGameIds: z.array(z.string().min(1)).max(8, "8 jeux au plus sur la landing"),
  demoDeckSize: z.number().int().min(3).max(6),
  demoMaxIntensity: z.number().int().min(1).max(5),
  doubleOptIn: z.boolean(),
  instagramUrl: socialUrl,
  tiktokUrl: socialUrl,
  redditUrl: socialUrl,
});
export type SiteSettingsInput = z.input<typeof SiteSettingsInput>;
