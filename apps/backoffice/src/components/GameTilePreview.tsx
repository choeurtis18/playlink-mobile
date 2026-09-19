/** Aperçu fidèle de la tuile de jeu telle qu'affichée sur l'accueil de
 * l'app mobile (`GameTile` en Flutter) : dégradé diagonal (topLeft→
 * bottomRight, contrairement au dégradé vertical des écrans DE jeu),
 * icône, nom, sous-titre catégories. */
export function GameTilePreview({
  name, icon, colorMain, colorSecondary, categoryCount,
}: {
  name: string;
  icon?: string | null;
  colorMain: string;
  colorSecondary: string;
  categoryCount: number;
}) {
  return (
    <div
      className="flex aspect-[3/4] w-full max-w-[220px] min-w-0 flex-col justify-between overflow-hidden rounded-2xl p-4"
      style={{ background: `linear-gradient(135deg, ${colorMain}, ${colorSecondary})` }}
    >
      <span className="text-4xl">{icon || "🎲"}</span>
      <div className="min-w-0">
        <p className="break-words text-lg font-bold leading-tight tracking-tight text-white">
          {name || "Nom du jeu"}
        </p>
        <p className="mt-1 text-xs text-white/80">
          {categoryCount} catégorie{categoryCount > 1 ? "s" : ""}
        </p>
      </div>
    </div>
  );
}
