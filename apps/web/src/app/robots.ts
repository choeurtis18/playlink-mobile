import type { MetadataRoute } from "next";
import { SITE_URL } from "@/lib/site-url";

// Autorise explicitement les crawlers IA connus en plus des moteurs
// classiques — objectif d'accessibilité aux agents (voir plan landing §07).
// La confirmation d'inscription (lien à usage unique) n'a rien à indexer.
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [{ userAgent: "*", allow: "/", disallow: ["/fr/confirmation", "/en/confirmation"] }],
    sitemap: `${SITE_URL}/sitemap.xml`,
    host: SITE_URL,
  };
}
