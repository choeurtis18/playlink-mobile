import { defineRouting } from "next-intl/routing";

// FR = langue originale du contenu (cohérent avec CLAUDE.md), donc défaut.
export const routing = defineRouting({
  locales: ["fr", "en"],
  defaultLocale: "fr",
});

export type Locale = (typeof routing.locales)[number];
