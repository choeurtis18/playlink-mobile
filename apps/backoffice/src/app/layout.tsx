import type { Metadata } from "next";
import { ClerkProvider } from "@clerk/nextjs";
import "./globals.css";

export const metadata: Metadata = {
  title: "Playlink — Back-office",
  description: "Gestion du contenu et des statistiques Playlink",
};

// La sidebar vit dans (admin)/layout.tsx, pas ici : ce layout racine
// enveloppe AUSSI /sign-in, qui doit occuper tout l'écran sans navbar
// visible en arrière-plan derrière la connexion.
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <ClerkProvider>
      <html lang="fr">
        <body className="min-h-screen">{children}</body>
      </html>
    </ClerkProvider>
  );
}
