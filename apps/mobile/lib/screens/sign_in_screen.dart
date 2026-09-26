import 'dart:async';

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/sync_controller.dart';
import '../l10n/app_localizations.dart';

/// Connexion joueur (phase 4, §04) — instance Clerk JOUEURS, distincte de
/// celle des éditeurs back-office (CLAUDE.md : jamais mélanger les deux).
/// Reste 100 % optionnelle : toute la logique de jeu tourne déjà hors-ligne
/// sans compte (§01) — cet écran ne fait qu'ouvrir la porte, jamais la
/// bloquer (pas de garde de route dessus ailleurs dans l'app).
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClerkSignedOut(
                child: Column(
                  children: [
                    const ClerkAuthentication(),
                    // Lien maison vers notre propre écran de reset (§04) —
                    // celui intégré à `ClerkAuthentication` plante à la
                    // fermeture de sa modale (bug confirmé sur
                    // clerk_flutter 0.0.18-beta, la dernière version
                    // publiée). Éviter ce lien-là, utiliser celui-ci.
                    TextButton(
                      onPressed: () => context.push('/sign-in/forgot-password'),
                      child: Text(t.forgottenPasswordTitle),
                    ),
                  ],
                ),
              ),
              // Retour automatique dès la connexion réussie — inutile de
              // laisser l'utilisateur sur cet écran une fois authentifié.
              ClerkSignedIn(
                child: Builder(builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Lus AVANT la navigation : elle démonte cet écran, et
                    // tout ce qui dépend de son contexte devient alors
                    // inutilisable.
                    final authState = ClerkAuth.of(context, listen: false);
                    final syncController = ref.read(syncControllerProvider.notifier);

                    // Best-effort, ne bloque jamais la redirection (§04). Le
                    // rafraîchissement de l'UI qui suit la synchro vit dans le
                    // contrôleur, pas ici : il doit survivre au démontage de
                    // cet écran (voir sync_controller.dart).
                    unawaited(syncController.sync(authState));
                    if (context.mounted) context.go('/profile');
                  });
                  return Center(child: Text(t.signInSuccess));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fallback affiché à la place de [SignInScreen] quand aucune clé Clerk
/// n'a été fournie au build (dev avant configuration de l'instance) — pas
/// un écran d'erreur, juste une explication claire plutôt qu'un écran vide.
class SignInUnavailableScreen extends StatelessWidget {
  const SignInUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            t.signInUnavailable,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ),
      ),
    );
  }
}
