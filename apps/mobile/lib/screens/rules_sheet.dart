import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content_repository.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
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
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: PlColors.hairlineFirm, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  Text(widget.game.icon ?? '', style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${t.rules} · ${widget.game.name}', style: Theme.of(context).textTheme.titleLarge)),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                ],
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
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (s.imageAsset != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(PlRadius.card),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.asset(s.imageAsset!, fit: BoxFit.cover, gaplessPlayback: true),
                                  ),
                                ),
                              const SizedBox(height: 18),
                              Text(s.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 10),
                              RichTextLite(s.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PlColors.inkSoft, height: 1.5)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (list.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Row(
                  children: [
                    for (var i = 0; i < list.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 5),
                        width: i == _page ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _page ? hexColor(widget.game.colorMain) : PlColors.hairlineFirm,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: _page + 1 < list.length
                          ? () => _ctrl.nextPage(duration: const Duration(milliseconds: 240), curve: Curves.easeOut)
                          : () => Navigator.of(context).pop(),
                      child: Text(_page + 1 < list.length ? t.next : t.ok),
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
