import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_sync.dart';
import 'providers.dart';

/// État de la dernière synchro déclenchée — `syncing` sert aussi à savoir
/// qu'une synchro est déjà en vol (voir la garde dans [SyncController.sync]).
enum SyncStatus { idle, syncing, success, failure }

/// Seul détenteur de la séquence « synchroniser puis rafraîchir l'UI ».
///
/// Écrire en base ne suffit pas : les providers qui lisent ces tables
/// (joueurs, cartes perso, badges) ne se recalculent pas tout seuls, il faut
/// les invalider — c'est déjà la convention du projet après chaque écriture
/// (voir `game_controller.dart`, `my_cards_screen.dart`).
///
/// La raison d'être de ce contrôleur est le CYCLE DE VIE. La synchro
/// automatique est lancée depuis l'écran de connexion, qui navigue aussitôt
/// vers le profil : le widget appelant est démonté bien avant la fin de
/// l'opération, et son `WidgetRef` devient inutilisable. Le `ref` d'un
/// `Notifier` appartient lui au `ProviderContainer` (le `ProviderScope` de
/// `main.dart`), jamais démonté par la navigation — le rafraîchissement a
/// donc toujours lieu, quel que soit le sort de l'appelant.
class SyncController extends Notifier<SyncStatus> {
  Future<bool>? _inFlight;

  @override
  SyncStatus build() => SyncStatus.idle;

  /// Synchronise puis rafraîchit. Renvoie true si l'aller-retour a abouti.
  ///
  /// [authState] est un paramètre plutôt qu'une lecture : aucun provider
  /// n'expose Clerk, qui vit dans l'arbre de widgets sous `MaterialApp`. Seul
  /// un appelant disposant d'un `BuildContext` sous `ClerkAuth` peut le
  /// fournir — d'où le type nullable, qui couvre aussi le cas d'un build
  /// sans clé Clerk (`clerkConfigured == false`) et rend ce contrôleur
  /// testable sans instancier le SDK.
  Future<bool> sync(ClerkAuthState? authState) {
    // Une synchro déjà en vol est partagée plutôt que relancée : le bouton
    // manuel peut être tapé pendant que la synchro automatique tourne encore.
    return _inFlight ??= _run(authState).whenComplete(() => _inFlight = null);
  }

  Future<bool> _run(ClerkAuthState? authState) async {
    state = SyncStatus.syncing;

    final override = ref.read(syncAccountOverrideProvider);
    final run = override ??
        (authState == null ? null : () => syncAccount(authState, ref.read(databaseProvider)));
    final ok = run == null ? false : await run();

    // Invalidé même en échec : la descente (`_pullGameData`) s'exécute avant
    // la montée, une partie des données peut donc être arrivée avant l'erreur.
    ref.invalidate(myCardsListProvider);
    ref.invalidate(badgesListProvider);
    if (ok) await ref.read(playersProvider.notifier).load();

    state = ok ? SyncStatus.success : SyncStatus.failure;
    return ok;
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncStatus>(SyncController.new);

/// null par défaut (chemin normal : `syncAccount`). Les tests le surchargent
/// pour éviter tout appel réseau — `ClerkAuthState` est une classe concrète
/// du SDK Clerk, non simulable raisonnablement.
final syncAccountOverrideProvider = Provider<Future<bool> Function()?>((ref) => null);
