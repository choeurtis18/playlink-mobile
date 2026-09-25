import type { Metadata } from "next";
import { ClerkProvider } from "@clerk/nextjs";
import { Fraunces, Inter_Tight, JetBrains_Mono } from "next/font/google";
import "./globals.css";

export const metadata: Metadata = {
  title: "Playlink — Back-office",
  description: "Gestion du contenu et des statistiques Playlink",
  robots: { index: false, follow: false },
};

// Mêmes familles que la landing, auto-hébergées par next/font.
const fraunces = Fraunces({ subsets: ["latin"], axes: ["opsz"], variable: "--font-fraunces", display: "swap" });
const interTight = Inter_Tight({ subsets: ["latin"], variable: "--font-inter-tight", display: "swap" });
const jetbrainsMono = JetBrains_Mono({ subsets: ["latin"], variable: "--font-jetbrains-mono", display: "swap", preload: false });

// La sidebar vit dans (admin)/layout.tsx, pas ici : ce layout racine
// enveloppe AUSSI /sign-in, qui doit occuper tout l'écran sans navbar
// visible en arrière-plan derrière la connexion.
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <ClerkProvider>
      <html lang="fr" className={`${fraunces.variable} ${interTight.variable} ${jetbrainsMono.variable}`}>
        <body className="min-h-screen font-sans">{children}</body>
      </html>
    </ClerkProvider>
  );
}
