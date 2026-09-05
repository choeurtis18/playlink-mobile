# Phase 0 — État des fondations

Dernière mise à jour : 2026-09-05

Suit le §12 du blueprint. Ce fichier consigne ce qui est fait, ce qui reste, et
les **écarts par rapport au blueprint** à arbitrer.

---

## 1. Structure du monorepo — ✅ fait

    playlink-mobile/
    ├── apps/mobile          (phase 2)
    ├── apps/backoffice      (phase 1)
    ├── packages/content-schema (phase 1)
    ├── scripts/             (phase 1)
    ├── docs/                blueprint + notes de phase
    ├── CLAUDE.md            résumé opérationnel (copie du §14)
    ├── package.json · pnpm-workspace.yaml · .npmrc
    └── .env.example         checklist des clés à fournir

Repo GitHub : `github.com/choeurtis18/playlink-mobile` (compte perso).

## 2. Outillage local

| Outil | État | Note |
|-------|------|------|
| Flutter 3.47.2 / Dart 3.13.2 | ✅ | via Homebrew |
| Android Studio + SDK 35 | ⚠️ | `cmdline-tools` manquant, licences non acceptées |
| Xcode.app | ⚠️ | `xcode-select` pointe encore sur les Command Line Tools |
| CocoaPods | ❌ | absent — requis pour les plugins Flutter iOS |
| Node 23.9 / pnpm 10.14 | ✅ | |
| Vercel CLI | ✅ | |
| GitHub CLI (`gh`) | ❌ | absent — pas bloquant |

**Trois commandes restent à lancer** (demandent `sudo` ou une interaction, donc
non exécutées automatiquement) :

    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch
    sudo gem install cocoapods

Puis, côté Android (accepte les licences SDK de façon interactive) :

    flutter doctor --android-licenses

Le composant `cmdline-tools` s'installe depuis Android Studio :
*Settings → Languages & Frameworks → Android SDK → SDK Tools →
Android SDK Command-line Tools*.

Vérifier ensuite avec `flutter doctor`.

> Ni Xcode ni Android Studio ne sont nécessaires avant la **phase 2**. La phase 1
> (back-office) ne demande que Node + pnpm.

## 3. Comptes de services

Tous rattachés à **gamesplaylink@gmail.com**, sauf GitHub (compte perso).

| Service | État | À fournir |
|---------|------|-----------|
| Neon | ✅ créé — projet `empty-mode-79328479`, branche `production` | `DATABASE_URL`, `DIRECT_URL` |
| Clerk | ✅ créé | `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`, `CLERK_SECRET_KEY` |
| PostHog EU | ✅ créé | `NEXT_PUBLIC_POSTHOG_KEY` |
| Vercel + Blob | ❌ **pas créé** | à ouvrir sur gamesplaylink@gmail.com |
| Apple Developer | ⏸️ reporté en phase 6 | — |
| Google Play Console | ⏸️ reporté en phase 6 | — |

Les clés se remplissent dans un `.env` local (jamais commité), sur le modèle de
`.env.example`.

---

## Écarts par rapport au blueprint — à arbitrer avant la phase 1

### ① Neon créé en direct, pas via la Marketplace Vercel

Le blueprint (§03) prévoit `vercel integration add neon`, ce qui donne :
injection automatique de `DATABASE_URL`, et **une branche de base de données par
preview deploy**. Le projet Neon actuel a été créé directement sur neon.tech.

Deux voies :

- **Relier manuellement** — coller `DATABASE_URL` dans les variables Vercel.
  Simple, mais on perd les branch DB par preview et l'injection auto.
- **Reprovisionner via la Marketplace** — à faire tant que la base est vide,
  c'est-à-dire **maintenant**, avant la migration du contenu. Après, ça
  impliquerait de re-migrer.

> Le moment de décider est avant la phase 1 : une fois le contenu importé,
> changer de projet Neon coûte une re-migration.

### ② Apple Developer reporté en phase 6

Décision assumée. Le blueprint (§15) note que la validation Apple prend parfois
plusieurs jours — si elle traîne, elle décalera d'autant la mise en magasin.
Aucun impact sur les phases 1 à 5.

### ③ Vercel pas encore créé

Nécessaire dès la phase 1 (déploiement du back-office, Blob, crons). À ouvrir
sur gamesplaylink@gmail.com.

---

## Ce dont j'ai besoin pour démarrer la phase 1

1. Compte **Vercel** créé, et arbitrage sur Neon (écart ① ci-dessus).
2. Les clés à coller dans `.env` (Neon, Clerk, PostHog, Blob).
3. **Accès lecture à la Supabase de prod** — URL de connexion directe, port 5432
   (`LEGACY_SUPABASE_DIRECT_URL`) pour le `pg_dump` du contenu.
4. L'emplacement des **~100 GIF** de règles : URL de base ou dossier.

---

## Vérification du wireframe contre le catalogue réel

Wireframe : https://claude.ai/code/artifact/2791af21-480b-4aaf-b23d-2eab73a41698

Contrôlé contre le §02 du blueprint — **conforme** :

- 8 jeux, mêmes slugs, mêmes emojis
- Couleurs `main`/`sec` identiques (ex. Action ou Vérité `#7C3AED` → `#EC4899`)
- 28 catégories, mêmes noms, même répartition (6/3/3/4/3/3/3/3)
- Les renommages sont bien pris en compte : *Qui de nous* (ex-Balance Ton Pote),
  *Mime* (ex-Mime Inversé), et *Thé ou café* est présent. *Roland Gamos* absent,
  comme attendu.

**Réserve** : le wireframe embarque 14 cartes par catégorie — un échantillon de
prototypage. Les totaux qu'il annonce par jeu somment à **1 521 cartes**
(cohérent avec le « ~1 600 » du §02). Le décompte exact doit venir de
`scripts/verify-migration.ts` au moment de l'import, pas de ce fichier.

**Réserve de fond** : le wireframe s'appuie sur un cadre iOS 26 (liquid glass).
La direction visuelle du §10 est *sombre-first avec accents colorés par jeu* —
c'est elle qui prime en cas de divergence. Le wireframe est un point de départ,
pas une maquette figée.

## Mécaniques de jeu à concevoir (rappel §02)

Trois jeux dépassent le simple swipe et demandent des écrans propres en phase 2 :

- **Qui de nous** — désignation collective d'un joueur, pas un vote binaire
- **Thé ou café** — duel binaire itératif jusqu'à converger vers le mot
- **Devine le mot** — compteur « 3 indices max » + fin de tour anticipée

Les cinq autres (Mime, Action ou Vérité, Icebreaker, Dégât Débat, Dilemme) sont
un portage direct du flux de carte swipeable.
