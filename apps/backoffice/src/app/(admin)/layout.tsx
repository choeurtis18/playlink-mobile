import { auth, currentUser } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { ToastProvider } from "@/components/ui";
import { Sidebar } from "@/components/shell/Sidebar";
import { Topbar } from "@/components/shell/Topbar";
import { CommandPalette } from "@/components/shell/CommandPalette";
import { getShellCounts } from "@/lib/shell";

const SITE_URL = process.env.SITE_URL ?? "https://playlink-game.fr";

// Garde unique pour tout le back-office : chaque page du groupe (admin)
// exige un éditeur connecté. Vérification au niveau de la ressource, pas
// du chemin — une nouvelle page ajoutée ici est protégée d'office. La
// sidebar vit ici (pas dans le layout racine) pour ne jamais apparaître
// derrière /sign-in.
export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const { userId } = await auth();
  if (!userId) redirect("/sign-in");

  const [counts, user] = await Promise.all([getShellCounts(), currentUser()]);
  const editorLabel = user?.firstName ?? user?.primaryEmailAddress?.emailAddress ?? "Éditeur";

  return (
    <ToastProvider>
      <a
        href="#contenu"
        className="sr-only z-[80] rounded-lg bg-accent px-4 py-2 font-semibold text-ground-deep focus:not-sr-only focus:fixed focus:left-3 focus:top-3"
      >
        Aller au contenu
      </a>
      <div className="flex min-h-screen flex-col min-[900px]:flex-row">
        <Sidebar counts={counts} editorLabel={editorLabel} />
        <div className="flex min-w-0 flex-1 flex-col">
          <Topbar siteUrl={SITE_URL} />
          <main id="contenu" tabIndex={-1} className="w-full max-w-[1320px] px-4 pb-16 pt-7 outline-none min-[900px]:px-8">
            {children}
          </main>
        </div>
      </div>
      <CommandPalette />
    </ToastProvider>
  );
}
