import { auth } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { UserButton } from "@clerk/nextjs";
import Link from "next/link";

const NAV = [
  { href: "/", label: "Tableau de bord" },
  { href: "/jeux", label: "Jeux" },
  { href: "/categories", label: "Catégories" },
  { href: "/cartes", label: "Cartes" },
  { href: "/traductions", label: "Traductions" },
  { href: "/regles", label: "Règles" },
  { href: "/badges", label: "Badges" },
  { href: "/site", label: "Site" },
  { href: "/publication", label: "Publication" },
];

// Garde unique pour tout le back-office : chaque page du groupe (admin)
// exige un éditeur connecté. Vérification au niveau de la ressource, pas
// du chemin — une nouvelle page ajoutée ici est protégée d'office. La
// sidebar vit ici (pas dans le layout racine) pour ne jamais apparaître
// derrière /sign-in.
export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const { userId } = await auth();
  if (!userId) redirect("/sign-in");

  return (
    <div className="flex min-h-screen flex-col md:flex-row">
      {/* < md : barre horizontale scrollable (nav en ligne) — pas de tiroir
         ni de hamburger, juste assez pour rester utilisable sur petit
         écran. >= md : sidebar verticale classique. */}
      <aside className="shrink-0 border-b border-hairline p-4 md:w-56 md:border-b-0 md:border-r md:p-5">
        <div className="mb-4 flex items-center justify-between text-lg font-semibold md:mb-8 md:block">
          <div>
            Play<span className="text-accent">link</span>
            <div className="text-xs font-normal text-neutral-faint">back-office</div>
          </div>
          <div className="md:hidden"><UserButton /></div>
        </div>
        <nav className="-mx-4 flex gap-1 overflow-x-auto px-4 pb-1 md:mx-0 md:flex-col md:overflow-visible md:px-0 md:pb-0">
          {NAV.map((n) => (
            <Link key={n.href} href={n.href}
              className="shrink-0 whitespace-nowrap rounded px-3 py-2 text-sm text-ink-soft hover:bg-surface hover:text-ink">
              {n.label}
            </Link>
          ))}
        </nav>
        <div className="mt-8 hidden border-t border-hairline pt-4 md:block">
          <UserButton />
        </div>
      </aside>
      <main className="min-w-0 flex-1 p-4 md:p-8">{children}</main>
    </div>
  );
}
