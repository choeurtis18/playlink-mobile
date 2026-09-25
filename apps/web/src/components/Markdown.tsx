import { Fragment, type ReactNode } from "react";
import { frenchSpacing } from "@/lib/typography";

/** Markdown minimal des pages légales : ## et ### titres, listes « - »,
 * paragraphes, **gras**, *italique*, [liens](url). Construit des éléments
 * React — jamais de HTML brut — donc rien de ce qui est saisi au
 * back-office ne peut injecter de script. */
export function Markdown({ source }: { source: string }) {
  const blocks = source.replace(/\r\n/g, "\n").split(/\n{2,}/).map((b) => b.trim()).filter(Boolean);
  return (
    <>
      {blocks.map((block, i) => {
        if (block.startsWith("### ")) return <h3 key={i} className="mb-0 mt-4 text-lg font-semibold text-ink">{inline(block.slice(4))}</h3>;
        if (block.startsWith("## ")) return <h2 key={i} className="mb-0 mt-8 font-display text-2xl font-semibold tracking-[-0.01em] text-ink">{inline(block.slice(3))}</h2>;
        const lines = block.split("\n");
        if (lines.every((l) => l.startsWith("- "))) {
          return (
            <ul key={i} className="m-0 flex list-disc flex-col gap-1.5 pl-5 marker:text-accent">
              {lines.map((l, j) => <li key={j}>{inline(l.slice(2))}</li>)}
            </ul>
          );
        }
        return <p key={i}>{inline(lines.join(" "))}</p>;
      })}
    </>
  );
}

const TOKEN = /(\*\*[^*]+\*\*|\*[^*]+\*|\[[^\]]+\]\([^)\s]+\))/g;

function inline(text: string): ReactNode {
  return frenchSpacing(text).split(TOKEN).map((part, i) => {
    if (part.startsWith("**") && part.endsWith("**")) return <strong key={i} className="font-semibold text-ink">{part.slice(2, -2)}</strong>;
    const link = part.match(/^\[([^\]]+)\]\(([^)\s]+)\)$/);
    if (link) {
      const href = safeHref(link[2]);
      if (!href) return link[1];
      const external = /^https?:/.test(href);
      return (
        <a key={i} href={href} className="text-accent-deep underline hover:text-ink" {...(external ? { target: "_blank", rel: "noreferrer" } : {})}>
          {link[1]}
        </a>
      );
    }
    if (part.startsWith("*") && part.endsWith("*") && part.length > 2) return <em key={i}>{part.slice(1, -1)}</em>;
    return <Fragment key={i}>{part}</Fragment>;
  });
}

/** Seuls les liens internes, http(s) et mailto passent : pas de
 * `javascript:` ni de schéma exotique depuis le back-office. */
function safeHref(href: string): string | null {
  return /^(\/(?!\/)|https?:\/\/|mailto:)/.test(href) ? href : null;
}
