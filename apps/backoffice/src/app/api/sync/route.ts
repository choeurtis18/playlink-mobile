import { NextResponse } from "next/server";
import { UnauthorizedError, requirePlayerAccount } from "@/lib/auth-players";
import { prisma } from "@/lib/prisma";
import { SyncPayload } from "@/lib/validation-sync";

/**
 * Merge local → cloud de l'historique d'un joueur (§05, phase 4) — appelée
 * juste après la connexion, avec TOUT l'historique local d'un coup (pas de
 * delta). Idempotent partout :
 * - profils : upsert sur (accountId, localId)
 * - parties : upsert sur (accountId, clientSessionId)
 * - badges  : upsert sur (accountId, badgeKey)
 * - cartes  : upsert sur (accountId, localId côté client → remoteId stocké
 *   après coup ; pas de contrainte unique dédiée, cf. note plus bas)
 *
 * Aucune ligne dont le gameId/categoryId ne correspond plus au contenu
 * back-office n'est rejetée en bloc : elle est simplement ignorée (l'app
 * peut tourner sur un snapshot de contenu plus vieux que la prod).
 */
/**
 * Descend tout l'historique du compte (§05, phase 4) — appelée juste après
 * la connexion, avant l'envoi (POST) du côté local : sans ceci, un joueur
 * qui se connecte sur un appareil qui n'a jamais eu ses profils/parties en
 * local ne les revoit jamais (le POST n'envoie que ce qui existe déjà côté
 * client, jamais l'inverse). Le merge local des deux sens est fait par
 * l'app (upsert par localId/clientSessionId/badgeKey), jamais ici.
 */
export async function GET(request: Request) {
  let account;
  try {
    account = await requirePlayerAccount(request);
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    console.error("GET /api/sync (auth)", error);
    return NextResponse.json({ error: "Erreur serveur" }, { status: 500 });
  }

  const [profiles, sessions, badges, customCards] = await Promise.all([
    prisma.profile.findMany({ where: { accountId: account.id } }),
    prisma.syncedSession.findMany({
      where: { accountId: account.id },
      include: { players: true },
    }),
    prisma.earnedBadge.findMany({ where: { accountId: account.id } }),
    prisma.customCard.findMany({ where: { accountId: account.id } }),
  ]);

  return NextResponse.json({
    profiles: profiles.map((p) => ({
      localId: p.localId,
      remoteId: p.id,
      name: p.name,
      avatar: p.avatar,
      tagScores: p.tagScores,
    })),
    sessions: sessions.map((s) => ({
      clientSessionId: s.clientSessionId,
      gameId: s.gameId,
      categoryId: s.categoryId,
      locale: s.locale,
      playerCount: s.playerCount,
      startedAt: s.startedAt,
      finishedAt: s.finishedAt,
      players: s.players.map((sp) => ({
        profileRemoteId: sp.profileId,
        score: sp.score,
        tagScoresGained: sp.tagScoresGained,
      })),
    })),
    badges: badges.map((b) => ({ badgeKey: b.badgeKey, earnedAt: b.earnedAt })),
    customCards: customCards.map((c) => ({
      remoteId: c.id,
      gameId: c.gameId,
      categoryId: c.categoryId,
      text: c.text,
      intensity: c.intensity,
      active: c.active,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    })),
  });
}

export async function POST(request: Request) {
  let account;
  try {
    account = await requirePlayerAccount(request);
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    console.error("POST /api/sync (auth)", error);
    return NextResponse.json({ error: "Erreur serveur" }, { status: 500 });
  }

  const json = await request.json().catch(() => null);
  const parsed = SyncPayload.safeParse(json);
  if (!parsed.success) {
    return NextResponse.json({ error: "Payload invalide", details: parsed.error.flatten() }, { status: 400 });
  }
  const { profiles, sessions, badges, customCards } = parsed.data;

  const [validGameIds, validCategoryIds] = await Promise.all([
    prisma.game.findMany({ select: { id: true } }).then((rows) => new Set(rows.map((r) => r.id))),
    prisma.category.findMany({ select: { id: true } }).then((rows) => new Set(rows.map((r) => r.id))),
  ]);

  const profileRemoteIds: Record<string, string> = {};
  const cardRemoteIds: Record<string, string> = {};

  await prisma.$transaction(async (tx) => {
    // Profils — condition d'existence de tout le reste (parties, badges).
    for (const p of profiles) {
      const row = await tx.profile.upsert({
        where: { accountId_localId: { accountId: account.id, localId: p.localId } },
        create: { accountId: account.id, localId: p.localId, name: p.name, avatar: p.avatar, tagScores: p.tagScores },
        update: { name: p.name, avatar: p.avatar, tagScores: p.tagScores },
      });
      profileRemoteIds[p.localId] = row.id;
    }

    for (const s of sessions) {
      if (!validGameIds.has(s.gameId) || !validCategoryIds.has(s.categoryId)) continue;
      const players = s.players.filter((sp) => profileRemoteIds[sp.profileLocalId]);
      if (players.length === 0) continue;

      const session = await tx.syncedSession.upsert({
        where: { accountId_clientSessionId: { accountId: account.id, clientSessionId: s.clientSessionId } },
        create: {
          accountId: account.id,
          clientSessionId: s.clientSessionId,
          gameId: s.gameId,
          categoryId: s.categoryId,
          locale: s.locale,
          playerCount: s.playerCount,
          startedAt: s.startedAt,
          finishedAt: s.finishedAt,
        },
        update: {}, // immuable une fois créée — rejouer le payload ne doit rien changer
      });

      for (const sp of players) {
        await tx.syncedSessionPlayer.upsert({
          where: {
            sessionId_profileId: { sessionId: session.id, profileId: profileRemoteIds[sp.profileLocalId] },
          },
          create: {
            sessionId: session.id,
            profileId: profileRemoteIds[sp.profileLocalId],
            score: sp.score,
            tagScoresGained: sp.tagScoresGained,
          },
          update: {},
        });
      }
    }

    for (const b of badges) {
      await tx.earnedBadge.upsert({
        where: { accountId_badgeKey: { accountId: account.id, badgeKey: b.badgeKey } },
        create: { accountId: account.id, badgeKey: b.badgeKey, earnedAt: b.earnedAt },
        update: {},
      });
    }

    // Cartes perso : pas de clé (accountId, localId) unique en base (le
    // localId n'est connu que du client) — on retrouve une carte déjà
    // synchronisée par son remoteId si l'app le renvoyait, mais en V1 elle
    // ne le fait qu'après ce premier aller-retour : ici, toujours une
    // création. Rejouable sans doublon car l'app ne renvoie que les cartes
    // dont `remoteId` est encore null côté local (voir account_sync.dart).
    for (const c of customCards) {
      if (!validGameIds.has(c.gameId) || !validCategoryIds.has(c.categoryId)) continue;
      const row = await tx.customCard.create({
        data: {
          accountId: account.id,
          gameId: c.gameId,
          categoryId: c.categoryId,
          text: c.text,
          intensity: c.intensity,
          active: c.active,
        },
      });
      cardRemoteIds[c.localId] = row.id;
    }
  });

  return NextResponse.json({ profileRemoteIds, cardRemoteIds });
}
