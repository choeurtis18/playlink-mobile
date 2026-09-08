import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:playlink/app.dart';
import 'package:playlink/data/database.dart';
import 'package:playlink/data/providers.dart';

/// Vérifie le flux d'import à l'écran, sur un vrai appareil : rootBundle
/// fonctionne normalement ici (contrairement à `flutter test`, voir
/// full_game_flow.dart), donc pas de contournement nécessaire.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bouton + dégradé, retrait, puis import via la feuille',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        localeProvider.overrideWithValue(const Locale('fr')),
      ],
      child: const PlaylinkApp(),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.add_rounded);
    await tester.enterText(find.byType(TextField), 'Lina');
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.text('Lina'), findsOneWidget);
    await binding.takeScreenshot('01-player-added');

    // Un profil SANS historique et retiré de la session est supprimé, pas
    // désactivé (comportement voulu, couvert par player_import_test.dart).
    // Pour tester ici le vrai cas d'import, on simule une partie terminée
    // via la même API que B6, comme le ferait GameController._persist.
    final container = ProviderScope.containerOf(tester.element(find.byType(PlaylinkApp)));
    final notifier = container.read(playersProvider.notifier);
    final lina = notifier.inSession.firstWhere((p) => p.name == 'Lina');
    await notifier.applyGameResult(
      sessionScores: {lina.id: 12},
      cumulativeTagScores: {lina.id: {'humour': 3}},
    );
    await tester.pump();

    // Retrait — la liste doit se vider immédiatement (couvre le bug
    // ref.watch(.notifier) trouvé en test d'isolation) ; avec historique,
    // le profil est désactivé et retrouvable, pas supprimé.
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Lina'), findsNothing);
    await binding.takeScreenshot('02-player-removed');

    // Retaper le même nom déclenche la feuille d'import.
    await tester.enterText(find.byType(TextField), 'Lina');
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('03-import-sheet');
    expect(find.text('Lina existe déjà'), findsOneWidget);
    expect(find.textContaining('12 points'), findsOneWidget);

    await tester.tap(find.textContaining('Ajouter Lina'));
    await tester.pumpAndSettle();
    expect(find.text('Lina'), findsOneWidget);
    await binding.takeScreenshot('04-player-reimported');

    await db.close();
  });
}
