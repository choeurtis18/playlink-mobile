import { LEGAL_DEFAULTS, type LegalKey, type LegalPage } from "@/content/legal";
import { getLegalPages } from "./backoffice";

/** Page légale dans une langue : version du back-office si elle existe,
 * sinon texte par défaut du dépôt (même langue, puis FR). */
export async function getLegalPage(key: LegalKey, locale: string): Promise<LegalPage> {
  const { pages } = await getLegalPages();
  const row = pages.find((p) => p.key === key && p.locale === locale && p.content.trim());
  if (row) return { title: row.title, content: row.content };
  return (LEGAL_DEFAULTS[locale === "en" ? "en" : "fr"] ?? LEGAL_DEFAULTS.fr)[key];
}
