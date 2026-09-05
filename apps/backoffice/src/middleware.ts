import { clerkMiddleware } from "@clerk/nextjs/server";

// Le middleware ne fait qu'initialiser le contexte Clerk. La protection
// elle-même vit dans le layout des pages (voir src/app/(admin)/layout.tsx) :
// Clerk déprécie les gardes par correspondance de chemin, qui peuvent diverger
// du routage réel de Next et laisser une ressource protégée accessible.
export default clerkMiddleware();

export const config = {
  matcher: ["/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico)).*)", "/(api|trpc)(.*)"],
};
