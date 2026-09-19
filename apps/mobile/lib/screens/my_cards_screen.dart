import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content_repository.dart';
import '../data/custom_cards_repository.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import 'game_screen.dart' show categoriesProvider;
import 'home_screen.dart' show gamesProvider;

final myCardsListProvider = FutureProvider<List<CustomCardVm>>((ref) {
  return ref.watch(customCardsRepositoryProvider).all();
});

/// C1/C3 : liste des cartes créées sur l'appareil + CTA « Créer une
/// carte ». Fonctionne 100 % en local (voir `CustomCards`) — jamais
/// visible par un autre utilisateur (pas de compte en V1).
class MyCardsScreen extends ConsumerWidget {
  const MyCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    final cards = ref.watch(myCardsListProvider);
    final games = ref.watch(gamesProvider).value ?? const <GameVm>[];
    final gameById = {for (final g in games) g.id: g};

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myCards),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: games.isEmpty
                ? null
                : () => showEditCustomCardSheet(context, ref, games: games),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.myCardsSubtitle,
                style: TextStyle(
                  color: soft,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: cards.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (list) => list.isEmpty
                      ? Center(
                          child: Text(
                            t.myCardsEmpty,
                            style: TextStyle(color: soft),
                          ),
                        )
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final c = list[i];
                            final game = gameById[c.gameId];
                            return _CustomCardTile(
                              card: c,
                              game: game,
                              onTap: () => showEditCustomCardSheet(
                                context,
                                ref,
                                games: games,
                                existing: c,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomCardTile extends ConsumerWidget {
  const _CustomCardTile({
    required this.card,
    required this.game,
    required this.onTap,
  });
  final CustomCardVm card;
  final GameVm? game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(PlRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${game?.name ?? '—'} · ${card.active ? t.cardActive : t.cardInactive}',
                      style: TextStyle(
                        color: card.active
                            ? PlColors.success
                            : soft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: card.active,
                onChanged: (v) async {
                  // Toggle direct sans passer par la feuille d'édition
                  // (C2/C3) : activer/désactiver est l'action la plus
                  // fréquente, pas besoin d'ouvrir le formulaire pour ça.
                  await ref
                      .read(customCardsRepositoryProvider)
                      .setActive(card.id, v);
                  ref.invalidate(myCardsListProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formulaire de création OU d'édition (C1/C3) — jeu, catégorie, texte,
/// toggle actif (§14 : pas de champ intensité ni tags à ce formulaire).
Future<void> showEditCustomCardSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<GameVm> games,
  CustomCardVm? existing,
}) {
  final t = AppLocalizations.of(context);
  final textCtrl = TextEditingController(text: existing?.text ?? '');
  var selectedGameId = existing?.gameId ?? games.first.id;
  String? selectedCategoryId = existing?.categoryId;
  var active = existing?.active ?? true;
  String? error;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(PlRadius.sheet)),
    ),
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        // `Consumer` plutôt que `ref.watch` direct dans ce `builder` : ce
        // dernier n'est pas un vrai widget Riverpod, un provider qui
        // résout de façon async après le premier frame ne déclencherait
        // jamais de rebuild (la liste de catégories resterait vide).
        return Consumer(
          builder: (context, ref, _) {
            final categoriesAsync = ref.watch(
              categoriesProvider(selectedGameId),
            );
            final categories = categoriesAsync.value ?? const <CategoryVm>[];
            // Première catégorie du jeu par défaut, ou re-résolution si le jeu
            // change et que la catégorie choisie n'en fait plus partie.
            if (selectedCategoryId == null ||
                !categories.any((c) => c.id == selectedCategoryId)) {
              selectedCategoryId = categories.isNotEmpty
                  ? categories.first.id
                  : null;
            }

            Future<void> save() async {
              final text = textCtrl.text.trim();
              if (text.isEmpty) {
                setSheetState(() => error = t.createCardTextEmpty);
                return;
              }
              final categoryId = selectedCategoryId;
              if (categoryId == null) return;
              final repo = ref.read(customCardsRepositoryProvider);
              if (existing == null) {
                await repo.create(
                  gameId: selectedGameId,
                  categoryId: categoryId,
                  text: text,
                );
              } else {
                await repo.updateText(existing.id, text);
                if (active != existing.active) {
                  await repo.setActive(existing.id, active);
                }
              }
              ref.invalidate(myCardsListProvider);
              if (sheetContext.mounted) Navigator.pop(sheetContext);
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                28,
                24,
                MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? t.createCardTitle : t.editCardTitle,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: selectedGameId,
                      decoration: InputDecoration(labelText: t.createCardGame),
                      items: [
                        for (final g in games)
                          DropdownMenuItem(value: g.id, child: Text(g.name)),
                      ],
                      onChanged: existing != null
                          ? null // pas de changement de jeu à l'édition : garde l'existant simple.
                          : (v) => setSheetState(() {
                              selectedGameId = v!;
                              selectedCategoryId = null;
                            }),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      // `initialValue` n'est lu qu'à la création du widget —
                      // une `key` qui change avec la sélection force sa
                      // recréation pour refléter la catégorie par défaut dès
                      // que `categoriesProvider` a fini de charger.
                      key: ValueKey('category-$selectedCategoryId'),
                      initialValue: selectedCategoryId,
                      decoration: InputDecoration(
                        labelText: t.createCardCategory,
                      ),
                      items: [
                        for (final c in categories)
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ],
                      onChanged: existing != null
                          ? null
                          : (v) => setSheetState(() => selectedCategoryId = v),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: textCtrl,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: t.createCardTextHint,
                        errorText: error,
                      ),
                      onChanged: (_) => error == null
                          ? null
                          : setSheetState(() => error = null),
                    ),
                    if (existing != null) ...[
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.createCardActive, style: const TextStyle(fontSize: 13.5)),
                        value: active,
                        onChanged: (v) => setSheetState(() => active = v),
                      ),
                    ],
                    const SizedBox(height: 20),
                    AccentButton(label: t.createCardSave, onPressed: save),
                    if (existing != null) ...[
                      const SizedBox(height: 10),
                      GhostButton(
                        label: t.deleteCard,
                        onPressed: () async {
                          final confirmed = await _confirmDelete(sheetContext);
                          if (confirmed != true) return;
                          await ref
                              .read(customCardsRepositoryProvider)
                              .delete(existing.id);
                          ref.invalidate(myCardsListProvider);
                          if (sheetContext.mounted) Navigator.pop(sheetContext);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

Future<bool?> _confirmDelete(BuildContext context) {
  final t = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.deleteCardConfirmTitle),
      content: Text(t.deleteCardConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(t.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(t.deleteCard),
        ),
      ],
    ),
  );
}
