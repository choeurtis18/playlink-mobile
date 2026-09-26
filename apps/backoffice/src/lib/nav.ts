// Navigation du back-office : une seule définition pour la sidebar, le
// fil d'Ariane et les raccourcis de la recherche (⌘K).

export type NavKey =
  | "home" | "jeux" | "categories" | "cartes" | "traductions" | "regles" | "badges"
  | "site" | "stats" | "inscriptions" | "publication";

export type NavItem = {
  key: NavKey;
  href: string;
  label: string;
  /** Écran prévu mais pas encore construit : affiché, non cliquable. */
  soon?: boolean;
};

export type NavGroup = { label: string; items: NavItem[] };

export const NAV: NavGroup[] = [
  { label: "Général", items: [{ key: "home", href: "/", label: "Tableau de bord" }] },
  {
    label: "Contenu de l’app",
    items: [
      { key: "jeux", href: "/jeux", label: "Jeux" },
      { key: "categories", href: "/categories", label: "Catégories" },
      { key: "cartes", href: "/cartes", label: "Cartes" },
      { key: "traductions", href: "/traductions", label: "Traductions" },
      { key: "regles", href: "/regles", label: "Règles" },
      { key: "badges", href: "/badges", label: "Badges" },
    ],
  },
  {
    label: "Landing",
    items: [
      { key: "site", href: "/site", label: "Contenu du site" },
      { key: "stats", href: "/stats", label: "Stats" },
      { key: "inscriptions", href: "/inscriptions", label: "Pré-inscriptions" },
    ],
  },
  { label: "Diffusion", items: [{ key: "publication", href: "/publication", label: "Publication" }] },
];

/** Écran courant d'après le chemin : correspondance exacte pour
 * l'accueil, par préfixe pour les autres (`/cartes?…`, sous-pages). */
export function activeItem(pathname: string): { group: NavGroup; item: NavItem } | null {
  for (const group of NAV) {
    for (const item of group.items) {
      const match = item.href === "/" ? pathname === "/" : pathname === item.href || pathname.startsWith(`${item.href}/`);
      if (match) return { group, item };
    }
  }
  return null;
}
