import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";

export default createMiddleware(routing);

export const config = {
  // Exclut les fichiers statiques, l'API et les assets Next internes.
  matcher: ["/((?!api|_next|.*\\..*).*)"],
};
