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

// Relais PostHog : le navigateur envoie la mesure d'audience à
// playlink-game.fr/relais/…, que Vercel transmet à PostHog EU. Les
// bloqueurs de publicité filtrent les domaines de PostHog, pas le nôtre :
// moins de visites perdues. Même traitement des données (PostHog EU,
// après consentement seulement). Chemin volontairement neutre : « ingest »
// ou « posthog » finissent dans les listes de blocage.
const ANALYTICS_RELAY = "/relais";
const POSTHOG_HOST = (process.env.NEXT_PUBLIC_POSTHOG_HOST_LANDING ?? "https://eu.i.posthog.com").replace(/\/$/, "");
// Scripts de PostHog (extensions chargées à la demande) : servis par un
// domaine « assets » à part (eu.i.posthog.com → eu-assets.i.posthog.com).
const POSTHOG_ASSETS = POSTHOG_HOST.replace(/^https:\/\/(\w+)\.i\.posthog\.com$/, "https://$1-assets.i.posthog.com");

const nextConfig: NextConfig = {
  reactStrictMode: true,
  // PostHog appelle des adresses avec une barre finale (/relais/e/) :
  // sans ça, Next les redirige et l'envoi échoue.
  skipTrailingSlashRedirect: true,
  async rewrites() {
    return [
      { source: `${ANALYTICS_RELAY}/static/:path*`, destination: `${POSTHOG_ASSETS}/static/:path*` },
      { source: `${ANALYTICS_RELAY}/:path*`, destination: `${POSTHOG_HOST}/:path*` },
    ];
  },
};

export default withNextIntl(nextConfig);
