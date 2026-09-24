// Déroulé d'une partie de démo, en réducteur pur. Reprend
// apps/mobile/lib/core/session.dart et game/game_controller.dart, sans ce
// qui n'a pas de sens sur le web : ni tags, ni cumul entre parties, ni
// persistance. Tout reste dans la page (CLAUDE.md : la logique de jeu ne
// vit jamais sur un serveur).
//
// Une différence assumée avec l'app : l'écran « Passe le téléphone » et
// l'écran « C'est au tour de… » n'en font qu'un (carte face cachée + nom du
// joueur). Dans l'app, deux confirmations protègent la carte suivante des
// regards ; dans une démo sur ordinateur, la seconde n'est qu'un clic de
// plus.

export type DemoPlayer = { id: string; name: string; avatar: string };

export type DemoCard = { id: string; text: string; intensity: number };

export type Stage = "turn" | "card" | "vote" | "results";

export type GameState = {
  players: DemoPlayer[];
  deck: DemoCard[];
  /** Carte en cours (= nombre de cartes déjà jouées). */
  index: number;
  currentPlayer: number;
  scores: Record<string, number>;
  revealed: boolean;
  voting: boolean;
  hintsPerCard: number;
  hintsLeft: number;
};

/** Écran à afficher, dérivé de l'état — jamais stocké à part (comme
 * `GameStage` dans l'app). */
export function stageOf(s: GameState): Stage {
  if (s.index >= s.deck.length) return "results";
  if (s.voting) return "vote";
  if (s.revealed) return "card";
  return "turn";
}

export function startGame(players: DemoPlayer[], deck: DemoCard[], hintsPerCard = 0): GameState {
  return {
    players,
    deck,
    index: 0,
    currentPlayer: 0,
    scores: Object.fromEntries(players.map((p) => [p.id, 0])),
    revealed: false,
    voting: false,
    hintsPerCard,
    hintsLeft: hintsPerCard,
  };
}

export type Action =
  | { type: "reveal" }
  | { type: "useHint" }
  | { type: "openVote" }
  | { type: "vote"; point: boolean };

export function reduce(s: GameState, a: Action): GameState {
  const stage = stageOf(s);
  switch (a.type) {
    // Voir la carte ne la consomme pas : le compteur n'avance qu'au vote.
    case "reveal":
      return stage === "turn" ? { ...s, revealed: true } : s;
    case "useHint":
      return stage === "card" && s.hintsLeft > 0 ? { ...s, hintsLeft: s.hintsLeft - 1 } : s;
    case "openVote":
      return stage === "card" ? { ...s, voting: true } : s;
    // Le vote est obligatoire : c'est lui qui fait avancer la partie.
    case "vote": {
      if (stage !== "vote") return s;
      const player = s.players[s.currentPlayer];
      const scores = a.point ? { ...s.scores, [player.id]: (s.scores[player.id] ?? 0) + 1 } : s.scores;
      return {
        ...s,
        scores,
        index: s.index + 1,
        currentPlayer: (s.currentPlayer + 1) % s.players.length,
        revealed: false,
        voting: false,
        hintsLeft: s.hintsPerCard,
      };
    }
  }
}

/** Classement de fin : score décroissant, ordre de jeu en cas d'égalité
 * (tri stable). `tie` = plusieurs joueurs à égalité en tête. */
export function ranking(s: GameState): { ranked: (DemoPlayer & { score: number })[]; tie: boolean } {
  const ranked = s.players
    .map((p) => ({ ...p, score: s.scores[p.id] ?? 0 }))
    .sort((a, b) => b.score - a.score);
  return { ranked, tie: ranked.length > 1 && ranked[0].score === ranked[1].score };
}
