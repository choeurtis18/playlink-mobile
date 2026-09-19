import { SignIn } from "@clerk/nextjs";

// Plein écran, sans sidebar (ce layout n'hérite plus de celle du
// back-office, déplacée dans (admin)/layout.tsx). Le lien "S'inscrire" du
// widget Clerk disparaît de lui-même dès que l'instance est en mode
// "Restricted" côté dashboard Clerk (inscription fermée, invitation
// uniquement) — rien à faire ici pour ça.
export default function Page() {
  return (
    <div className="flex min-h-screen w-full items-center justify-center bg-neutral-950">
      <SignIn />
    </div>
  );
}
