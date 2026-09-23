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

// Une seule ligne (id "default") : voir le commentaire sur SiteContent
// dans schema.prisma. Le formulaire édite toujours FR + EN ensemble.
export const SiteContentInput = z.object({
  releaseDate: z.coerce.date().nullable(),
  heroImageUrl: z.string().trim().url().nullable(),
  // Obligatoire dès qu'une image est renseignée — accessibilité (plan
  // landing §07), pas une simple convention de style.
  heroImageAlt: z.string().trim().max(300).nullable(),
  instagramUrl: z.string().trim().url().nullable(),
  tiktokUrl: z.string().trim().url().nullable(),
  redditUrl: z.string().trim().url().nullable(),
  featuredGameIds: z.array(z.string().min(1)).max(8),
  heroTitleFr: z.string().trim().min(1).max(200),
  heroLedeFr: z.string().trim().min(1).max(500),
  ctaLabelFr: z.string().trim().min(1).max(80),
  heroTitleEn: z.string().trim().min(1).max(200),
  heroLedeEn: z.string().trim().min(1).max(500),
  ctaLabelEn: z.string().trim().min(1).max(80),
}).refine(
  (v) => !v.heroImageUrl || !!v.heroImageAlt,
  { message: "Le texte alternatif est obligatoire pour une image de héros.", path: ["heroImageAlt"] }
);
