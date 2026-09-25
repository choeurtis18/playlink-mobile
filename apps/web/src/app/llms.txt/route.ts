import { getSiteConfig } from "@/lib/backoffice";
import { SITE_URL } from "@/lib/site-url";

// llms.txt (llmstxt.org) : résumé du site pour les agents IA, en
// Markdown. Titre H1, résumé en citation, puis des sections de liens
// `- [nom](url) : description`. Les jeux viennent du back-office, comme
// sur la page ; revalidé avec les mêmes étiquettes.
export async function GET() {
  const site = await getSiteConfig();
  const games = site.featuredGames.map((g) => {
    const description = g.translations.fr?.description ?? g.description;
    return `- ${g.name}${description ? ` : ${description.replace(/\s+/g, " ").trim()}` : ""}`;
  });

  const body = [
    "# Playlink",
    "",
    "> Playlink est une application mobile de jeux de soirée entre amis (iOS et Android, bientôt disponible), jouable 100 % hors ligne. Ce site présente l'application, propose une démo jouable dans le navigateur et une pré-inscription pour être prévenu de la sortie. Site disponible en français et en anglais.",
    "",
    "## Pages principales",
    "",
    `- [Accueil](${SITE_URL}/fr) : présentation des jeux, démo jouable, fonctionnement, pré-inscription`,
    `- [Home (English)](${SITE_URL}/en) : the same page in English`,
    ...(games.length > 0 ? ["", "## Jeux", "", ...games] : []),
    "",
    "## Informations légales",
    "",
    `- [Mentions légales](${SITE_URL}/fr/mentions-legales) : éditeur, hébergeur, contact`,
    `- [Politique de confidentialité](${SITE_URL}/fr/confidentialite) : données collectées, durées de conservation, droits`,
    `- [Conditions d'utilisation](${SITE_URL}/fr/cgu) : règles d'utilisation du site`,
    `- [Cookies](${SITE_URL}/fr/cookies) : cookies utilisés et gestion du consentement`,
    "",
    "## Optional",
    "",
    `- [Plan du site](${SITE_URL}/sitemap.xml) : toutes les pages, en français et en anglais`,
    `- [Supprimer mes données](${SITE_URL}/fr/supprimer-mes-donnees) : demande de suppression de la pré-inscription`,
    "",
  ].join("\n");

  return new Response(body, {
    headers: { "Content-Type": "text/markdown; charset=utf-8" },
  });
}
