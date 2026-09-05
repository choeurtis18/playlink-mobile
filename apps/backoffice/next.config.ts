import type { NextConfig } from "next";

// En local, les secrets du projet vivent dans le `.env` de la racine du
// monorepo — une source unique plutôt qu'un doublon par app, voué à diverger.
// Next ne lit que le `.env.local` de cette app, d'où ce chargement manuel.
//
// En déploiement, Vercel injecte les variables lui-même : ce bloc ne doit
// donc jamais faire échouer le build. `dotenv` est une devDependency, et le
// fichier est absent du dépôt — les deux cas sont tolérés.
if (process.env.NODE_ENV !== "production") {
  try {
    const { config } = require("dotenv");
    config({ path: "../../.env", override: false });
  } catch {
    // dotenv absent ou fichier introuvable : les variables viennent d'ailleurs.
  }
}

const nextConfig: NextConfig = {
  reactStrictMode: true,
};

export default nextConfig;
