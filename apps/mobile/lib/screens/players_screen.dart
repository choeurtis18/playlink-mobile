import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/player_avatar.dart';

/// A1/A2 : la liste des joueurs de la session, composée avant la home.
class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PlColors.ground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlayersTitle(start: t.playersTitleStart, highlight: t.playersTitleHighlight),
              const SizedBox(height: 8),
              Text(t.playersSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
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
class PlayersEditor extends ConsumerStatefulWidget {
  const PlayersEditor({super.key});

  @override
  ConsumerState<PlayersEditor> createState() => _PlayersEditorState();
}

class _PlayersEditorState extends ConsumerState<PlayersEditor> {
  final _name = TextEditingController();
  final _focus = FocusNode();
  String? _error;

  Future<void> _add() async {
    final t = AppLocalizations.of(context);
    final err = await ref.read(playersProvider.notifier).add(_name.text);
    if (!mounted) return;
    setState(() {
      _error = switch (err) {
        AddPlayerError.duplicate => t.duplicatePlayer,
        AddPlayerError.empty => null,
        null => null,
      };
    });
    if (err == null) {
      _name.clear();
      _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final players = ref.watch(playersProvider);
    final notifier = ref.read(playersProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _name,
                focusNode: _focus,
                autofocus: players.isEmpty,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _add(),
                decoration: InputDecoration(hintText: t.playerNameHint, errorText: _error),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _add,
                style: FilledButton.styleFrom(minimumSize: const Size(0, 54)),
                child: Text(t.addPlayer),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: players.isEmpty
              ? Center(child: Text(t.needOnePlayer, style: const TextStyle(color: PlColors.neutralFaint)))
              : ListView.separated(
                  itemCount: players.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = players[i];
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 160),
                      opacity: p.inSession ? 1 : 0.45,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(PlRadius.tile),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                        child: Row(
                          children: [
                            PlayerAvatar(emoji: p.avatar, size: 40),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  if (p.gamesPlayed > 0)
                                    Text('${p.totalScore} pts · ${p.gamesPlayed} 🎮',
                                        style: const TextStyle(fontSize: 12, color: PlColors.neutral)),
                                ],
                              ),
                            ),
                            Switch(
                              value: p.inSession,
                              onChanged: (v) => notifier.setInSession(p.id, v),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              color: PlColors.neutralFaint,
                              onPressed: () => notifier.remove(p.id),
                            ),
                          ],
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
