import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content_repository.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/rich_text_lite.dart';

/// RulesModal : les slides illustrées du jeu, GIF embarqués (offline).
Future<void> showRulesSheet(BuildContext context, GameVm game) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => FractionallySizedBox(heightFactor: 0.9, child: _RulesBody(game: game)),
  );
}

class _RulesBody extends ConsumerStatefulWidget {
  const _RulesBody({required this.game});
  final GameVm game;

  @override
  ConsumerState<_RulesBody> createState() => _RulesBodyState();
}

class _RulesBodyState extends ConsumerState<_RulesBody> {
  final _ctrl = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider).languageCode;
    final slides = ref.watch(contentRepositoryProvider).slides(widget.game.id, locale);

    return FutureBuilder<List<SlideVm>>(
      future: slides,
      builder: (context, snap) {
        final list = snap.data ?? const <SlideVm>[];
        return Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: gameGradient(widget.game.colorMain, widget.game.colorSecondary, vertical: true),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(PlRadius.sheet)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t.rulesModalTitle,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19)),
                      ),
                      CircleButton(icon: Icons.close, onTap: () => Navigator.of(context).pop()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _ctrl,
                      itemCount: list.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (_, i) {
                        final s = list[i];
                        // Image fixe (ne scrolle pas) ; seul le texte défile
                        // en dessous — réf. visuelle.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (s.imageAsset != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(PlRadius.card),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.asset(s.imageAsset!, fit: BoxFit.cover, gaplessPlayback: true),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 10),
                                    RichTextLite(
                                      s.content,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                            height: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            if (list.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavArrow(
                      icon: Icons.chevron_left,
                      onTap: _page > 0
                          ? () => _ctrl.previousPage(duration: const Duration(milliseconds: 240), curve: Curves.easeOut)
                          : null,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < list.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _page ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _page ? hexColor(widget.game.colorMain) : Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                    _NavArrow(
                      icon: Icons.chevron_right,
                      onTap: _page + 1 < list.length
                          ? () => _ctrl.nextPage(duration: const Duration(milliseconds: 240), curve: Curves.easeOut)
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Flèche de navigation entre slides (‹ / ›), sur fond sombre — pas le style
/// translucide de `CircleButton` (réservé aux bandeaux dégradés).
class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.35 : 1,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: CircleBorder(side: BorderSide(color: Theme.of(context).dividerColor)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
