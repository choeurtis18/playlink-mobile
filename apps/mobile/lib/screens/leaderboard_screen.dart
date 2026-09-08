import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/tag_mapping.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';
import '../widgets/player_avatar.dart';
import 'dart:convert';

/// D3 : classement des profils de l'appareil, calculé en local (jamais un
/// classement mondial — §01). Trié par score cumulé.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final players = [...ref.watch(playersProvider)]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
    const medals = ['🥇', '🥈', '🥉'];

    return Scaffold(
      backgroundColor: PlColors.ground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.leaderboardTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(t.leaderboardSubtitle, style: const TextStyle(color: PlColors.neutralFaint, fontSize: 13)),
              const SizedBox(height: 20),
              Expanded(
                child: players.isEmpty
                    ? Center(child: Text(t.noPlayersYet, style: const TextStyle(color: PlColors.neutralFaint)))
                    : ListView.separated(
                        itemCount: players.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final p = players[i];
                          final tagScores = (jsonDecode(p.tagScoresJson) as Map).cast<String, int>();
                          final archetype = getPlayerType(tagScores);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: PlColors.surface,
                              borderRadius: BorderRadius.circular(PlRadius.tile),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 26,
                                  child: Text(i < 3 ? medals[i] : '${i + 1}',
                                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
                                ),
                                const SizedBox(width: 10),
                                PlayerAvatar(emoji: p.avatar, size: 40),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                      Text(archetype, style: const TextStyle(color: PlColors.accent, fontSize: 12.5)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${p.totalScore} pts', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                    Text(t.gamesCount(p.gamesPlayed), style: const TextStyle(color: PlColors.neutralFaint, fontSize: 11.5)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
