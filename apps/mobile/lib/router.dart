import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/config_screen.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/play_screen.dart';
import 'screens/players_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/players', builder: (_, _) => const PlayersScreen()),
      // Barre de navigation basse — Jouer / Classement / Profil (réf.
      // visuelle) : chaque onglet garde sa propre pile de navigation. Ne
      // couvre QUE les 3 écrans de la nav elle-même : la page d'un jeu, sa
      // config et la partie occupent tout l'écran, sans bottom nav (réf.
      // visuelle — aucun écran de jeu ne la montre).
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/leaderboard', builder: (_, _) => const LeaderboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
      // Hors shell : jeu, config et partie occupent tout l'écran.
      GoRoute(
        path: '/game/:slug',
        builder: (_, s) => GameScreen(slug: s.pathParameters['slug']!),
        routes: [
          GoRoute(
            path: 'config/:categoryId',
            builder: (_, s) => ConfigScreen(
              slug: s.pathParameters['slug']!,
              categoryId: s.pathParameters['categoryId']!,
            ),
          ),
        ],
      ),
      GoRoute(path: '/play', builder: (_, _) => const PlayScreen()),
    ],
  );
});
