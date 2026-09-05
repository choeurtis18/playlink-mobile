// Contrat du snapshot de contenu — `content_v{n}.json`.
//
// C'est le SEUL format d'échange entre le back-office et l'app : l'app ne
// lit jamais la base cloud, seulement une release figée (§06). Ce fichier
// est donc la source de vérité du format, et la génération Dart de la
// phase 2 doit en dériver.
//
// Règles de forme :
// - `locale` FR est la langue d'origine : le texte principal est en FR et
//   `translations` ne porte que les AUTRES langues (pas de doublon FR).
// - Les images sont des références `asset://{hash}.{ext}`, jamais des URL :
//   l'app doit pouvoir afficher hors-ligne.

import { z } from 'zod';

export const LocaleSchema = z.enum(['fr', 'en']);
export type Locale = z.infer<typeof LocaleSchema>;

/** `asset://{hash}.{ext}` — résolu localement, jamais par le réseau. */
export const AssetRefSchema = z.string().regex(/^asset:\/\/[a-f0-9]+\.[a-z0-9]+$/);

export const TranslationSchema = z.record(LocaleSchema, z.string());

export const CardSchema = z.object({
  id: z.string(),
  text: z.string().min(1),
  intensity: z.number().int().min(1).max(5),
  tags: z.array(z.string()),
  canonicalTags: z.array(z.string()),
  order: z.number().int(),
  tier: z.enum(['free', 'premium']),
  translations: TranslationSchema.optional(),
});

export const CategorySchema = z.object({
  id: z.string(),
  slug: z.string(),
  name: z.string(),
  description: z.string().nullable(),
  icon: z.string().nullable(),
  order: z.number().int(),
  tier: z.enum(['free', 'premium']),
  translations: z.record(LocaleSchema, z.object({
    name: z.string(),
    description: z.string().nullable().optional(),
  })).optional(),
  cards: z.array(CardSchema),
});

export const RuleSlideSchema = z.object({
  id: z.string(),
  order: z.number().int(),
  title: z.string(),
  content: z.string(),
  imageRef: AssetRefSchema.nullable(),
  translations: z.record(LocaleSchema, z.object({
    title: z.string(),
    content: z.string(),
  })).optional(),
});

export const GameSchema = z.object({
  id: z.string(),
  slug: z.string(),
  name: z.string(),
  description: z.string().nullable(),
  icon: z.string().nullable(),
  colorMain: z.string(),
  colorSecondary: z.string(),
  order: z.number().int(),
  translations: z.record(LocaleSchema, z.object({
    name: z.string(),
    description: z.string().nullable().optional(),
  })).optional(),
  ruleSlides: z.array(RuleSlideSchema),
  categories: z.array(CategorySchema),
});

/** Métadonnées seulement — la règle d'attribution est du code Dart (§01). */
export const BadgeSchema = z.object({
  key: z.string(),
  name: z.string(),
  description: z.string(),
  icon: z.string(),
  order: z.number().int(),
  translations: z.record(LocaleSchema, z.object({
    name: z.string(),
    description: z.string(),
  })).optional(),
});

export const LegalSchema = z.object({
  key: z.string(),
  locale: LocaleSchema,
  title: z.string(),
  content: z.string(),
});

export const AssetSchema = z.object({
  ref: AssetRefSchema,
  file: z.string(),
  hash: z.string(),
  bytes: z.number().int(),
  type: z.string(),
});

export const SnapshotSchema = z.object({
  version: z.number().int().positive(),
  generatedAt: z.string(),
  originalLocale: LocaleSchema,
  locales: z.array(LocaleSchema),
  games: z.array(GameSchema),
  badges: z.array(BadgeSchema),
  legal: z.array(LegalSchema),
  assets: z.array(AssetSchema),
});

export type Snapshot = z.infer<typeof SnapshotSchema>;
export type SnapshotGame = z.infer<typeof GameSchema>;
export type SnapshotCard = z.infer<typeof CardSchema>;
