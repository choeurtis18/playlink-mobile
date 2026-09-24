import type { FeaturedGame } from "@/lib/backoffice";

/** Tuile de jeu : dégradé propre au jeu (colorMain → colorSecondary),
 * confiné à la tuile — jamais en fond d'app (CLAUDE.md §10). Scale + glow
 * coloré au survol/focus plutôt qu'un aplat gris plat. */
export function GameTile({ game, index, locale }: { game: FeaturedGame; index: number; locale: string }) {
  const name = game.translations[locale]?.name ?? game.name;
  const description = game.translations[locale]?.description ?? game.description;
  return (
    <li
      className="group relative isolate overflow-hidden rounded-2xl border border-hairline bg-surface p-6 outline-none transition-transform duration-300 [animation-delay:var(--delay)] motion-safe:animate-[tile-in_0.6s_ease-out_backwards] hover:-translate-y-1 focus-visible:-translate-y-1"
      style={{ "--delay": `${index * 90}ms` } as React.CSSProperties}
      tabIndex={0}
    >
      <div
        aria-hidden
        className="absolute inset-0 -z-10 opacity-0 blur-2xl transition-opacity duration-300 group-hover:opacity-60 group-focus-visible:opacity-60"
        style={{
          background: `radial-gradient(circle at 30% 20%, ${game.colorMain}, transparent 70%)`,
        }}
      />
      <div
        aria-hidden
        className="mb-4 flex h-12 w-12 items-center justify-center rounded-xl text-2xl"
        style={{
          background: `linear-gradient(135deg, ${game.colorMain}, ${game.colorSecondary})`,
        }}
      >
        {game.icon}
      </div>
      <h3 className="mb-1.5 font-[family-name:var(--font-display)] text-lg font-semibold text-ink">
        {name}
      </h3>
      {description && (
        <p className="text-sm leading-relaxed text-ink-soft">{description}</p>
      )}
    </li>
  );
}
