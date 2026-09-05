import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

// `/content/latest` est lu par l'app mobile SANS compte : c'est du contenu
// de jeu public. Tout le reste du back-office exige un éditeur connecté.
const isPublic = createRouteMatcher(["/content/latest", "/sign-in(.*)", "/sign-up(.*)"]);

export default clerkMiddleware(async (auth, req) => {
  // `redirectToSignIn` plutôt que `protect()` : sans URL de connexion
  // configurée, protect() répond 404 — l'éditeur croirait la page absente.
  if (!isPublic(req)) {
    const { userId, redirectToSignIn } = await auth();
    if (!userId) return redirectToSignIn({ returnBackUrl: req.url });
  }
});

export const config = {
  matcher: ["/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico)).*)", "/(api|trpc)(.*)"],
};
