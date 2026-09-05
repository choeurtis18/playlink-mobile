# apps/backoffice — Back-office Next.js

Vide jusqu'à la **phase 1** du plan de prototype (§12 du blueprint).

## Ce qui sera créé ici

Next.js 15 App Router + Prisma + shadcn/ui, déployé sur Vercel.

Rôle strictement borné : **CRUD de contenu et lecture d'agrégats**.
Aucune logique de jeu — elle vit dans l'app (règle absolue, CLAUDE.md).

## Pages prévues (§08)

Dashboard · Jeux/Catégories/Cartes · Traductions · Règles du jeu · Badges ·
Cartes des utilisateurs · Likes · Publication

## Endpoints exposés à l'app

| Endpoint              | Rôle |
|-----------------------|------|
| `GET /content/latest` | `{ version, snapshotUrl, changelog }` |
| `POST /sync`          | File de synchronisation des comptes (phase 4) |
| `GET /api/legal/[key]`| CGU / confidentialité |

## Crons Vercel (§08)

    { path: '/api/cron/aggregate-stats', schedule: '0 * * * *' }
    { path: '/api/cron/aggregate-daily', schedule: '15 3 * * *' }

## Règle base de données

`prisma migrate deploy` en production. **JAMAIS** `prisma migrate dev` sur une
base contenant des données.
