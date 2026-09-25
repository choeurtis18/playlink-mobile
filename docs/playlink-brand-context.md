# Playlink — Contexte de marque & produit

> Document de référence pour le projet Claude "Playlink". Sert de socle à tous les
> chats de ce projet : génération de cartes, création d'assets visuels, visuels et
> vidéos promotionnelles, réflexion produit, identité de marque, marketing.
> Ne pas confondre avec `docs/playlink-mobile-blueprint.html`, qui documente
> l'architecture technique de l'app mobile — ce document-ci documente la marque,
> le contenu et le design, pour un usage créatif et non technique.

---

## 1. Qu'est-ce que Playlink

Playlink est une app de jeux de societé/cartes à jouer entre amis, en soirée,
autour d'un seul téléphone qu'on se passe (pass-and-play). Pas d'écran par
joueur, pas de compte obligatoire, pas besoin de réseau : on lance l'app et on
joue, tout de suite.

- **Format** : 8 jeux, chacun avec ses catégories et ses cartes. On choisit un
  jeu, une catégorie, une intensité (1 à 5), et l'app tire un deck de 10 cartes.
- **Origine** : née comme app web (Next.js), aujourd'hui portée en app mobile
  native (Flutter, iOS + Android), 100 % jouable hors-ligne.
- **Modèle économique** : gratuite en V1, pas de paiement. Le freemium
  (abonnement par catégorie/intensité) est préparé techniquement mais pas
  activé — n'en parler dans le marketing qu'en filigrane ("plus de contenu à
  venir"), jamais comme une promesse ferme de date.

## 2. Cible

- **Âge** : 16–35 ans, cœur de cible 18–30 ans.
- **Contextes d'usage** : soirées entre amis, apéros, pré-soirée avant de
  sortir, voyages entre potes, soirées en couple. L'app doit se sentir à sa
  place aussi bien dans un appart entre potes qu'en road trip.
- **Profils** : groupes d'amis mixtes, couples, parfois groupes qui se
  connaissent peu (icebreaker). Pas une cible familiale, pas un jeu pour
  enfants — certaines catégories sont explicitement "spicy"/intimes.
- **Ce qu'ils cherchent** : rire, se surprendre entre potes, sortir des
  banalités de conversation, un truc qui lance vraiment la soirée sans
  demander de préparation (pas de matériel, pas de règles à lire en détail).

## 3. Identité de marque

### Nom et logo
- **Nom** : Playlink (un seul mot, P et L majuscules dans "Play**link**" à
  l'écrit stylisé — le logo isole "link" en couleur).
- **Logo** : un éventail de 4 cartes arrondies en dégradés de couleur
  (vert émeraude, bleu cyan, rose/bordeaux, violet→rose), légèrement
  décalées en éventail comme une main de cartes qu'on vient de recevoir.
  Traduit directement le produit (des cartes) et la diversité des jeux
  (chaque carte = une couleur = un jeu différent).
- Fichier de référence : `assets/Logo.svg` (mobile) /
  `packages/app/public/playlink-logo.svg` (web).

### Ton de voix
Le ton de marque est déjà bien établi dans les textes de jeux/catégories
existants (voir §5). Caractéristiques à reproduire dans tout futur contenu
marketing, cartes ou UX :

- **Direct et mordant** — phrases courtes, punchy, qui vont droit au but.
  Pas de tournures corporate, pas de smiley en excès.
- **Complice, jamais moralisateur** — parle à un groupe d'amis comme un ami
  qui les chambre gentiment, pas comme une marque qui vend un produit.
- **Un peu provocateur, jamais vulgaire** — flirte avec la ligne rouge sans
  jamais la franchir. L'humour vient de la situation sociale (la gêne, la
  franchise, la comparaison entre potes), pas de vulgarité gratuite.
- **Formules choc en fin de phrase** — beaucoup de textes marketing/produit
  se terminent sur une pointe : *"Bon courage."*, *"Prépare-toi à y laisser
  ta crédibilité."*, *"Personne ne juge personne."* C'est une signature de
  style à réutiliser.
- **Tutoiement systématique**, à l'utilisateur comme aux joueurs dans les
  cartes.
- **FR = langue de référence** de la marque et du contenu ; l'anglais est une
  traduction seconde, jamais la langue d'origine du ton.

Exemples représentatifs du ton (textes produit réels, à utiliser comme
étalon) :

> *"Le jeu qui a brisé plus d'amitiés que les groupes WhatsApp. Tu choisis :
> avouer, ou assumer."* — Action ou Vérité

> *"Deux heures de banalités ou une carte bien placée. [...] Idéal en début
> de soirée, redoutable à 2h du matin."* — Icebreaker

> *"« Qui de nous… ? » la question la plus dangereuse jamais posée entre
> amis. [...] Bon courage."* — Qui de nous

> *"Pas un mot, pas un son, pas d'excuse. [...] la certitude que quelqu'un va
> filmer."* — Mime

### Ce que la marque n'est pas
- Pas une app "familiale" au sens large public (pas d'ambiguïté à avoir sur
  les catégories spicy/flirt : elles existent et sont assumées).
- Pas une identité "gaming" (pas de jargon esport, pas d'imagerie néon
  cyberpunk) — l'univers visuel est plus proche d'un carnet de soirée premium
  que d'un jeu vidéo.
- Pas minimaliste-corporate : la marque est colorée, vivante, un peu
  irrévérencieuse — pas une app utilitaire neutre.

## 4. Direction visuelle & design system

Référence complète : `docs/playlink-mobile-blueprint.html` §10 (direction
visuelle "ambiance Netflix"). Résumé pour usage créatif/marketing :

### Principe général
- **Fond sombre en base, partout** — pas un gris neutre : un noir légèrement
  teinté indigo (`#0B0A0F`, plus profond `#060509`), chaleureux plutôt que
  froid. C'est le socle par défaut de toute l'identité visuelle, y compris
  pour les visuels promo. Un mode clair existe en option dans l'app mais
  n'est jamais le défaut ni la vitrine.
- **Chaque jeu a son propre dégradé de couleur** (`colorMain` → `colorSecondary`),
  utilisé comme accent vif posé sur le fond sombre — jamais en fond plein
  écran généraliste. C'est la couleur du jeu qui doit "sortir" du noir, comme
  une affiche de film sur un fond de catalogue sombre.
- **Interactions premium** : tuiles qui répondent au tap par un scale léger
  (~1.04–1.06) + une ombre portée colorée (glow) reprenant la couleur du jeu.
  Jamais un simple aplat gris ou une opacité plate.
- **Transitions à fort enjeu émotionnel seulement** (ex. l'ouverture d'un jeu,
  la fin de partie) méritent une animation marquée (type shared-element /
  Hero) — pas de sur-animation généralisée.

### Palette technique (tokens du blueprint)
| Rôle | Valeur |
|---|---|
| Fond principal | `#0B0A0F` |
| Fond profond | `#060509` |
| Surface | `#17151D` |
| Surface élevée | `#1F1C27` |
| Texte principal | `#F3F1EC` |
| Texte secondaire | `#C7C2D1` |
| Accent principal (marque) | `#F23A6B` → `#FF6B93` |
| Bleu (accent secondaire) | `#4FA0F5` |
| Succès | `#4FCE87` |
| Attention | `#F5A94E` |
| Danger | `#FF6259` |

### Typographie (du blueprint, transposable aux visuels promo)
- **Titres / display** : Fraunces (serif à forte personnalité, chaleureuse,
  éditoriale) — donne le ton "carnet premium" plutôt que "app générique".
  Utile pour les titres de posts, cover d'assets, packaging visuel.
- **Texte courant / UI** : Inter Tight (sans-serif, moderne, lisible).
- **Mono / accents techniques, labels, chiffres** : JetBrains Mono, en petites
  capitales espacées pour les kickers/labels (ex. "SOIRÉE · APÉRO · VOYAGE").

## 5. Les 8 jeux

Chaque jeu a un nom, une couleur, un emoji/icône, et un pitch déjà écrit dans
le ton de marque (à reprendre tel quel ou à décliner, pas à réinventer à
partir de zéro). Descriptions et couleurs à jour au 24/09/2026 (export
back-office le plus récent — source de vérité pour le contenu produit).

### 🎯 Action ou Vérité
`#DC2626 → #761414` (rouge → bordeaux sombre)
> Le jeu qui a brisé plus d'amitiés que les groupes WhatsApp. Tu choisis :
> avouer, ou assumer. Six catégories pour doser toi-même la température, du
> fou rire garanti au silence gênant dont tout le monde reparlera pendant des
> mois.

Catégories : Vérités légères, Vérités Flirt, Vérités Spicy, Actions Rigolote,
Actions Flirt, Actions Spicy — 6 paliers d'intensité croissante, en deux
familles parallèles (Vérité / Action).

### 🧊 Icebreaker
`#23B5F7 → #156A91` (bleu ciel → bleu profond)
> Deux heures de banalités ou une carte bien placée. Icebreaker saute la
> météo et les « t'as fait quoi ce week-end » pour aller direct là où les
> vraies conversations commencent. Idéal en début de soirée, redoutable à 2h
> du matin.

Catégories : Pour se découvrir, Cœur à Cœur, Deep Talk — progression du léger
vers l'introspectif.

### 🔥 Dégât Débat
`#F97316 → #93440D` (orange → brun rouille)
> Une question, plusieurs camps, aucun consensus. Chacun défend sa position à
> voix haute pendant que la table se scinde sur des sujets qu'on évite
> soigneusement au repas de famille.

Catégories : Société, Perso et Relations, Éthique et Morale.

### 👀 Qui de nous
`#10B981 → #07533A` (vert émeraude → vert profond)
> « Qui de nous… ? » la question la plus dangereuse jamais posée entre amis.
> Le groupe désigne, la majorité tranche, et personne ne se cache derrière un
> vote anonyme. Tu vas enfin savoir ce que tes potes pensent vraiment de toi.
> Bon courage.

Catégories : Personnalité, Désir et Attirance, Taquineries, Secrets et
Confessions.

### 🎭 Mime
`#F59E0B → #216FB7` (ambre → bleu)
> Pas un mot, pas un son, pas d'excuse. Un joueur mime, le groupe devine, le
> chrono s'en fout de ta dignité. Trois catégories, des dizaines de mots à
> faire passer uniquement avec ton corps et la certitude que quelqu'un va
> filmer.

Catégories : Objets du quotidien, Actions, Métiers.

### 💬 Thé ou café
`#7C3AED → #EC4899` (violet → rose)
> Un joueur voit le mot, les autres n'ont qu'une arme : deux propositions à
> la fois. « Thé ou café ? » — il répond celle qui s'en rapproche le plus, et
> le duel recommence, encore et encore, jusqu'à ce que le groupe tombe pile
> sur le mot. Un entonnoir sémantique redoutablement frustrant.

Catégories : Facile, Moyen, Difficile.

### ⚖️ Dilemme
`#696A6B → #CDCFD1` (gris neutre → gris clair)
> Deux options. Aucune bonne. Et impossible de botter en touche : tu
> choisis, puis tu justifies devant tout le monde. Pas de score, pas de
> gagnant — juste une table qui découvre qui tu es vraiment quand il n'y a
> plus d'échappatoire.

Seul jeu à sortir de la logique "couleur vive par jeu" : le gris neutre
souligne qu'il n'y a "pas de bonne réponse", cohérent avec le pitch.

Catégories : Absurde et Fun, Relations et Société, Identité et Valeurs.

### 🕵️ Devine le mot
`#BE185D → #580B2B` (rose bordeaux → bordeaux très sombre)
> Tu tires un mot que personne d'autre ne voit, et tu dois le faire deviner
> à la table. Trois indices maximum, pas un de plus. Moins tu en donnes,
> plus tu es fort — mais un indice mal choisi et tu brûles ton tour pour
> rien.

Catégories : Objets et Lieux, Personnages et Culture, Abstrait et
Expressions.

## 6. Mécaniques de jeu (pour comprendre le contenu à générer)

- **Deck** : chaque partie tire 10 cartes (par défaut), pondérées par
  l'intensité choisie (1 à 5) — plus une carte est proche de l'intensité
  visée, plus elle a de chances d'être tirée, mais aucune carte n'est jamais
  totalement exclue.
- **Intensité des cartes** : chaque carte porte un niveau d'intensité (1 à
  5, le même barème que le réglage de partie) — pas une "difficulté" au
  sens easy/medium/hard. C'est ce niveau qui pondère le tirage du deck
  (voir ci-dessus). Utilisé différemment par jeu (ex. dans Action ou Vérité
  c'est un curseur de gêne/intimité ; dans Thé ou café / Devine le mot un
  curseur d'abstraction du mot à deviner).
- **Tags** : chaque carte a 2-4 tags thématiques (ex. `amitié`, `souvenir`,
  `humour`, `secret`) qui servent aussi à calculer un archétype de joueur
  en fin de partie ("Le Clown de service", "L'Énigmatique"...).
- **Pass-and-play** : un seul téléphone, on se le passe entre joueurs. Le
  jeu affiche "C'est à ton tour" avant de révéler la carte, pour éviter que
  les autres la voient avant.
- **Vote / score** : après chaque carte, le groupe vote si le joueur mérite
  un point. Scores cumulés sur plusieurs parties, badges et classement
  "entre potes" (jamais un classement mondial).

### Ce que ça implique pour générer de nouvelles cartes
- Rester dans le ton établi (§3) — punchy, direct, qui vise une vraie
  réaction du groupe (rire, gêne, débat, révélation).
- Respecter le jeu et la catégorie ciblés : une carte "Devine le mot"
  n'est qu'un mot/expression à faire deviner (pas de phrase) ; une carte
  "Mime" est un mot/expression à mimer ; une carte "Dilemme" présente
  toujours deux options mutuellement exclusives ("Plutôt X ou Y ?") ; une
  carte "Qui de nous" commence par "Qui de nous..." ou "Qui est..." et
  désigne quelqu'un à la table.
- Adapter l'intensité à la catégorie visée (ex. "Vérités Spicy" doit être
  nettement plus osé que "Vérités légères", jamais l'inverse).
- Cartes courtes — une à deux phrases maximum, jamais un paragraphe.
- Cible 16-35 ans : références culturelles, humour et niveau de langue
  doivent parler à cette tranche d'âge, sans tomber dans un jargon "ado"
  qui daterait vite.

## 7. Emplacement des sources de contenu

Pour un chat qui a besoin d'aller plus loin que ce résumé (ex. générer un
lot de cartes cohérent avec l'existant, vérifier qu'un thème n'est pas déjà
couvert) :

- Catalogue complet jeux + catégories : dossier `PLAYLINK - Workspace/Cartes
  - Catégories/`, fichier `Playlink Jeux Sep 24 2026.csv` (le plus à jour —
  couleurs et descriptions jeux + catégories en un seul export).
- Cartes existantes par jeu : `playlink-v2/Cartes - Catégories/<Jeu>/*.csv`
  (un CSV cartes + un CSV catégories par jeu — colonnes `id, categoryId,
  text, intensité, tags, active, order` ; ces exports datent de juin 2026,
  vérifier le nom exact de la colonne d'intensité dans un export récent
  avant de s'y fier).
- Blueprint technique complet (architecture, data model, offline, workflows
  détaillés) : `playlink-mobile/docs/playlink-mobile-blueprint.html`.
