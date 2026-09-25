/** Aperçu fidèle de la modale règles telle qu'affichée dans l'app mobile
 * (`rules_sheet.dart`) : bandeau dégradé vertical (icône book, titre fixe
 * "Règle du jeu", croix), puis titre + texte de la slide en cours
 * d'édition. Le markdown `**gras**` est rendu comme dans `RichTextLite`. */
export function RulesSlidePreview({
  title, content, colorMain, colorSecondary,
}: {
  title: string;
  content: string;
  colorMain: string;
  colorSecondary: string;
}) {
  return (
    <div className="w-full max-w-[260px] overflow-hidden rounded-2xl border border-hairline bg-white shadow-lg">
      <div
        className="flex items-center gap-2 px-4 py-4 text-white"
        style={{ background: `linear-gradient(180deg, ${colorMain}, ${colorSecondary})` }}
      >
        <span aria-hidden>📖</span>
        <span className="flex-1 text-base font-extrabold">Règle du jeu</span>
        <span className="flex h-6 w-6 items-center justify-center rounded-full bg-white/20 text-xs">✕</span>
      </div>
      <div className="max-h-72 min-w-0 overflow-y-auto px-4 py-4">
        <p className="mb-2 break-words text-lg font-bold text-neutral-900">{title || "Titre de la slide"}</p>
        <p className="whitespace-pre-wrap break-words text-sm leading-relaxed text-neutral-600">
          {renderMarkdownLite(content) || "Le contenu apparaîtra ici…"}
        </p>
      </div>
    </div>
  );
}

/** `**gras**` uniquement — même contrat que `RichTextLite` côté mobile. */
export function renderMarkdownLite(text: string) {
  const parts = text.split(/(\*\*.+?\*\*)/g);
  return parts.map((p, i) =>
    p.startsWith("**") && p.endsWith("**")
      ? <strong key={i} className="font-bold text-neutral-900">{p.slice(2, -2)}</strong>
      : p
  );
}
