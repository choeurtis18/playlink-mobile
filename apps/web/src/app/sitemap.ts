import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { SITE_URL } from "@/lib/site-url";

// Pages indexables, chacune en FR et EN (hreflang). La page de
// confirmation d'inscription est volontairement absente (noindex).
const PAGES = [
  { path: "", priority: 1, changeFrequency: "weekly" as const },
  { path: "/mentions-legales", priority: 0.2, changeFrequency: "yearly" as const },
  { path: "/confidentialite", priority: 0.3, changeFrequency: "yearly" as const },
  { path: "/cgu", priority: 0.2, changeFrequency: "yearly" as const },
  { path: "/cookies", priority: 0.2, changeFrequency: "yearly" as const },
  { path: "/supprimer-mes-donnees", priority: 0.1, changeFrequency: "yearly" as const },
];

export default function sitemap(): MetadataRoute.Sitemap {
  return PAGES.flatMap(({ path, priority, changeFrequency }) =>
    routing.locales.map((locale) => ({
      url: `${SITE_URL}/${locale}${path}`,
      lastModified: new Date(),
      changeFrequency,
      priority,
      alternates: {
        languages: Object.fromEntries(routing.locales.map((l) => [l, `${SITE_URL}/${l}${path}`])),
      },
    })),
  );
}
