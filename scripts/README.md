# scripts — Migration du contenu depuis l'ancienne base Playlink

Vide jusqu'à la **phase 1**. Procédure complète au §07 du blueprint.

## Ce qui est migré

Uniquement le **contenu** : jeux, catégories, cartes, règles + slides, badges.

**Pas** les `User`, `AppUser`, `Player`, `GameSession`, `Event`, `AuditLog` —
les joueurs de l'app web ne sont pas récupérés (consigne produit).

## Scripts prévus

| Script                | Rôle |
|-----------------------|------|
| `migrate-content.ts`  | Dump → transformation → nouveau schéma Prisma |
| `fetch-assets.ts`     | Télécharge les ~100 GIF, les renomme `{hash}.gif`, réécrit les références en `asset://{ref}` |
| `verify-migration.ts` | Compte lignes source vs cible par table, liste les écarts. **Produit le décompte exact** par jeu/catégorie/intensité |

## Dump de départ

    pg_dump --data-only --table=games --table=game_rules \
      --table=game_rule_slides --table=categories \
      --table=cards --table=badges \
      "$LEGACY_SUPABASE_DIRECT_URL" > dumps/playlink_content.sql

`dumps/` et `assets-cache/` sont gitignorés (volumineux, données de prod).

## Règles de transformation

- `Card.intensity` (1–5) pris tel quel ; `difficulty` legacy abandonné.
- `Card.tags[]` : tags bruts conservés **et** tags canoniques pré-calculés
  (portage de `tag-mapping.ts`, 14 tags canoniques).
- `originalLocale = "fr"` partout, aucune `*Translation` initialement.
- **Les `id` cuid de l'ancienne base sont conservés.**
