import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';

/// Feuille d'édition du nom et de l'avatar d'un profil — partagée par la
/// liste des joueurs (A1/B1) et l'écran des résultats de fin de partie, tap
/// sur une tuile joueur dans les deux cas. Le nom reste unique sur
/// l'appareil (même règle qu'à la création) — vérifié par `updateProfile`,
/// jamais côté UI seule.
Future<void> showEditPlayerSheet(BuildContext context, WidgetRef ref, LocalPlayer player) {
  final t = AppLocalizations.of(context);
  final nameCtrl = TextEditingController(text: player.name);
  var avatar = player.avatar;
  String? error;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(PlRadius.sheet)),
    ),
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        Future<void> save() async {
          final err = await ref
              .read(playersProvider.notifier)
              .updateProfile(player.id, name: nameCtrl.text, avatar: avatar);
          if (err == null) {
            if (sheetContext.mounted) Navigator.pop(sheetContext);
          } else {
            setSheetState(() => error = switch (err) {
                  UpdatePlayerError.empty => t.needOnePlayer,
                  UpdatePlayerError.nameTaken => t.editPlayerNameTaken,
                });
          }
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 28, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.editPlayerTitle(player.name), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: t.editPlayerName, errorText: error),
                  onChanged: (_) => error == null ? null : setSheetState(() => error = null),
                ),
                const SizedBox(height: 20),
                Builder(builder: (context) {
                  final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
                  return Text(t.editPlayerAvatar.toUpperCase(),
                      style: TextStyle(color: soft, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600));
                }),
                const SizedBox(height: 10),
                // 20 avatars sur 2 lignes, scroll horizontal — une grille
                // à défilement horizontal plutôt qu'une simple liste, pour
                // que chaque "page" visible en montre deux fois plus.
                SizedBox(
                  height: 116,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: avatarPool.length,
                    itemBuilder: (_, i) {
                      final emoji = avatarPool[i];
                      return _AvatarChoice(
                        emoji: emoji,
                        selected: emoji == avatar,
                        onTap: () => setSheetState(() => avatar = emoji),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                AccentButton(label: t.editPlayerSave, onPressed: save),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({required this.emoji, required this.selected, required this.onTap});
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: selected ? accentGradient : null,
          color: selected ? null : (scheme.brightness == Brightness.dark ? PlColors.raisedHigh : scheme.surfaceContainerHighest),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
