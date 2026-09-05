import { auth } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";

// Garde unique pour tout le back-office : chaque page du groupe (admin)
// exige un éditeur connecté. Vérification au niveau de la ressource, pas
// du chemin — une nouvelle page ajoutée ici est protégée d'office.
export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const { userId } = await auth();
  if (!userId) redirect("/sign-in");
  return <>{children}</>;
}
