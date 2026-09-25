import { SITE_URL } from "@/lib/site-url";

/** Données structurées schema.org de l'accueil : l'éditeur, le site et
 * l'application (à venir sur iOS et Android). Aucune note ni avis : on
 * n'en déclare pas tant qu'il n'y en a pas de vrais. */
export function StructuredData({ locale, description }: { locale: string; description: string }) {
  const data = {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "Organization",
        "@id": `${SITE_URL}/#organization`,
        name: "Playlink",
        url: SITE_URL,
        email: "gamesplaylink@gmail.com",
      },
      {
        "@type": "WebSite",
        "@id": `${SITE_URL}/#website`,
        name: "Playlink",
        url: SITE_URL,
        inLanguage: ["fr", "en"],
        publisher: { "@id": `${SITE_URL}/#organization` },
      },
      {
        "@type": "SoftwareApplication",
        name: "Playlink",
        applicationCategory: "GameApplication",
        operatingSystem: "iOS, Android",
        description,
        inLanguage: locale,
        url: `${SITE_URL}/${locale}`,
        offers: { "@type": "Offer", price: "0", priceCurrency: "EUR" },
        publisher: { "@id": `${SITE_URL}/#organization` },
      },
    ],
  };
  return (
    <script
      type="application/ld+json"
      // JSON sérialisé par nous, sans donnée saisie par un visiteur ;
      // « < » échappé pour qu'un texte du back-office ne ferme pas la balise.
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, "\\u003c") }}
    />
  );
}
