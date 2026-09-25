# Cahier de recette — Playlink Mobile

État au 16/09/2026. Couvre tout ce qui est **construit et testable manuellement**
aujourd'hui : Phases 0 à 3 (fondations, back-office, jeu offline, progression
locale). Les phases 4 à 6 (compte, communauté, stores) ne sont pas commencées —
voir « Ce qui reste à développer » en fin de document.

Coche chaque case au fur et à mesure. Pour un bug, note l'écran, l'action
exacte et ce qui s'est passé — donne-moi ça et je regarde.

---

## 0. Avant de commencer

### Lancer l'app mobile

```
cd apps/mobile
flutter run
```

Choisis un simulateur iOS ou un appareil Android connecté si plusieurs
cibles sont proposées. Le premier lancement seed la base locale depuis le
contenu embarqué (1521 cartes, 8 jeux, 12 badges) — ça prend quelques
secondes, écran de démarrage « Playlink ».

### Accéder au back-office

URL de production : **https://playlink-backoffice.vercel.app**

Connexion éditeur via Clerk (compte `gamesplaylink@gmail.com` ou celui que
tu as configuré). C'est un compte **éditeur**, distinct des joueurs de
l'app — aucun lien entre les deux pour l'instant.

---

## 1. Back-office — CRUD de contenu

### 1.1 Connexion
- [ ] Aller sur l'URL du back-office sans être connecté → redirigé vers `/sign-in`.
- [ ] Se connecter → arrive sur le back-office, plus de redirection.

### 1.2 Jeux (`/jeux`)
- [ ] La liste affiche les 8 jeux : Action ou Vérité, Icebreaker, Dégat Débat,
  Qui de nous, Mime, Thé ou café, Dilemme, Devine le mot.
- [ ] Ouvrir un jeu, modifier son nom ou sa description, enregistrer →
  le changement est visible en revenant sur la liste.
- [ ] Modifier les couleurs (`colorMain`/`colorSecondary`) d'un jeu →
  visible plus tard dans l'app une fois republié (§1.6).
- [ ] Créer un nouveau jeu de test → apparaît dans la liste, une catégorie
  peut lui être rattachée (§1.3).
- [ ] Supprimer ce jeu de test → disparaît de la liste.

### 1.3 Catégories (`/categories`)
- [ ] La liste affiche les catégories groupées par jeu.
- [ ] Créer une catégorie sur un jeu existant → apparaît dans la liste.
- [ ] Modifier le nom d'une catégorie → changement visible.
- [ ] Essayer de créer une catégorie avec un slug déjà utilisé sur le même
  jeu → message d'erreur clair (pas juste un code Prisma brut).

### 1.4 Cartes (`/cartes`)
- [ ] La liste affiche les cartes, filtrable par jeu/catégorie.
- [ ] Créer une carte (texte + intensité 1-5 + tags) → apparaît dans la
  liste de sa catégorie.
- [ ] Modifier le texte d'une carte existante → enregistré.
- [ ] Désactiver une carte (`active` off) → n'apparaît plus dans le compte
  de cartes actives affiché ailleurs (page Publication notamment).
- [ ] **Export CSV** : cliquer sur « Export CSV » → un fichier se
  télécharge avec les cartes.
- [ ] **Import CSV** (page `/publication`) : importer un petit CSV de
  cartes → message « N cartes importées », les cartes apparaissent dans
  `/cartes`.

### 1.5 Règles (`/regles`)
- [ ] Chaque jeu a des slides de règles (titre, texte, image).
- [ ] Modifier le texte d'une slide → enregistré.
- [ ] Réordonner les slides (si un contrôle de tri existe) → l'ordre change.

### 1.6 Badges (`/badges`)
- [ ] La liste affiche les 12 badges : Première victoire, Légende de
  soirée, Papillon social, Chercheur de vérité, Triplé, Explorateur,
  Oiseau de nuit, Auteur, Polyglotte, Curateur, Centurion, Marathonien.
- [ ] Modifier la description d'un badge → enregistré (rappel : la **règle**
  d'attribution est codée dans l'app mobile, le back-office ne modifie que
  les métadonnées — nom/description/icône).

### 1.7 Traductions (`/traductions`)
- [ ] La page liste le contenu sans traduction anglaise (carte, catégorie,
  slide…).
- [ ] Ajouter une traduction EN sur une carte → elle disparaît de la liste
  des manquants.

### 1.8 Publication (`/publication`)
- [ ] La page affiche la version courante publiée et le nombre de cartes
  actives.
- [ ] Après une modification de contenu (§1.2 à §1.6), un indicateur de
  changements en attente apparaît.
- [ ] Publier une nouvelle version → nouvelle ligne dans l'historique des
  versions, avec la date.
- [ ] `GET /content/latest` (visible dans l'historique ou en requêtant
  l'URL directement) renvoie bien la dernière version publiée.

---

## 2. App mobile — Démarrage et onboarding

- [ ] Premier lancement (désinstaller l'app ou vider les données avant si
  déjà testée) → écran de démarrage « Playlink », puis onboarding.
- [ ] Onboarding : 3 écrans (comment jouer, pas de compte requis,
  consentement stats), bouton « Suivant » à chaque étape.
- [ ] Toggle « Partager des stats anonymes » → togglable, aucun blocage
  quel que soit le choix.
- [ ] « Commencer » → arrive sur l'écran « Qui joue ce soir ? ».
- [ ] Fermer et relancer l'app → l'onboarding ne réapparaît pas, direct sur
  la home (ou l'écran joueurs si aucun joueur en session).

---

## 3. App mobile — Joueurs

Écran « Qui joue ce soir ? » (premier lancement) et modale « Modifier »
depuis la home (même comportement aux deux endroits).

- [ ] Taper un prénom + bouton « + » → le joueur apparaît dans la liste
  avec son avatar.
- [ ] Ajouter un 2e joueur avec le **même prénom** (même casse ou pas) →
  message « {nom} joue déjà ce soir », refusé.
- [ ] Retirer un joueur qui n'a **jamais joué** (bouton ×) → disparaît
  complètement de la liste.
- [ ] Jouer une partie complète avec un joueur, puis le retirer (×) →
  disparaît de la session, mais reste dans le classement (§5).
- [ ] Retaper le prénom d'un joueur retiré (qui a déjà un historique) →
  une feuille propose « Ajouter {nom} » (récupère ses stats) ou « Non,
  créer un nouveau profil » (demande un nom différent).
- [ ] Taper sur une tuile joueur (pas le ×) → ouvre « Modifier {nom} » :
  changer le prénom, changer l'emoji (12 choix), enregistrer → visible
  immédiatement dans la liste.
- [ ] Essayer de renommer un joueur avec le prénom d'un **autre** joueur
  existant → message d'erreur, pas d'écrasement silencieux.
- [ ] « C'est parti » désactivé tant qu'aucun joueur n'est ajouté.

---

## 4. App mobile — Jouer une partie (les 8 jeux)

Répète ce scénario pour **au moins 3 jeux différents** parmi les 8 (idéal :
les 8, au moins une fois chacun pendant toute la recette — ça sert aussi à
débloquer le badge Explorateur, voir §6).

- [ ] Home : les 8 jeux sont affichés en grille, chacun avec son icône, son
  dégradé de couleur, le nombre de catégories.
- [ ] Ouvrir un jeu → bandeau dégradé avec icône/nom/nombre de catégories,
  bouton retour, bouton « Règles ».
- [ ] Bouton « Règles » → modale avec les slides d'explication, image fixe
  en haut, texte qui scrolle, flèches ‹/› et pagination en bas.
- [ ] Choisir une catégorie → écran config : aperçu d'une carte, intensité
  (5 niveaux), nombre de cartes par partie (5/10/15/20).
- [ ] Changer l'intensité → la carte d'aperçu change et correspond à
  l'intensité choisie (revenir sur une intensité déjà vue affiche la
  **même** carte, pas une nouvelle à chaque fois).
- [ ] « Lancer la partie » → écran « C'est à ton tour ! » avec l'avatar du
  premier joueur qui pulse doucement.
- [ ] « Voir la carte » → la carte s'affiche avec son texte, dégradé du
  jeu, catégorie en badge.
- [ ] Voter Oui/Non → le score change, passage à la carte suivante ou au
  joueur suivant.
- [ ] Avec 2+ joueurs : écran « Passe le téléphone à {nom} » entre chaque
  tour — fond dégradé plein écran, icône téléphone qui vibre, bouton
  « C'est moi, {nom} → ».
- [ ] Jeu « Devine le mot » : vérifier que le système d'indices fonctionne
  (3 indices max, compteur qui descend).
- [ ] Terminer une partie complète (toutes les cartes votées) → écran
  résultats : podium (2e-1er-3e), scores, archétype de chaque joueur.
- [ ] Si un badge se débloque à ce moment (ex. Première victoire à la
  toute première partie) → modale « Félicitations ! » avant l'écran de
  résultats, avec le nom et l'icône du badge.
- [ ] Résultats : « Rejouer » → retour à la page catégorie du même jeu
  (pas directement la config). « Accueil » → retour home, scores
  conservés.
- [ ] Quitter une partie en cours (bouton X en haut à gauche pendant le
  jeu) → confirmation demandée avant d'abandonner.

---

## 5. App mobile — Classement (onglet bottom nav)

- [ ] Onglet « Classement » → liste des profils de l'appareil, triés par
  score total décroissant, avec médaille pour le podium (1er/2e/3e).
- [ ] Chaque ligne affiche : avatar, nom, archétype, score total, nombre
  de parties.
- [ ] Taper sur un joueur dans la liste → ouvre la feuille « Modifier »
  (même comportement que sur l'écran joueurs, §3).
- [ ] Un joueur retiré de la session mais ayant déjà joué **reste visible**
  ici avec ses stats à jour.
- [ ] Aucun joueur enregistré → message invitant à ajouter des joueurs.

---

## 6. App mobile — Badges (Profil → Badges)

- [ ] Grille 2 colonnes : badges débloqués (icône colorée, date de
  déblocage) et verrouillés (grisés, condition affichée en clair).
- [ ] Vérifier qu'au moins ces badges sont atteignables sans trop d'efforts
  pendant la recette :
  - [ ] **Première victoire** — dès le premier point marqué.
  - [ ] **Explorateur** — une partie dans chacun des 8 jeux.
  - [ ] **Triplé** — gagner 3 parties d'affilée avec le même joueur.
  - [ ] **Polyglotte** — jouer une partie en FR, une en EN (§8 pour changer
    la langue).
  - [ ] **Auteur** — créer 5 cartes personnalisées (§7).
- [ ] Les badges **Curateur** (likes) restent verrouillés en permanence
  pour l'instant — normal, la fonctionnalité de likes n'existe pas encore
  (Phase 5).

---

## 7. App mobile — Mes cartes (Profil → Mes cartes)

- [ ] Liste vide au départ → message « Aucune carte créée pour l'instant ».
- [ ] Bouton « + » → formulaire : jeu (menu déroulant), catégorie (menu
  déroulant, **doit être pré-rempli automatiquement** dès l'ouverture,
  pas vide), texte, « Enregistrer ».
- [ ] Créer une carte → apparaît dans la liste, active par défaut (switch
  vert à droite).
- [ ] Aller jouer une partie dans le jeu/catégorie choisis (§4) avec assez
  de cartes pour que le tirage ait une chance de la sortir (ou réduire le
  nombre de cartes par partie pour augmenter la probabilité) → la carte
  perso doit pouvoir apparaître dans la partie.
- [ ] Désactiver une carte (switch) directement depuis la liste → elle
  n'entre plus dans le pool de tirage, mais reste dans la liste « Mes
  cartes ».
- [ ] Taper sur une carte de la liste → ouvre « Modifier la carte » avec le
  texte pré-rempli, jeu/catégorie non modifiables à l'édition, toggle
  actif visible.
- [ ] Modifier le texte, enregistrer → changement visible dans la liste.
- [ ] Supprimer une carte (bouton dans le formulaire d'édition) →
  confirmation demandée, puis disparaît vraiment de la liste.

---

## 8. App mobile — Réglages (Profil → Réglages)

- [ ] Section Langue : Français / Anglais, sélection visible (pilule
  dégradée sur le choix actif).
- [ ] Basculer en anglais → **toute l'interface** change immédiatement
  (titres, boutons, labels) sans redémarrer l'app.
- [ ] Basculer en anglais puis rejouer une partie → les cartes affichées
  sont en anglais (ou en français avec un indicateur discret si la carte
  n'a pas de traduction — comportement de repli normal).
- [ ] Revenir en français.
- [ ] Section Thème : Clair / Sombre / Système.
- [ ] Basculer sur Clair → **toute l'app** passe en fond clair, texte
  sombre lisible partout (home, jeu, badges, profil, joueurs…) — pas
  seulement l'écran Réglages.
- [ ] Basculer sur Système → l'app suit le réglage clair/sombre de
  l'appareil (changer ce réglage dans les paramètres iOS/Android doit
  faire basculer l'app en direct).
- [ ] Revenir sur Sombre (thème par défaut).

---

## 9. App mobile — Profil et façade compte

- [ ] Écran Profil : bloc « Tout marche sans compte » avec bouton « Créer
  un compte » — **désactivé pour l'instant**, normal (Phase 4).
- [ ] Tuiles « Mes cartes » et « Badges » cliquables (§6, §7). Tuile
  « Cartes likées » **non cliquable** — normal, nécessite un compte
  (Phase 5).
- [ ] Sur la home : bouton « Se connecter » en haut à droite → tap →
  message « Bientôt disponible », le bouton devient « Devenir premium ».
  Retaper dessus → message à nouveau, le bouton disparaît (état
  « premium »). C'est une **façade de démonstration**, aucun vrai compte
  n'est créé — normal, à re-tester à chaque relance de l'app (l'état ne
  persiste pas entre sessions par design).

---

## 10. Comportements transverses à vérifier

- [ ] Mode avion activé sur l'appareil → l'app fonctionne intégralement
  (aucune action ne doit être bloquée par l'absence de réseau).
- [ ] Fermer complètement l'app en pleine partie, la rouvrir → au minimum,
  aucun crash ; le comportement attendu est de revenir à l'accueil (la
  reprise de partie en cours n'est pas garantie, ce n'est pas un bug).
- [ ] Naviguer beaucoup entre les écrans (jeu → règles → retour → config
  → retour → home) → jamais de bottom nav visible pendant un écran de
  jeu (page jeu, config, partie).
- [ ] Bouton retour matériel Android (si testé sur Android) → comportement
  cohérent avec les flèches retour à l'écran.

---

## 11. Landing (`apps/web`) — refonte en cours

Refonte par lots (voir le plan d'implémentation). Tester à 390 px (mobile),
820 px (tablette) et 1280 px (ordinateur). En local : `pnpm backoffice:dev`,
puis `BACKOFFICE_URL=http://localhost:3000 pnpm --filter @playlink/web dev -p 3001`.

### 11.1 Contenu depuis le back-office (lot 0)
- [ ] Modifier le titre du héros dans `/site` et enregistrer → le nouveau
  titre apparaît sur la landing **dans l'heure** (le site garde sa copie
  1 h) ; en local, redémarrer le site pour le voir tout de suite.
- [ ] Vider le titre EN au back-office → la version EN affiche le titre FR.
- [ ] Couper le back-office → la landing s'affiche quand même, avec les
  textes par défaut et le bon titre d'onglet.
- [ ] Une catégorie cochée « jouable » dont toutes les cartes dépassent
  l'intensité max (3 par défaut) n'apparaît pas dans la démo.

### 11.2 En-tête, menu et pied de page (lot 1)
- [ ] L'en-tête reste en haut en défilant ; une fine bordure apparaît dès
  qu'on quitte le haut de page ; la barre dégradée sous l'en-tête suit la
  progression du scroll.
- [ ] Clic sur « Jeux » / « Démo » → défilement doux, le titre de la
  section arrive juste sous l'en-tête (pas caché dessous).
- [ ] Sans lien Instagram/TikTok/Reddit au back-office → pas de lien
  « Réseaux » dans le menu.
- [ ] FR ↔ EN → l'adresse passe de `/fr` à `/en`, tous les textes changent.
- [ ] Sous 900 px : burger à droite ; ouverture → menu plein écran, les
  liens arrivent un à un, la page derrière ne défile plus. Échap ou clic
  sur un lien → le menu se ferme (et le lien amène à sa section).
- [ ] Le bouton « Bientôt sur les stores » et le lien « À propos »
  n'apparaissent pas encore : ils arrivent avec leurs sections (lot 5).
- [ ] Au clavier seul (Tab) : chaque lien et bouton de l'en-tête reçoit un
  contour rose visible.
- [ ] Réglage système « réduire les animations » activé → aucune
  apparition animée, tout est affiché d'emblée.
- [ ] Pied de page : adresse de contact cliquable (ouvre la messagerie),
  grand « Playlink » en filigrane. Les liens légaux mènent encore à une
  page introuvable (lot 7).

### 11.3 Héros et bandeaux (lot 2)
- [ ] Au chargement, sur-titre, titre, accroche, bouton et chiffres
  apparaissent l'un après l'autre ; le mot entre astérisques du titre
  (« *brisé* » par défaut) est en italique, avec un dégradé qui ondule.
- [ ] Au back-office, retirer les astérisques du titre → plus de mot mis
  en valeur, aucun astérisque visible.
- [ ] Éventail : une carte par jeu mis en avant, avec une vraie carte du
  jeu ; il tourne toutes les 2,5 s ; survol → il s'arrête ; points sous
  l'éventail → affichent le jeu choisi.
- [ ] Clic sur la carte du dessus → la page descend à la démo, sur une
  catégorie de ce jeu.
- [ ] Sur ordinateur, un halo rose suit la souris dans le héros.
- [ ] Chiffres « N jeux / N cartes / 0 connexion » : nombre de cartes
  arrondi à la centaine inférieure avec un « + » (1 521 → « 1 500+ »).
- [ ] Bandeaux : deux rangées de vraies cartes douces qui défilent en sens
  opposés, sans saut visible à la fin de la boucle ; survol → la rangée
  s'arrête.
- [ ] Un « ? » ou un « : » n'est jamais rejeté seul en début de ligne.
- [ ] « Réduire les animations » → l'éventail ne tourne plus, les
  bandeaux sont immobiles, pas de halo.

### 11.4 Section « 01 — Les jeux » (lot 3)
- [ ] Sur-titre, titre et texte viennent du back-office (section Jeux).
- [ ] Tuiles dans l'ordre des jeux choisis au back-office, avec icône,
  numéro, nom, description et « N catégories » (« 1 catégorie » au
  singulier).
- [ ] Ordinateur (≥ 900 px) : grille ; au survol, la tuile s'incline vers
  la souris et une lueur à la couleur du jeu la suit ; en sortant, elle se
  remet à plat.
- [ ] Tablette : slider, un peu plus de 2 tuiles visibles ; mobile : une
  tuile et le bord de la suivante. Le glisser s'arrête toujours sur une
  tuile.
- [ ] Sous le slider : compteur « 01 / 08 » qui suit le défilement, points
  cliquables, flèches ← → désactivées en début et en fin de liste ; depuis
  la fin, ← recule bien.
- [ ] Bouton « Jouer » d'une tuile → la page descend à la démo, sur ce jeu.

### 11.5 Démo jouable (lot 4)
Même déroulé que dans l'app, avec 3 joueurs fixes : Alex, Sam, Léa.
- [ ] Seuls les jeux ayant une catégorie cochée « jouable » au back-office
  sont proposés ; changer de jeu met à jour les catégories et le halo de
  couleur de la section.
- [ ] Intensités au-delà du maximum réglé au back-office (3 par défaut) :
  cadenas, non cliquables, avec la mention « dans l'app ».
- [ ] « Lancer la partie » → carte face cachée + « C'est au tour d'Alex »
  → « Voir la carte » (ou clic sur la carte) → la carte se retourne →
  « Voter » (ou glisser la carte) → « Est-ce qu'Alex mérite un point ? »
  → Oui / Non → carte face cachée + « C'est au tour de Sam »… jusqu'à la
  dernière carte.
- [ ] Nombre de cartes = réglage du back-office (5 par défaut), ou moins si
  la catégorie en a moins ; compteur « 2 / 5 » et barres en haut à droite.
- [ ] Fin de partie : podium 🥇🥈🥉 avec les points, « X remporte la
  manche » ou « Égalité en tête ! », rappel de l'app, boutons « Bientôt
  sur App Store / Google Play », « Rejouer » (nouveau tirage) et
  « Changer de jeu ».
- [ ] Devine le mot : « 3 indices restants » ; « Indice utilisé » décompte
  jusqu'à « Plus d'indice » (bouton alors désactivé) ; remis à 3 à la
  carte suivante.
- [ ] Changer de jeu, de catégorie ou d'intensité en cours de partie →
  retour à l'écran de départ.
- [ ] Clavier seul : Entrée enchaîne les étapes, P = point, N = pas de
  point ; le contour rose suit le bouton de chaque étape.
- [ ] Mobile : les rangées « jeu » et « catégorie » tiennent sur une ligne
  qui défile, avec un fondu à droite ; l'option choisie se recentre ;
  « Lancer la partie » fait descendre jusqu'à la carte.
- [ ] Deux parties de suite ne tirent pas forcément les mêmes cartes, et
  les cartes proches de l'intensité choisie sont les plus fréquentes.

### 11.6 Comment ça marche, pré-inscription, réseaux (lot 5)
Prérequis : `LANDING_API_SECRET` identique sur le site et le back-office ;
pour le double opt-in, `RESEND_API_KEY` et le domaine vérifié dans Resend.
- [ ] En-tête : les liens « À propos » et « Réseaux » et le bouton
  « Bientôt sur les stores » sont là et mènent à leur section ; le
  deuxième bouton du héros mène au formulaire.
- [ ] « Comment ça marche » : 3 étapes éditables ; les chiffres (jeux,
  catégories, cartes arrondies, 100 %) comptent depuis 0 en apparaissant.
- [ ] Formulaire : envoyer vide ou avec une adresse invalide → « Cette
  adresse e-mail ne semble pas valide. » ; sans cocher la case → « Coche
  la case… » ; les messages sont en texte, sous le formulaire.
- [ ] Inscription valide → message de succès et pluie de mini-cartes ;
  l'inscrit apparaît en base (adresse en minuscules).
- [ ] Se réinscrire avec la même adresse (même en changeant la casse) →
  même message, aucun doublon.
- [ ] Double opt-in activé : message « Plus qu'une étape », e-mail reçu
  (expéditeur no-reply@playlink-game.fr, réponse vers
  gamesplaylink@gmail.com) ; le lien affiche « C'est confirmé ! », un
  second clic « Ce lien ne fonctionne plus ».
- [ ] Back-office coupé → « L'inscription n'a pas pu être enregistrée… ».
- [ ] Réseaux : un réseau sans lien au back-office n'apparaît pas ; aucun
  lien → ni section ni entrée « Réseaux » dans le menu.
- [ ] Pied de page → « Supprimer mes données » : page explicative, le
  bouton ouvre la messagerie avec un e-mail pré-rempli vers
  gamesplaylink@gmail.com.
- [ ] Au clavier dans le formulaire, rien ne glisse ni ne se décale.

### 11.7 Cookies et mesure d'audience (lot 6)
Prérequis : `NEXT_PUBLIC_POSTHOG_KEY_LANDING` sur le projet Vercel du site.
Pour vérifier les envois : PostHog → Activity (quelques secondes de délai).
Tester dans une fenêtre privée, pour repartir sans choix enregistré.
- [ ] Première visite : le bandeau glisse en bas à gauche après ~1,5 s ;
  aucun événement n'arrive dans PostHog tant qu'on n'a pas choisi.
- [ ] « Fonctionnels seulement » → le bandeau disparaît, rien n'arrive
  dans PostHog, même en jouant à la démo ; au rechargement, le bandeau ne
  revient pas.
- [ ] « Gérer les préférences » → deux lignes : Fonctionnels (toujours
  actifs) et Mesure d'audience (interrupteur) ; « Enregistrer » applique
  le choix.
- [ ] « Tout accepter » → `$pageview` arrive dans PostHog ; une partie de
  démo envoie `demo_started`, `demo_card_revealed`,
  `demo_vote_submitted`, `demo_completed` ; un clic sur un réseau envoie
  `social_link_clicked` ; une pré-inscription `preregister_submitted`.
- [ ] Pied de page → « Gérer les cookies » rouvre le bandeau sur les
  préférences ; couper la mesure d'audience → plus rien n'arrive, et les
  cookies `ph_…` disparaissent (outils de développement → Application →
  Cookies).
- [ ] Le choix est conservé 12 mois (cookie `playlink-consent-v1`).
- [ ] Dans PostHog, aucun événement ne porte d'e-mail ni de nom :
  seulement la langue, le jeu, la catégorie, l'intensité, le numéro de
  carte et le vote.

### 11.8 Pages légales et SEO (lot 7)
- [ ] Pied de page : Mentions légales, Politique de confidentialité,
  Conditions d'utilisation, Cookies → chaque page s'ouvre (plus d'erreur
  404), en FR et en EN.
- [ ] Mentions légales : l'éditeur et le directeur de la publication
  affichent « Choeurtis Tchounga ».
- [ ] Les liens internes des pages (confidentialité, cookies, supprimer
  mes données, e-mail, CNIL) fonctionnent.
- [ ] Partage d'un lien (WhatsApp, Slack, LinkedIn…) : aperçu avec
  l'éventail de cartes, le titre du héros (mot mis en valeur en rose) et
  « Bientôt sur iOS & Android ». Test : opengraph.xyz.
- [ ] `/robots.txt` et `/sitemap.xml` répondent ; le sitemap liste
  l'accueil et les pages légales, en FR et EN.
- [ ] Test des résultats enrichis Google (search.google.com/test/rich-results)
  sur l'accueil : Organization et SoftwareApplication détectés, sans
  erreur.
- [ ] Google Search Console : domaine vérifié, sitemap soumis.

### 11.9 Mise à jour immédiate et qualité (lot 8)
Prérequis : `WEB_URL` sur le projet Vercel du back-office (URL du site).
- [ ] Modifier un texte ou un jeu au back-office → la landing affiche le
  changement en quelques secondes (recharger la page), sans redéploiement.
- [ ] PageSpeed Insights (pagespeed.web.dev) sur l'URL de production :
  mobile ≥ 90 en performance, 100 en accessibilité, bonnes pratiques et
  SEO ; ordinateur 100 partout.
- [ ] Au clavier : le premier Tab fait apparaître « Aller au contenu » en
  haut à gauche ; Entrée saute le menu.
- [ ] Onglet du navigateur : icône Playlink (éventail de cartes).
- [ ] Téléphone très étroit (320 px, ex. iPhone SE 1re génération) : rien
  ne dépasse sur le côté ; sous le slider des jeux, compteur et flèches
  (les points n'apparaissent qu'à partir de 400 px).
- [ ] Les points sous l'éventail et sous le slider se touchent facilement
  au doigt.

---

## 12. Back-office v2 — refonte en cours

### 12.1 Structure générale et composants (lot 9)
- [ ] Sidebar en 4 groupes (Général, Contenu de l'app, Landing,
  Diffusion) avec icônes ; l'écran ouvert est surligné, avec une barre
  rose à gauche. « Stats » et « Pré-inscriptions » sont grisés
  (« bientôt ») et ne sont pas cliquables.
- [ ] Compteurs : Jeux = nombre de jeux, Cartes = cartes actives.
- [ ] Encart en bas de la sidebar : « N modifications à publier » (point
  rose qui pulse) après avoir modifié une carte, une catégorie, un jeu,
  une slide ou un badge ; « Tout est publié » juste après une
  publication. Cocher « jouable dans la démo » sur une catégorie ne
  compte pas (ça ne concerne que la landing). Clic → Publication.
- [ ] Barre du haut : fil d'Ariane (groupe › écran), « Voir le site »
  ouvre la landing dans un nouvel onglet.
- [ ] Recherche : ⌘K (Mac) ou Ctrl+K (Windows), ou clic sur le champ de
  la barre du haut. Taper « vér » → jeux et catégories correspondants ;
  flèches ↑ ↓ puis Entrée → l'écran s'ouvre déjà filtré. Taper le nom
  d'un écran (« trad ») le propose aussi. Échap ferme.
- [ ] Fenêtres (Nouvelle carte, Éditer…) : le curseur est dans le premier
  champ ; Tab reste dans la fenêtre ; Échap ou clic sur le fond ferme et
  rend le focus au bouton d'origine. Après « Enregistrer », une
  notification « Modifications enregistrées » apparaît en bas à droite.
- [ ] Supprimer : un premier clic transforme le bouton en « Confirmer ? »
  (rouge plein) ; sans second clic dans les 4 s, il revient à
  « Supprimer ». Plus de boîte de dialogue du navigateur.
- [ ] Sous 900 px de large : logo et compte en haut, entrées du menu sur
  une ligne qui défile ; rien ne dépasse sur le côté (390 px).
- [ ] Au clavier : le premier Tab fait apparaître « Aller au contenu ».

### 12.2 Tableau de bord (lot 10)
- [ ] 6 compteurs (jeux, catégories, cartes actives, slides, badges,
  version publiée) ; chacun ouvre l'écran correspondant.
- [ ] « Landing — 7 derniers jours » : pré-inscriptions des 7 derniers
  jours avec la variation par rapport aux 7 précédents, des dernières
  24 h et sur 14 jours, courbe jour par jour. Vues et démos : annoncées
  pour l'écran Stats (rien d'inventé).
- [ ] « À traiter » : cartes sans traduction EN (→ Traductions),
  modifications non publiées (→ Publication), textes EN du site à mettre
  à jour (→ Contenu du site), nouvelles pré-inscriptions des dernières
  24 h. Une ligne sans rien à faire passe au vert (« Rien à publier »…).
- [ ] Texte EN du site : modifier un texte en FR seulement → la ligne
  « N textes EN à mettre à jour » apparaît ; renseigner l'EN → elle
  repasse au vert.
- [ ] « Activité récente » : les 6 dernières modifications en clair
  (« Carte modifiée — « … » »), avec l'éditeur et l'heure (« il y a
  12 min », « hier · 22:40 »). Sur téléphone, l'heure passe sous le texte.

### 12.3 Contenu du site (lot 11)
- [ ] 7 sections à gauche (Héros, Jeux, Démo jouable, Comment ça marche,
  Pré-inscription, Réseaux, SEO & partage) avec une pastille : verte
  (complet), orange (modifié, non publié), rouge (anglais à revoir).
  Sous 1280 px : sections en pastilles au-dessus, aperçu en dessous.
- [ ] Chaque texte en FR et EN côte à côte, avec compteur « n / max ».
  Modifier un texte FR seulement → sous l'EN : « Le FR a changé —
  l'anglais est encore le texte d'origine ». Vider un EN → « Traduction
  manquante ».
- [ ] L'aperçu à droite suit la frappe ; boutons Bureau/Mobile et FR/EN.
  En EN, un texte vide s'affiche en FR avec l'étiquette « Textes EN
  manquants — repli sur le FR ».
- [ ] Rien n'est enregistré avant « Publier sur le site » : le statut
  indique « N modifications non publiées », « Annuler » revient à la
  version publiée. Quitter la page avec des modifications → le
  navigateur demande confirmation.
- [ ] Publier → notification « Site publié », statut « En ligne · publié
  à l'instant » ; la landing affiche le changement en quelques secondes.
- [ ] Héros : date de sortie passée → l'aperçu affiche « Disponible sur
  iOS & Android ».
- [ ] Jeux : 8 jeux au plus ; ordre = celui de la page Jeux (réordonner
  les jeux réordonne la landing).
- [ ] Démo : taille du deck (3 à 6), intensité maximale (1 à 5, libellé
  affiché), catégories jouables ; le nombre de cartes exposées se met à
  jour en direct.
- [ ] Réseaux : un lien invalide (« pas-un-lien ») est refusé à la
  publication avec un message clair ; un réseau vide est masqué.
- [ ] SEO : aperçu du résultat Google (titre coupé à 60 caractères,
  description à 160) et de la carte de partage.
- [ ] Tableau de bord → « N textes EN à mettre à jour » ouvre directement
  la bonne section.
- [ ] Taper `*mot*` dans l'accroche (ou tout champ autre que les deux
  titres) → alerte sous le champ ; sur la landing, les étoiles
  disparaissent (le mot reste).

### 12.4 Jeux, Cartes, Catégories (lot 12a)
- [ ] Jeux : lignes avec bande et pastille aux couleurs du jeu, chiffres
  (catégories, cartes → Cartes filtrées, slides → Règles). Réordonner à
  la souris par la poignée, ou au clavier : Tab jusqu'à la poignée, puis
  ↑ / ↓ (le focus reste sur la poignée). Un jeu inactif porte
  l'étiquette « inactif » ; ses couleurs s'éteignent, pas son texte.
- [ ] Pastilles de catégories : clic → Cartes filtrées sur la catégorie ;
  crayon → édition ; croix (catégorie vide seulement) → suppression en
  deux clics.
- [ ] Création d'un jeu ou d'une catégorie : le slug se remplit depuis le
  nom (« Vérités très légères ! » → `verites-tres-legeres`) tant qu'on ne
  le modifie pas à la main ; en édition, il ne bouge pas.
- [ ] Cartes : les filtres s'appliquent sans bouton (recherche après une
  courte pause, jeu, catégorie, intensité Toutes/1–5, « Sans EN ») et se
  retrouvent dans l'URL ; « Réinitialiser » les retire tous. Changer un
  filtre revient en page 1.
- [ ] Cartes : jauge d'intensité, colonne EN (✓ = traduite en anglais),
  interrupteur « Active » dans la ligne (notification ; la ligne ne
  change pas de place), crayon → édition avec intensité en boutons 1–5 et
  aperçu, corbeille → suppression en deux clics.
- [ ] Catégories : filtres par jeu avec le nombre de catégories ; barres
  de répartition 1→5 qui se remplissent à l'affichage ; nombre de cartes
  → Cartes filtrées ; cadenas (avec explication au survol) à la place de
  la suppression tant que la catégorie a des cartes.
- [ ] 390 px de large : rien ne dépasse sur le côté (les tableaux
  défilent horizontalement).

### 12.5 Traductions, Règles, Badges, Publication (lot 12b)
- [ ] Traductions : grande jauge de couverture anglaise ; à droite,
  avancement par jeu (clic = filtre sur ce jeu, re-clic = retire le
  filtre). Recherche FR ou EN, jeu et catégorie s'appliquent sans bouton.
- [ ] Traduire une carte puis quitter le champ (Tab) → « Enregistré » à
  côté et notification ; en mode « À traduire », la carte quitte la liste.
  « Tout voir » montre aussi les cartes déjà traduites.
- [ ] Règles : choisir un jeu ; cliquer une slide l'affiche dans le
  téléphone à droite ; ‹ › et les points suivent ; le **gras** est rendu.
  Réordonner par la poignée ou au clavier (↑ / ↓).
- [ ] Badges : chaque carte indique la règle codée dans l'app (horloge
  bleue = pas encore débloquable, triangle orange = clé inconnue de
  l'app). Section « badges prévus absents » : « Créer » l'ajoute en un
  clic avec son nom, sa description et son icône par défaut.
- [ ] Badge « Triplé » : la description dit « 3 parties gagnées
  d'affilée » (l'app compte toutes les sessions, pas une seule). Si
  l'ancienne description « … dans une même session » est en base,
  la corriger via Éditer.
- [ ] Publication : version en ligne, récapitulatif des modifications
  depuis (mêmes chiffres que l'encart de la sidebar, par type puis les
  dernières en clair), historique des versions. « Publier la vN » →
  « Confirmer la vN » + Annuler (plus de boîte du navigateur) → version
  créée, notification.

---

## Ce qui reste à développer

Rien de ce qui suit n'est testable aujourd'hui — c'est normal de tomber sur
des tuiles désactivées ou des boutons « Bientôt disponible » aux endroits
listés ci-dessus.

- **Phase 4 — Compte & synchronisation** : connexion réelle (Clerk) côté
  app, fusion des données locales vers le cloud, récupération de la
  progression sur un autre appareil, suppression de compte (RGPD).
- **Phase 5 — Communauté & analytics** : liker une carte, partager un
  score (image + lien), publier ses cartes perso au catalogue officiel
  depuis le back-office, badge Curateur, vrai envoi des statistiques
  d'usage (PostHog), dashboard de stats et cron d'agrégation.
- **Phase 6 — Polish & mise en boutique** : notifications push, mise à
  jour du contenu par-dessus l'app sans nouvelle publication en magasin,
  icônes et écran de démarrage définitifs, fiches App Store / Google
  Play, publication sur TestFlight et la piste de test Google Play.
