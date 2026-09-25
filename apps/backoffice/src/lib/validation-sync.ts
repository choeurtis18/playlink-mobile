import { z } from "zod";

// Payload envoyé par l'app mobile après connexion (§04, phase 4) — tout
// l'historique local d'un coup, à chaque connexion. Idempotent : rejouer
// le même payload ne doit jamais créer de doublons (localId/clientSessionId
// comme clés de réconciliation, cf. schema.prisma).

export const SyncProfileInput = z.object({
  localId: z.string().min(1),
  name: z.string().trim().min(1).max(60),
  avatar: z.string().nullable(),
  tagScores: z.record(z.string(), z.number()).default({}),
});

export const SyncSessionPlayerInput = z.object({
  profileLocalId: z.string().min(1),
  score: z.coerce.number().int().default(0),
  tagScoresGained: z.record(z.string(), z.number()).default({}),
});

export const SyncSessionInput = z.object({
  clientSessionId: z.string().min(1),
  gameId: z.string().min(1),
  categoryId: z.string().min(1),
  locale: z.string().default("fr"),
  playerCount: z.coerce.number().int().min(1),
  startedAt: z.coerce.date(),
  finishedAt: z.coerce.date(),
  players: z.array(SyncSessionPlayerInput),
});

export const SyncBadgeInput = z.object({
  badgeKey: z.string().min(1),
  earnedAt: z.coerce.date(),
});

export const SyncCustomCardInput = z.object({
  localId: z.string().min(1),
  gameId: z.string().min(1),
  categoryId: z.string().min(1),
  text: z.string().trim().min(1).max(500),
  intensity: z.coerce.number().int().min(1).max(5),
  active: z.coerce.boolean(),
});

export const SyncPayload = z.object({
  profiles: z.array(SyncProfileInput).default([]),
  sessions: z.array(SyncSessionInput).default([]),
  badges: z.array(SyncBadgeInput).default([]),
  customCards: z.array(SyncCustomCardInput).default([]),
});

export type SyncPayloadType = z.infer<typeof SyncPayload>;
