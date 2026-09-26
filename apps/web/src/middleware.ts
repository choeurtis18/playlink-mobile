import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";

export default createMiddleware(routing);

export const config = {
  // Exclut les fichiers statiques, l'API, les assets Next internes et le
  // relais PostHog (next.config.ts) : sans ça, /relais/e/ serait redirigé
  // vers /fr/relais/e/.
  matcher: ["/((?!api|_next|relais|.*\\..*).*)"],
};
