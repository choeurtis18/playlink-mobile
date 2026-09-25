/** Un passage entre astérisques dans un texte éditable (« Le jeu qui a
 * *brisé*… ») est mis en valeur, sans jamais accepter de HTML depuis le
 * back-office. Sans astérisque, le texte s'affiche tel quel.
 * - `shine` : dégradé animé du héros ;
 * - `soft` : italique en retrait (« Un téléphone. *Tout le monde autour.* »). */
export function Emphasis({ text, variant }: { text: string; variant: "shine" | "soft" }) {
  return text.split(/\*([^*]+)\*/).map((part, i) =>
    i % 2 === 0 ? (
      part
    ) : variant === "shine" ? (
      <em
        key={i}
        className="bg-[length:200%_100%] bg-clip-text pr-[0.06em] font-medium italic text-transparent motion-safe:animate-[pl-shine_6s_linear_infinite]"
        style={{ backgroundImage: "linear-gradient(100deg, #f23a6b, #ff6b93, #EC4899, #f23a6b)" }}
      >
        {part}
      </em>
    ) : (
      <em key={i} className="font-medium text-ink-soft">
        {part}
      </em>
    ),
  );
}
