const NNBSP = " ";

/** Espaces insécables de la typographie française : jamais de « ? » ou de
 * « » » rejeté seul en début de ligne. Les cartes viennent de la base avec
 * des espaces ordinaires ; on corrige à l'affichage plutôt que dans le
 * contenu, que l'app mobile affiche aussi. Sans effet sur un texte anglais. */
export function frenchSpacing(text: string): string {
  return text
    .replace(/ ([?!:;»])/g, `${NNBSP}$1`)
    .replace(/« /g, `«${NNBSP}`);
}
