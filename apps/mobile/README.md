# apps/mobile — Application Flutter

Vide jusqu'à la **phase 2** du plan de prototype (§12 du blueprint).

## Ce qui sera créé ici

    flutter create --org com.playlink --project-name playlink \
      --platforms=ios,android .

Stack imposée par le blueprint :

| Couche      | Choix       |
|-------------|-------------|
| Base locale | `drift` (SQLite typé) |
| State       | `Riverpod`  |
| Navigation  | `go_router` |
| i18n        | `flutter_localizations` + ARB (FR + EN) |

- Bundle ID : `com.playlink.app`
- Thème **sombre-first** dès la pose de la coquille (§10) — plus coûteux à
  retrofitter qu'à poser d'emblée.
- Le snapshot de contenu v1 (`content_v1.json` + GIF) est embarqué dans
  `assets/content/` et seed SQLite au premier lancement.

## Point de départ visuel

Wireframe Claude Design :
https://claude.ai/code/artifact/2791af21-480b-4aaf-b23d-2eab73a41698

Vérifié contre le catalogue réel (§02) : les 8 jeux, slugs, emojis, couleurs
et 28 catégories du wireframe sont conformes. Les 14 cartes/catégorie qu'il
contient sont un échantillon de prototypage, pas le volume réel (~1 521 cartes
annoncées, décompte exact à produire par `scripts/verify-migration.ts`).
