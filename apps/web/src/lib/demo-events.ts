// Ouvrir la démo sur un jeu donné, depuis n'importe où dans la page (cartes
// du héros, tuiles de jeux). Un événement DOM plutôt qu'un contexte React :
// ces composants vivent dans des îlots client séparés, sans parent commun.

export const OPEN_DEMO_EVENT = "playlink:open-demo";

export type OpenDemoDetail = { gameSlug: string };

export function openDemo(gameSlug: string) {
  window.dispatchEvent(new CustomEvent<OpenDemoDetail>(OPEN_DEMO_EVENT, { detail: { gameSlug } }));
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  document.getElementById("demo")?.scrollIntoView({ behavior: reduce ? "auto" : "smooth", block: "start" });
}
