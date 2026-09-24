/** Gabarit des pages secondaires (confirmation, suppression de données,
 * bientôt pages légales) : sur-titre, titre, texte, retour à l'accueil. */
export function SimplePage({ kicker, title, locale, backLabel, children }: {
  kicker: string;
  title: string;
  locale: string;
  backLabel: string;
  children: React.ReactNode;
}) {
  return (
    <section className="px-[clamp(20px,4vw,24px)] py-[clamp(56px,9vw,104px)]">
      <div className="mx-auto flex max-w-[720px] flex-col gap-6">
        <p className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">{kicker}</p>
        <h1 className="m-0 text-balance font-display text-[clamp(34px,4.6vw,56px)] font-semibold leading-[1.04] tracking-[-0.03em]">{title}</h1>
        <div className="flex flex-col gap-4 text-[17px] leading-[1.6] text-ink-soft [&_p]:m-0">{children}</div>
        <a href={`/${locale}`} className="mt-4 w-fit font-mono text-xs uppercase tracking-[0.14em] text-neutral-faint hover:text-ink">
          ← {backLabel}
        </a>
      </div>
    </section>
  );
}
