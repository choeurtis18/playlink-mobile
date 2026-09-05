# Playlink Mobile

Portage de [Playlink](https://github.com/choeurtis18) — app web de jeux de
cartes entre amis — en application mobile **Flutter**, jouable **100 %
hors-ligne**, sur iOS et Android.

> **Document de référence : [`docs/playlink-mobile-blueprint.html`](docs/playlink-mobile-blueprint.html)**
> Vision produit, architecture, modèle de données, workflows, direction
> visuelle, plan de prototype, coûts. Source de vérité — ne rien supposer qui
> le contredise.
>
> Résumé opérationnel pour les sessions Claude Code : [`CLAUDE.md`](CLAUDE.md).

## Le modèle en une phrase

Pass-and-play sur un seul téléphone : plusieurs joueurs autour d'un appareil,
on se le passe, les scores se cumulent entre les parties. Pas de multi-appareils,
pas de temps réel, pas de serveur de jeu.

## Structure

| Dossier                    | Rôle | Phase |
|----------------------------|------|-------|
| `apps/mobile`              | App Flutter (Dart 3) — drift, Riverpod, go_router | 2 |
| `apps/backoffice`          | Next.js 15 App Router + Prisma + shadcn/ui, sur Vercel | 1 |
| `packages/content-schema`  | Types Zod du snapshot de contenu + génération Dart | 1 |
| `scripts/`                 | Migration du contenu depuis l'ancienne base | 1 |
| `docs/`                    | Blueprint + notes de phase | — |

## Les 8 jeux

🎯 Action ou Vérité · 🧊 Icebreaker · 💥 Dégât Débat · 🗳️ Qui de nous ·
🎭 Mime · ☕ Thé ou café · ⚖️ Dilemme · 🕵️ Devine le mot

28 catégories, ~1 500 cartes. Catalogue détaillé au §02 du blueprint.

## Architecture

Trois composants, aucun serveur applicatif de jeu :

1. **App Flutter** — SQLite (drift) : contenu, profils, parties, badges. Toute
   la logique de jeu. Fonctionne sans réseau.
2. **Back-office Next.js** sur Vercel — CRUD du contenu, publication de
   versions, dashboard de stats. Ne parle jamais à l'app pendant une partie.
3. **Neon Postgres** — contenu maître, comptes, likes, cartes perso, agrégats.

Le réseau ne sert qu'à trois choses secondaires : mises à jour de contenu
(~1×/mois), synchronisation du compte optionnel, statistiques anonymes.

## Développement

Prérequis : Flutter (Dart 3), Node ≥ 20, pnpm 10, Xcode, Android Studio.

    pnpm install                 # dépendances JS du monorepo
    pnpm backoffice:dev          # back-office        (phase 1)
    pnpm mobile:run              # app sur téléphone  (phase 2)

Variables d'environnement : copier `.env.example` en `.env`.

## Coûts

Infra récurrente **0 $/mois** en V1 (free tiers Vercel, Neon, Clerk, PostHog,
Blob, FCM). Ponctuel : Apple Developer 99 $/an, Google Play 25 $ une fois —
reportés en phase 6. Détail au §13.

## État d'avancement

- [x] **Phase 0** — Fondations : structure du monorepo, outillage local
- [ ] **Phase 1** — Back-office & migration du contenu
- [ ] **Phase 2** — Coquille de l'app + jeu offline
- [ ] **Phase 3** — Progression locale
- [ ] **Phase 4** — Compte & synchronisation
- [ ] **Phase 5** — Communauté & analytics
- [ ] **Phase 6** — Polish & mise en magasin

Détail de l'état courant : [`docs/phase-0-etat.md`](docs/phase-0-etat.md).
