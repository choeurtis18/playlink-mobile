import type { MetadataRoute } from "next";

// Autorise explicitement les crawlers IA connus en plus des moteurs
// classiques — objectif d'accessibilité aux agents (voir plan landing §07).
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [{ userAgent: "*", allow: "/" }],
    sitemap: `${siteUrl()}/sitemap.xml`,
  };
}

function siteUrl() {
  return process.env.NEXT_PUBLIC_SITE_URL ?? "https://playlink-game.fr";
}
