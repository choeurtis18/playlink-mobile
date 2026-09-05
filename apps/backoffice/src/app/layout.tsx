import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Playlink — Back-office",
  description: "Gestion du contenu et des statistiques Playlink",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  );
}
