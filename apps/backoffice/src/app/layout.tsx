import type { Metadata } from "next";
import { ClerkProvider, UserButton } from "@clerk/nextjs";
import Link from "next/link";
import "./globals.css";

export const metadata: Metadata = {
  title: "Playlink — Back-office",
  description: "Gestion du contenu et des statistiques Playlink",
};

const NAV = [
  { href: "/", label: "Tableau de bord" },
  { href: "/jeux", label: "Jeux" },
  { href: "/cartes", label: "Cartes" },
  { href: "/traductions", label: "Traductions" },
  { href: "/badges", label: "Badges" },
  { href: "/publication", label: "Publication" },
];

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <ClerkProvider>
      <html lang="fr">
        <body className="min-h-screen">
          <div className="flex min-h-screen">
            <aside className="w-56 shrink-0 border-r border-hairline p-5">
              <div className="mb-8 text-lg font-semibold">
                Play<span className="text-accent">link</span>
                <div className="text-xs text-neutral-faint">back-office</div>
              </div>
              <nav className="flex flex-col gap-1">
                {NAV.map((n) => (
                  <Link key={n.href} href={n.href}
                    className="rounded px-3 py-2 text-sm text-ink-soft hover:bg-surface hover:text-ink">
                    {n.label}
                  </Link>
                ))}
              </nav>
              <div className="mt-8 border-t border-hairline pt-4">
                <UserButton />
              </div>
            </aside>
            <main className="min-w-0 flex-1 p-8">{children}</main>
          </div>
        </body>
      </html>
    </ClerkProvider>
  );
}
