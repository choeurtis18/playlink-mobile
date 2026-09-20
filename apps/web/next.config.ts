import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

// En local, les secrets du monorepo vivent dans le `.env` racine — voir
// apps/backoffice/next.config.ts pour la même convention. Ce site ne parle
// jamais directement à Neon : il consomme uniquement des routes publiques
// du back-office (voir docs/landing).
if (process.env.NODE_ENV !== "production") {
  try {
    const { config } = require("dotenv");
    config({ path: "../../.env", override: false });
  } catch {
    // dotenv absent ou fichier introuvable : les variables viennent d'ailleurs.
  }
}

const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts");

const nextConfig: NextConfig = {
  reactStrictMode: true,
};

export default withNextIntl(nextConfig);
