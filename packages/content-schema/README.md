# packages/content-schema — Schéma partagé du snapshot de contenu

Vide jusqu'à la **phase 1**.

Source de vérité du format d'échange entre le back-office et l'app :

- Types **Zod** décrivant `content_v{n}.json` (jeux → catégories → cartes,
  règles + slides, badges, traductions, assets).
- **Génération des classes Dart** correspondantes pour `apps/mobile`, afin que
  les deux côtés ne divergent jamais.

Consommé par `apps/backoffice` (génération du snapshot) et `scripts/`
(vérification de migration).
