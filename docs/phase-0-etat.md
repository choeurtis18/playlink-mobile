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

## 2. Outillage local — ✅ validé par un build réel

| Outil | État | Note |
|-------|------|------|
| Flutter 3.47.2 / Dart 3.13.2 | ✅ | via Homebrew |
| Android SDK 36 + build-tools 36.0.0 | ✅ | plateformes 33 à 36 |
| Xcode 26.6 + runtime iOS 26.5 | ✅ | simulateur disponible |
| CocoaPods 1.17.0 | ✅ | installé via `brew install cocoapods` |
| Node 23.9 / pnpm 10.14 | ✅ | |
| Vercel CLI | ✅ | |
| GitHub CLI (`gh`) | ❌ | absent — pas bloquant |

**Validation** : un projet Flutter jetable a été construit pour les deux
plateformes, hors du repo.

    flutter build apk --debug          → ✓ app-debug.apk
    flutter build ios --simulator      → ✓ Runner.app

Gradle a téléchargé et accepté le NDK r28c pendant le build Android, ce qui
confirme que les licences SDK sont opérationnelles.

### Faux négatif connu de `flutter doctor`

`flutter doctor` affiche en permanence :

    [!] Android toolchain
        ✗ Android license status unknown.
        Run `flutter doctor --android-licenses`

**C'est un faux négatif, à ignorer.** Google a remplacé `sdkmanager` par une
nouvelle CLI (`android sdk`) qui n'expose plus aucune commande de licences —
l'acceptation se fait désormais à l'installation des paquets. `sdkmanager`
survit comme alias mais refuse `--licenses`. Flutter n'a pas encore adapté sa
vérification ; il n'existe donc aucune commande capable de la satisfaire.

Les fichiers de licence sont bien présents dans
`~/Library/Android/sdk/licenses/`, et surtout : **le build Android passe**.
C'est le seul test qui compte. Ne pas perdre de temps à « corriger » cet
avertissement, il disparaîtra avec une future version de Flutter.

**Notes d'installation, si à refaire sur une autre machine :**

- CocoaPods : `brew install cocoapods`, **pas** `sudo gem install`. macOS
  embarque Ruby 2.6, alors que la dépendance `ffi` exige Ruby ≥ 3.0.
- Runtime du simulateur iOS : `xcodebuild -downloadPlatform iOS` (~7 Go).
- Plateforme Android 36 et cmdline-tools : via Android Studio,
  *Settings → Languages & Frameworks → Android SDK*.

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


---

# Phase 1 — journal

## Base legacy : contenu extrait ✅ (2026-09-06)

**Attention** : deux projets Supabase existent sur le compte. Le bon est
`jrxejcxirkottncvigll` — l'autre (`fccbwopkxapmxogdgtys`) refuse
l'authentification et ne contient pas le contenu Playlink.

Inventaire vérifié en base, qui **confirme le blueprint au chiffre près** :

| Table | Lignes |
|-------|--------|
| games | 8 |
| categories | 28 |
| cards | **1 521** (toutes actives) |
| game_rule_slides | 56 (toutes avec image) |
| badges | 5 |
| legal_contents | 3 |
| game_rules | 0 — *aucune règle markdown en base* |

Cartes par jeu — identique aux totaux du wireframe, ce qui le valide :

    Action ou Vérité 299 · Icebreaker 186 · Dégât Débat 200 · Qui de nous 229
    Mime 163 · Thé ou café 118 · Dilemme 156 · Devine le mot 170

Dump réalisé dans `scripts/dumps/playlink_content.sql` (297 Ko, gitignoré).

### Points relevés

- **`game_rules` est vide** : les règles markdown n'existent pas en base, seules
  les 56 slides illustrées sont présentes. Le §02 mentionne « règles markdown +
  slides » — à confirmer avec le produit : soit les règles vivent ailleurs
  (en dur dans le code web ?), soit elles sont à écrire.
- **56 slides, pas ~100 GIF** comme estimé au §06. Le poids embarqué sera donc
  plus léger que prévu.
- **5 badges en base** contre 12 proposés au §01 — les 7 nouveaux sont à créer
  au back-office, leurs règles étant du code Dart.
- Client PostgreSQL 17 requis (`brew install postgresql@17`) : le client 14
  refuse un serveur 17. Binaires dans `/opt/homebrew/opt/postgresql@17/bin`.
- Les valeurs du `.env` contenant `&` ou `?` doivent être entre guillemets,
  sinon le parsing shell casse silencieusement.

## Assets

Les GIF sont dans un bucket **public** Supabase Storage :

    https://jrxejcxirkottncvigll.supabase.co/storage/v1/object/public/game-assets

Renseigné dans `LEGACY_ASSETS_BASE_URL`. Public, donc téléchargeable sans clé —
`scripts/fetch-assets.ts` n'aura pas besoin d'authentification.

## Neon + Vercel ✅

Projet Neon provisionné via la Marketplace Vercel (région `eu-central-1`),
`DATABASE_URL` et `DIRECT_URL` injectées. Le `.env.local` du back-office vient
d'un `vercel env pull`.

## Reste à fournir

- `BLOB_READ_WRITE_TOKEN` — créer un store Blob sur Vercel (Storage → Create → Blob)


---

# Phase 1 — TERMINÉE ✅ (2026-09-06)

## Livrable du blueprint

> « Le contenu Playlink est dans Neon, une version 1 est publiée, le snapshot
> JSON est téléchargeable »

**Atteint sans réserve.** Le snapshot est en ligne sur Vercel Blob public,
téléchargeable sans authentification en ~0,16 s, et `GET /content/latest`
pointe dessus.

## Ce qui existe

| Élément | État |
|---|---|
| Schéma cloud Prisma (25 tables) | ✅ appliqué sur Neon |
| Migration du contenu | ✅ 11 contrôles, aucun écart |
| Assets | ✅ 55 fichiers, 13 Mo |
| Snapshot v1 | ✅ 0,32 Mo, validé par Zod |
| `GET /content/latest` | ✅ testé en HTTP réel |
| Snapshot sur Blob public | ✅ https://9jift8umwaqz1iep.public.blob.vercel-storage.com/content/content_v1.json |
| Auth éditeurs (Clerk) | ✅ redirection vérifiée |
| Back-office (7 pages) | ✅ CRUD complet |

## Chiffres réels (mesurés, pas estimés)

    8 jeux · 28 catégories · 1 521 cartes actives · 56 slides · 5 badges

    Intensité   1: 241 · 2: 306 · 3: 388 · 4: 351 · 5: 235
    Snapshot    0,32 Mo   (blueprint : 2-4 Mo)
    Assets      13 Mo     (blueprint : ~30 Mo pour ~100 GIF)

L'app pèsera donc ~15 Mo, loin des 45-60 Mo annoncés au §06.

## Écarts au blueprint constatés

1. **`game_rules` vide** — les règles vivent entièrement dans les 56 slides
   illustrées. Confirmé produit. Table non migrée.
2. **56 slides, pas ~100 GIF.**
3. **5 badges en base contre 12 proposés** au §01. Les 7 manquants sont
   listés dans la page Badges du back-office avec leur règle prévue.
4. **Emojis différents** : la base porte 🔥 Dégât Débat, 👀 Qui de nous,
   💬 Thé ou café. La base fait foi, le blueprint était approximatif.
5. **Deux projets Supabase** existent ; seul `jrxejcxirkottncvigll` porte
   le contenu.

## Reste à faire avant la phase 5

- Le back-office est en **lecture seule** : l'édition, l'import/export CSV et
  le bouton « Publier » sont prévus phase 5 (§12). La publication se fait
  aujourd'hui en ligne de commande.

## Commandes

    pnpm --filter @playlink/scripts migrate:content   # --dry-run pour simuler
    pnpm --filter @playlink/scripts verify            # 11 contrôles
    pnpm --filter @playlink/scripts fetch:assets
    pnpm --filter @playlink/scripts build:snapshot
    pnpm --filter @playlink/scripts publish:release -- --version 1 --local
    pnpm backoffice:dev

## Sécurité — action en attente

Le mot de passe de la base Supabase de prod et la `SUPABASE_SERVICE_KEY` ont
circulé en clair dans une conversation. Le dump étant fait, **les faire
tourner** : Settings → Database → Reset password, et Settings → API →
Rotate JWT, puis redéployer l'app web avec les nouvelles valeurs.
