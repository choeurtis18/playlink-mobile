import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/player_avatar.dart';
import 'edit_player_sheet.dart';

/// A1/A2 : la liste des joueurs de la session, composée avant la home.
class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlayersTitle(start: t.playersTitleStart, highlight: t.playersTitleHighlight),
              const SizedBox(height: 8),
              Text(t.playersSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              const Expanded(child: PlayersEditor()),
              const SizedBox(height: 12),
              AccentButton(
                label: t.letsPlay,
                onPressed: ref.watch(playersProvider).any((p) => p.inSession)
                    ? () => context.go('/')
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Titre en deux temps (réf. visuelle) : texte fixe, puis les derniers mots
/// sur une pilule au dégradé accent.
class _PlayersTitle extends StatelessWidget {
  const _PlayersTitle({required this.start, required this.highlight});
  final String start, highlight;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        Text(start, style: Theme.of(context).textTheme.headlineMedium),
        DecoratedBox(
          decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.tile)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(highlight,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

/// Réutilisé par l'écran A1/A2 et par la modale de la home (B1).
///
/// N'affiche que les joueurs EN SESSION (« Dans cette partie ») — les autres
/// profils de l'appareil restent invisibles ici, ils ne servent qu'au
/// matching de nom (import) et au classement. Le champ ne sert qu'à taper un
/// prénom ; au clic sur +, un nom qui correspond à un profil existant
/// propose de l'importer plutôt que d'en créer un doublon.
class PlayersEditor extends ConsumerStatefulWidget {
  const PlayersEditor({super.key});

  @override
  ConsumerState<PlayersEditor> createState() => _PlayersEditorState();
}

class _PlayersEditorState extends ConsumerState<PlayersEditor> {
  final _name = TextEditingController();
  final _focus = FocusNode();
  String? _error;

  Future<void> _onAddPressed() async {
    final t = AppLocalizations.of(context);
    final notifier = ref.read(playersProvider.notifier);
    final raw = _name.text.trim();
    if (raw.isEmpty) return;

    // Un nom déjà en session est refusé net (deux joueurs, même prénom,
    // même soir : ambigu pour le vote comme pour les scores).
    final inSessionMatch = notifier.inSession
        .where((p) => p.name.toLowerCase() == raw.toLowerCase())
        .firstOrNull;
    if (inSessionMatch != null) {
      setState(() => _error = t.duplicatePlayer(inSessionMatch.name));
      return;
    }

    // Un profil existant mais pas dans la session ce soir : proposer de
    // l'importer plutôt que de forcer un renommage silencieux.
    final existing = notifier.findByName(raw);
    if (existing != null) {
      final choice = await _showExistingPlayerSheet(existing);
      if (choice == null) return; // annulé
      if (choice) {
        await notifier.import(existing.id);
        _name.clear();
        setState(() => _error = null);
        _focus.requestFocus();
        return;
      }
      // "Non, créer un nouveau profil" : on laisse la saisie en place,
      // le nom doit changer pour aboutir (contrainte : un nom = un profil).
      // Message distinct de `duplicatePlayer` : ce profil n'est PAS dans la
      // session ce soir, donc "joue déjà ce soir" serait faux.
      setState(() => _error = t.playerExistsChooseAnotherName(existing.name));
      return;
    }

    final err = await notifier.create(raw);
    if (!mounted) return;
    setState(() => _error = err == null ? null : t.needOnePlayer);
    if (err == null) {
      _name.clear();
      _focus.requestFocus();
    }
  }

  /// true = importer, false = créer un nouveau (nom à changer), null = annulé.
  Future<bool?> _showExistingPlayerSheet(LocalPlayer existing) {
    final t = AppLocalizations.of(context);
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(PlRadius.sheet)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PlayerAvatar(emoji: existing.avatar, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(t.playerExistsTitle(existing.name),
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                t.playerExistsBody(
                  existing.name,
                  t.pointsCount(existing.totalScore),
                  t.gamesCount(existing.gamesPlayed),
                ),
                style: const TextStyle(color: PlColors.inkSoft, height: 1.4),
              ),
              const SizedBox(height: 20),
              AccentButton(
                label: t.playerExistsImport(existing.name),
                onPressed: () => Navigator.pop(sheetContext, true),
              ),
              const SizedBox(height: 10),
              GhostButton(
                label: t.playerExistsRename,
                onPressed: () => Navigator.pop(sheetContext, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onEditPressed(LocalPlayer player) => showEditPlayerSheet(context, ref, player);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // ref.watch sur l'ÉTAT (la liste), pas sur .notifier : ce dernier ne
    // change jamais de référence, donc watcher .notifier ne déclenche aucun
    // rebuild quand un joueur est ajouté/retiré/importé.
    final players = ref.watch(playersProvider).where((p) => p.inSession).toList();
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _name,
                focusNode: _focus,
                autofocus: players.isEmpty,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onChanged: (_) => _error == null ? null : setState(() => _error = null),
                onSubmitted: (_) => _onAddPressed(),
                decoration: InputDecoration(hintText: t.playerNameHint, errorText: _error),
              ),
            ),
            const SizedBox(width: 10),
            _AddButton(onTap: _onAddPressed),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: players.isEmpty
              ? Center(child: Text(t.needOnePlayer, style: TextStyle(color: soft)))
              : ListView.separated(
                  itemCount: players.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = players[i];
                    return Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(PlRadius.tile),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(PlRadius.tile),
                        onTap: () => _onEditPressed(p),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(PlRadius.tile),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                          child: Row(
                            children: [
                              PlayerAvatar(emoji: p.avatar, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    // Visibles dès l'ajout à la session, comme demandé —
                                    // pas seulement après une partie déjà jouée.
                                    Text('${t.pointsCount(p.totalScore)} · ${t.gamesCount(p.gamesPlayed)}',
                                        style: const TextStyle(fontSize: 12, color: PlColors.neutral)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                color: soft,
                                onPressed: () => ref.read(playersProvider.notifier).remove(p.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Bouton "+" plein, dégradé accent (réf. utilisateur) — remplace le
/// FilledButton texte "Ajouter".
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.tile)),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(PlRadius.tile),
          onTap: onTap,
          child: const SizedBox(
            width: 54,
            height: 54,
            child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}
