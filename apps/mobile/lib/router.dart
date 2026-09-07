import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/config_screen.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/play_screen.dart';
import 'screens/players_screen.dart';
import 'screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/players', builder: (_, _) => const PlayersScreen()),
      GoRoute(
        path: '/',
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'game/:slug',
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
        ],
      ),
      GoRoute(path: '/play', builder: (_, _) => const PlayScreen()),
    ],
  );
});
