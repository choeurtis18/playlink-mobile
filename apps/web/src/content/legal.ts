// Textes légaux par défaut de la landing, en Markdown simple (titres ##,
// listes -, **gras**, [liens](url)). Affichés tant que la page n'a pas été
// saisie au back-office (LegalContent, clé `site.<page>`).
//
// Modèles rédigés d'après ce que fait réellement le site (données
// collectées, prestataires, durées). À faire relire par un professionnel
// avant la mise en ligne, et à mettre à jour à la création de la société
// (raison sociale, SIRET, adresse).

export type LegalKey = "legal" | "privacy" | "terms" | "cookies";
export type LegalPage = { title: string; content: string };

const EDITOR = "Choeurtis Tchounga";
const EMAIL = "gamesplaylink@gmail.com";
const UPDATED_FR = "25 septembre 2026";
const UPDATED_EN = "September 25, 2026";

const VERCEL = "Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, États-Unis — vercel.com";
const VERCEL_EN = "Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, United States — vercel.com";

export const LEGAL_DEFAULTS: Record<"fr" | "en", Record<LegalKey, LegalPage>> = {
  fr: {
    legal: {
      title: "Mentions légales",
      content: `*Dernière mise à jour : ${UPDATED_FR}*

## Éditeur du site

Le site playlink-game.fr est édité par **${EDITOR}**, personne physique.

- Contact : [${EMAIL}](mailto:${EMAIL})
- Directeur de la publication : ${EDITOR}

## Hébergement

- Site et back-office : ${VERCEL}
- Base de données : Neon (Databricks), serveurs situés dans l’Union européenne (Francfort, Allemagne) — neon.tech

## Propriété intellectuelle

Les textes, cartes de jeu, visuels, logos et le nom « Playlink » sont protégés par le droit d’auteur et le droit des marques. Toute reproduction ou réutilisation, totale ou partielle, sans autorisation écrite préalable est interdite.

## Données personnelles

Le traitement des données personnelles est décrit dans la [politique de confidentialité](/fr/confidentialite), et l’usage des cookies dans la [politique des cookies](/fr/cookies).

## Signaler un contenu

Pour signaler un contenu ou une erreur : [${EMAIL}](mailto:${EMAIL}).`,
    },

    privacy: {
      title: "Politique de confidentialité",
      content: `*Dernière mise à jour : ${UPDATED_FR}*

Cette politique explique quelles données le site playlink-game.fr collecte, pourquoi, combien de temps, et comment exercer tes droits. Elle concerne le site uniquement ; l’application Playlink aura sa propre politique à sa sortie.

## Responsable du traitement

**${EDITOR}**, joignable à [${EMAIL}](mailto:${EMAIL}).

## Données collectées et finalités

### 1. Pré-inscription (« Me prévenir à la sortie »)

- **Données** : adresse e-mail, langue du site, date d’inscription, date de confirmation (si la confirmation par e-mail est activée).
- **Finalité** : t’envoyer un e-mail à la sortie de l’application.
- **Base légale** : ton consentement (case à cocher), que tu peux retirer à tout moment.
- **Durée de conservation** : jusqu’à l’envoi de l’annonce de sortie, puis 2 ans au plus ; supprimée plus tôt sur simple demande. Une inscription non confirmée est supprimée au bout de 30 jours.

### 2. Mesure d’audience (uniquement si tu l’acceptes)

- **Données** : pages vues, utilisation de la démo (jeu, catégorie, intensité, votes), clics sur les boutons principaux, langue, type d’appareil et de navigateur, identifiant aléatoire. Aucune donnée permettant de t’identifier directement ; l’adresse IP n’est pas conservée.
- **Finalité** : comprendre comment le site et la démo sont utilisés, pour les améliorer.
- **Base légale** : ton consentement, donné ou refusé via le bandeau cookies et modifiable à tout moment (« Gérer les cookies » en pied de page).
- **Durée de conservation** : 13 mois au plus.

### 3. Données techniques

- **Données** : journaux techniques de l’hébergeur (adresse IP, date, page demandée), nécessaires à la sécurité et au bon fonctionnement du site.
- **Base légale** : intérêt légitime (sécurité du service).
- **Durée de conservation** : durée fixée par l’hébergeur, au plus 12 mois.

La démo jouable ne collecte rien : la partie se déroule entièrement dans ton navigateur.

## Destinataires et sous-traitants

Tes données ne sont ni vendues ni louées. Elles sont traitées, pour notre compte, par :

- **Vercel** (hébergement du site) — États-Unis ; transferts encadrés par le Data Privacy Framework UE–États-Unis et les clauses contractuelles types de la Commission européenne.
- **Neon** (base de données) — serveurs dans l’Union européenne.
- **Resend** (envoi de l’e-mail de confirmation) — envoi depuis l’Union européenne (Irlande) ; transferts éventuels encadrés par les clauses contractuelles types.
- **PostHog** (mesure d’audience, seulement avec ton accord) — serveurs dans l’Union européenne (Francfort).

## Tes droits

Tu disposes d’un droit d’accès, de rectification, d’effacement, de limitation, d’opposition, de portabilité, et du droit de retirer ton consentement à tout moment. Pour les exercer, écris à [${EMAIL}](mailto:${EMAIL}) ; pour supprimer une pré-inscription, tu peux aussi passer par la page [Supprimer mes données](/fr/supprimer-mes-donnees). Réponse sous un mois au plus.

Si tu estimes que tes droits ne sont pas respectés, tu peux adresser une réclamation à la CNIL : [cnil.fr](https://www.cnil.fr).

## Âge minimum

La pré-inscription est réservée aux personnes de 15 ans et plus, âge du consentement numérique en France.

## Sécurité

Les échanges avec le site sont chiffrés (HTTPS). L’accès aux données est limité à l’éditeur, via un back-office protégé par authentification.

## Modifications

Cette politique peut évoluer, notamment à la sortie de l’application. La date de mise à jour figure en haut de la page.`,
    },

    terms: {
      title: "Conditions d’utilisation",
      content: `*Dernière mise à jour : ${UPDATED_FR}*

## Objet

Les présentes conditions encadrent l’utilisation du site playlink-game.fr (le « Site »), qui présente l’application Playlink, propose une démo jouable et permet de se pré-inscrire pour être prévenu de sa sortie. Utiliser le Site vaut acceptation de ces conditions.

## Accès

Le Site est accessible gratuitement, sans création de compte. L’éditeur fait ses meilleurs efforts pour qu’il soit disponible, sans pouvoir le garantir en permanence (maintenance, panne, cas de force majeure).

## Démo jouable

La démo est proposée pour un usage personnel et non commercial. Elle contient un échantillon de cartes ; certaines invitent à des défis ou à des confidences entre amis. Chacun reste libre de passer une carte et responsable de ce qu’il choisit de faire : joue dans le respect des autres participants.

## Pré-inscription

La pré-inscription consiste à laisser son adresse e-mail pour recevoir l’annonce de sortie de l’application. Elle ne crée aucun compte et n’engage à rien. Tu peux la supprimer à tout moment (voir la [politique de confidentialité](/fr/confidentialite)).

## Propriété intellectuelle

L’ensemble des contenus du Site (textes, cartes, visuels, logos, nom « Playlink ») est protégé. Aucune reproduction, extraction ou réutilisation n’est autorisée sans accord écrit préalable de l’éditeur.

## Responsabilité

Le Site est fourni « en l’état ». L’éditeur ne saurait être tenu responsable des dommages indirects liés à son utilisation, ni du contenu des sites externes vers lesquels il renvoie (réseaux sociaux, magasins d’applications).

## Modification des conditions

Ces conditions peuvent être modifiées à tout moment ; la version applicable est celle en ligne lors de ta visite.

## Droit applicable

Les présentes conditions sont soumises au droit français. En cas de litige, une solution amiable sera recherchée en priorité ; à défaut, les tribunaux français seront compétents.

## Contact

[${EMAIL}](mailto:${EMAIL})`,
    },

    cookies: {
      title: "Politique des cookies",
      content: `*Dernière mise à jour : ${UPDATED_FR}*

Un cookie est un petit fichier déposé sur ton appareil. Le site en utilise très peu, et **aucun cookie publicitaire**.

## Cookies fonctionnels (toujours actifs)

Nécessaires au fonctionnement du site, ils ne demandent pas de consentement.

- **NEXT_LOCALE** — mémorise la langue choisie (français ou anglais). Durée : 1 an.
- **playlink-consent-v1** — mémorise ton choix sur les cookies, pour ne pas te le redemander à chaque visite. Durée : 12 mois.

## Mesure d’audience (seulement avec ton accord)

- **ph_…_posthog** (cookie et stockage local du navigateur) — outil PostHog, hébergé dans l’Union européenne : attribue un identifiant aléatoire pour compter les visites et l’usage de la démo, sans t’identifier. Durée : 1 an au plus.

Tant que tu n’as pas accepté, aucun de ces éléments n’est déposé et l’outil n’est même pas chargé.

## Modifier ton choix

À tout moment, via le lien **« Gérer les cookies »** en pied de page : si tu retires ton accord, la mesure d’audience s’arrête immédiatement et ses cookies sont supprimés. Tu peux aussi supprimer les cookies depuis les réglages de ton navigateur.

Pour en savoir plus : [politique de confidentialité](/fr/confidentialite).`,
    },
  },

  en: {
    legal: {
      title: "Legal notice",
      content: `*Last updated: ${UPDATED_EN}*

## Publisher

The website playlink-game.fr is published by **${EDITOR}**, an individual.

- Contact: [${EMAIL}](mailto:${EMAIL})
- Publication director: ${EDITOR}

## Hosting

- Website and back office: ${VERCEL_EN}
- Database: Neon (Databricks), servers located in the European Union (Frankfurt, Germany) — neon.tech

## Intellectual property

Texts, game cards, visuals, logos and the name “Playlink” are protected by copyright and trademark law. Any reproduction or reuse, in whole or in part, without prior written permission is prohibited.

## Personal data

How personal data is processed is described in the [privacy policy](/en/confidentialite), and how cookies are used in the [cookie policy](/en/cookies).

## Report content

To report content or an error: [${EMAIL}](mailto:${EMAIL}).`,
    },

    privacy: {
      title: "Privacy policy",
      content: `*Last updated: ${UPDATED_EN}*

This policy explains what data the website playlink-game.fr collects, why, for how long, and how to exercise your rights. It covers the website only; the Playlink app will have its own policy at launch.

## Data controller

**${EDITOR}**, reachable at [${EMAIL}](mailto:${EMAIL}).

## Data collected and purposes

### 1. Early sign-up (“Notify me at launch”)

- **Data**: email address, site language, sign-up date, confirmation date (if email confirmation is enabled).
- **Purpose**: sending you an email when the app launches.
- **Legal basis**: your consent (checkbox), which you can withdraw at any time.
- **Retention**: until the launch announcement is sent, then 2 years at most; deleted earlier on request. An unconfirmed sign-up is deleted after 30 days.

### 2. Audience measurement (only if you accept it)

- **Data**: pages viewed, use of the demo (game, category, intensity, votes), clicks on the main buttons, language, device and browser type, random identifier. Nothing that identifies you directly; your IP address is not kept.
- **Purpose**: understanding how the site and the demo are used, in order to improve them.
- **Legal basis**: your consent, given or refused through the cookie banner and changeable at any time (“Manage cookies” in the footer).
- **Retention**: 13 months at most.

### 3. Technical data

- **Data**: the host’s technical logs (IP address, date, requested page), needed for the site’s security and operation.
- **Legal basis**: legitimate interest (service security).
- **Retention**: set by the host, 12 months at most.

The playable demo collects nothing: the game runs entirely in your browser.

## Recipients and processors

Your data is never sold or rented. It is processed on our behalf by:

- **Vercel** (website hosting) — United States; transfers covered by the EU–US Data Privacy Framework and the European Commission’s standard contractual clauses.
- **Neon** (database) — servers in the European Union.
- **Resend** (confirmation email delivery) — sent from the European Union (Ireland); any transfers covered by standard contractual clauses.
- **PostHog** (audience measurement, only with your consent) — servers in the European Union (Frankfurt).

## Your rights

You have the right to access, rectify, erase, restrict, object, data portability, and to withdraw your consent at any time. To exercise them, email [${EMAIL}](mailto:${EMAIL}); to delete an early sign-up, you can also use the [Delete my data](/en/supprimer-mes-donnees) page. We reply within one month at most.

If you believe your rights are not respected, you can lodge a complaint with the French data protection authority (CNIL): [cnil.fr](https://www.cnil.fr).

## Minimum age

Early sign-up is reserved for people aged 15 and over, the age of digital consent in France.

## Security

Exchanges with the site are encrypted (HTTPS). Access to data is limited to the publisher, through an authenticated back office.

## Changes

This policy may change, in particular when the app launches. The update date appears at the top of the page.`,
    },

    terms: {
      title: "Terms of use",
      content: `*Last updated: ${UPDATED_EN}*

## Purpose

These terms govern the use of the website playlink-game.fr (the “Site”), which presents the Playlink app, offers a playable demo and lets you sign up to be notified at launch. Using the Site means accepting these terms.

## Access

The Site is free to use, with no account. The publisher does its best to keep it available, without being able to guarantee it at all times (maintenance, outages, force majeure).

## Playable demo

The demo is offered for personal, non-commercial use. It contains a sample of cards; some suggest challenges or confessions between friends. Everyone is free to skip a card and responsible for what they choose to do: play with respect for the other players.

## Early sign-up

Early sign-up means leaving your email address to receive the app’s launch announcement. It creates no account and commits you to nothing. You can delete it at any time (see the [privacy policy](/en/confidentialite)).

## Intellectual property

All content on the Site (texts, cards, visuals, logos, the name “Playlink”) is protected. No reproduction, extraction or reuse is allowed without the publisher’s prior written consent.

## Liability

The Site is provided “as is”. The publisher cannot be held liable for indirect damage related to its use, nor for the content of external sites it links to (social networks, app stores).

## Changes to the terms

These terms may change at any time; the applicable version is the one online at the time of your visit.

## Governing law

These terms are governed by French law. In the event of a dispute, an amicable solution will be sought first; failing that, the French courts will have jurisdiction.

## Contact

[${EMAIL}](mailto:${EMAIL})`,
    },

    cookies: {
      title: "Cookie policy",
      content: `*Last updated: ${UPDATED_EN}*

A cookie is a small file stored on your device. The site uses very few of them, and **no advertising cookies**.

## Functional cookies (always on)

Needed for the site to work, they require no consent.

- **NEXT_LOCALE** — remembers the chosen language (French or English). Duration: 1 year.
- **playlink-consent-v1** — remembers your cookie choice, so you are not asked again on every visit. Duration: 12 months.

## Audience measurement (only with your consent)

- **ph_…_posthog** (cookie and browser local storage) — PostHog, hosted in the European Union: assigns a random identifier to count visits and demo usage, without identifying you. Duration: 1 year at most.

Until you accept, none of these is stored and the tool is not even loaded.

## Changing your choice

At any time, through the **“Manage cookies”** link in the footer: if you withdraw your consent, audience measurement stops immediately and its cookies are deleted. You can also delete cookies from your browser settings.

Learn more: [privacy policy](/en/confidentialite).`,
    },
  },
};
