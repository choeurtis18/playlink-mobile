# Playlink Mobile — Instructions Claude

## Objectif
App mobile Flutter (iOS + Android) des 8 jeux Playlink, jouable 100% hors-ligne.
Back-office Next.js pour le contenu et les stats. Doc de référence complète :
`docs/playlink-mobile-blueprint.html`.

## Monorepo
- `apps/mobile`      — Flutter, Dart 3. drift (SQLite), Riverpod, go_router.
- `apps/backoffice`  — Next.js 15 App Router, Prisma, shadcn/ui. Déployé sur Vercel.
- `packages/content-schema` — types partagés du snapshot de contenu (Zod + génération Dart).
- `scripts/`         — migration du contenu depuis l'ancienne base Playlink.

## Règles absolues — Base de données
- Base cloud : **Neon Postgres** via Vercel Marketplace. JAMAIS Supabase ici.
- JAMAIS `prisma migrate dev` sur une base avec des données → utiliser `prisma migrate deploy`.
- `prisma migrate dev --create-only` pour créer une migration sans l'appliquer.

## Règles absolues — Offline-first
- Toute action utilisateur réussit d'abord en local (SQLite). Le réseau est opportuniste.
- Aucun écran d'erreur réseau bloquant. Features réseau → état "se synchronisera plus tard".
- La logique de jeu (deck, scores, badges, archétypes) vit dans l'app, jamais sur le serveur.
- Le back-office ne fait que du CRUD et de la lecture d'agrégats. Pas de serveur de jeu.

## Auth
- Joueurs : **Clerk** (Apple / Google / email+mdp / magic link). Alternative documentée : Better Auth.
- Éditeurs back-office : distincts des joueurs (table AdminUser ou Clerk org séparée).
- Ne jamais mélanger les deux.

## Contenu
- Source de vérité : base Neon, éditée au back-office.
- L'app consomme un snapshot figé (`ContentRelease`), jamais le contenu live.
- Snapshot v1 embarqué dans le binaire. MAJ via `GET /content/latest` + swap SQLite au redémarrage.
- i18n : FR = langue originale. Carte sans `CardTranslation` → fallback FR.

## Modèle joueur
- 1 compte → N profils. Badges sur le compte. tagScores (archétype) sur le profil.
- Leaderboard = classement des profils DU compte (privé), pas mondial.
- Création de compte → merge local → cloud, idempotent (clientSessionId, localId).

## Freemium (préparé, pas construit en V1)
- Aucun paiement en V1. `EntitlementService` renvoie toujours true.
- Champs `tier` (free|premium) sur Category et par intensité, déjà en base.
- Le jour venu : abonnement via RevenueCat, webhook → `Account.premiumUntil`.

## Analytics
- PostHog Cloud EU. Opt-in explicite à l'onboarding. Aucune donnée perso.
- Stats propres (likes, cartes perso, comptes) : cron Vercel horaire → tables DailyStat/HourlyStat.

## Direction visuelle
- Fond sombre en base partout (pas gris neutre, noir teinté indigo). Mode clair en option (F2), jamais le défaut.
- Chaque jeu garde son dégradé `colorMain`→`colorSecondary` comme accent, contenu à sa tuile/son écran — jamais en fond d'app.
- Tuiles interactives : scale + glow coloré au tap/focus, jamais un aplat gris plat.
- Transition `Hero` (Flutter) réservée aux moments à fort enjeu : home→jeu, fin de partie. Pas sur chaque navigation.
- Détail complet : `docs/playlink-mobile-blueprint.html` §10.

## Conventions
- UI et contenu en FR + EN. Code et commentaires : suivre l'existant.
- Commentaires : seulement si le POURQUOI est non-évident.
- Chaque phase du plan de prototype = une PR revue avant la suivante.
- Migration : conserver les `id` cuid de l'ancienne base.
