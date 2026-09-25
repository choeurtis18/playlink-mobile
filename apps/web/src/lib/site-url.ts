/** URL publique du site, sans « / » final : liens absolus (partage,
 * sitemap, données structurées). */
export const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://playlink-game.fr").replace(/\/$/, "");
