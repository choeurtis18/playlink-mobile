import type { NextConfig } from "next";
import { config as loadEnv } from "dotenv";

// Next ne lit que le `.env.local` de cette app, alors que les secrets du
// projet vivent dans le `.env` de la racine du monorepo (source unique :
// les dupliquer ici, c'est garantir qu'ils divergeront un jour).
// `override: false` laisse gagner ce que Vercel injecte en déploiement.
loadEnv({ path: "../../.env", override: false });

const nextConfig: NextConfig = {
  reactStrictMode: true,
};

export default nextConfig;
