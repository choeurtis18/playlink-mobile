/** Aperçu fidèle de la carte telle qu'affichée dans l'app mobile
 * (`PlayCard` en Flutter) : dégradé plein, badge catégorie translucide,
 * texte, intensité — mêmes proportions, mêmes coins arrondis. */
export function CardPreview({
  text, categoryLabel, colorMain, colorSecondary, intensityLabel,
}: {
  text: string;
  categoryLabel?: string | null;
  colorMain: string;
  colorSecondary: string;
  intensityLabel?: string;
}) {
  return (
    <div
      className="flex aspect-[3/4] w-full min-w-0 flex-col justify-between overflow-hidden rounded-3xl p-6 shadow-lg"
      style={{ background: `linear-gradient(180deg, ${colorMain}, ${colorSecondary})`, boxShadow: "0 14px 30px rgba(0,0,0,0.3)" }}
    >
      {categoryLabel ? (
        <span className="w-fit rounded-full bg-white/20 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
          {categoryLabel}
        </span>
      ) : <span />}

      <p className="min-w-0 break-words text-xl font-bold leading-snug tracking-tight text-white">
        {text || "Le texte de la carte apparaîtra ici…"}
      </p>

      <div className="flex items-center gap-2.5">
        <span className="flex h-9 w-9 items-center justify-center rounded-full bg-white/20 text-white">♡</span>
        <span className="flex h-9 w-9 items-center justify-center rounded-full bg-white/20 text-white">⇧</span>
        <span className="flex-1" />
        {intensityLabel && (
          <span className="text-[11px] text-white/75">{intensityLabel} · swipe pour voter</span>
        )}
      </div>
    </div>
  );
}
