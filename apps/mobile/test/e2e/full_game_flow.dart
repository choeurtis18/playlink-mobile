import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/app.dart';
import 'package:playlink/data/content_seeder.dart';
import 'package:playlink/data/database.dart';
import 'package:playlink/data/providers.dart';

/// `rootBundle.loadString` sur le snapshot embarqué (340 Ko) n'aboutit
/// jamais sous `flutter test` (un appareil réel ou un test d'intégration
/// n'ont pas cette limite), et il en va de même pour un `File.readAsString`
/// ordinaire dans ce contexte. La seule voie qui fonctionne est de sortir
/// l'I/O de la fake-async zone via `tester.runAsync` — mais AVANT de pumper
/// l'UI, jamais pendant une boucle de pump : une boucle serrée de
/// `tester.pump` accapare le thread au point d'empêcher `runAsync` de
/// jamais progresser (testé : il ne reprend qu'une fois la boucle arrêtée).
/// Le contenu est donc appliqué à la base avant `pumpWidget`, et le provider
/// de seed devient un no-op côté widget.
Future<void> _seedFromDisk(WidgetTester tester, AppDatabase db) {
  return tester.runAsync(() async {
    final path = File('assets/content/content_v1.json').existsSync()
        ? 'assets/content/content_v1.json'
        : '../assets/content/content_v1.json';
    final raw = await File(path).readAsString();
    await applySnapshot(db, jsonDecode(raw) as Map<String, dynamic>);
  });
}

typedef Shot = Future<void> Function(String name);

Future<void> pumpUntil(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 90)}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      throw TestFailure('Introuvable après $timeout : $finder');
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

/// Joue une partie complète, A1 → B6, sur une base en mémoire seedée
/// depuis le snapshot embarqué. Partagé par le test widget (rapide) et le
/// test d'intégration (captures d'écran sur simulateur).
///
/// `useRealAssetBundle` : true sur un appareil/simulateur réel (le test
/// d'intégration), où `rootBundle` fonctionne normalement et vaut la peine
/// d'être exercé tel quel. false sous `flutter test` (VM headless), où le
/// même appel bloque indéfiniment sur ce snapshot — voir `_diskSeed`.
Future<void> playFullGame(
  WidgetTester tester, {
  Shot? shot,
  bool useRealAssetBundle = false,
}) async {
  final db = AppDatabase(NativeDatabase.memory());
  Future<void> snap(String n) async => shot == null ? null : await shot(n);

  // Le seed a lieu AVANT de pumper l'UI (voir _seedFromDisk) : une boucle
  // de pump qui suivrait affamerait le vrai I/O nécessaire pour l'appliquer.
  if (!useRealAssetBundle) await _seedFromDisk(tester, db);

  await tester.pumpWidget(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      // Contenu déjà en base ci-dessus : le provider n'a rien à faire.
      if (!useRealAssetBundle) seedOverrideProvider.overrideWithValue(() async {}),
      // Le test pilote l'UI en français, quelle que soit la machine.
      localeProvider.overrideWithValue(const Locale('fr')),
    ],
    child: const PlaylinkApp(),
  ));

  // A1 — splash : seed des 1521 cartes puis onboarding.
  await pumpUntil(tester, find.text('Suivant'));
  await tester.pumpAndSettle();
  await snap('01-onboarding');
  await tapText(tester, 'Suivant');
  await tapText(tester, 'Suivant');
  await snap('02-onboarding-analytics');
  await tapText(tester, 'Commencer');

  // A1 — joueurs de la session.
  // Le titre est scindé en deux widgets (texte fixe + pilule dégradée).
  expect(find.text('Qui joue'), findsOneWidget);
  expect(find.text('ce soir ?'), findsOneWidget);
  // Le bouton d'ajout est une icône + (dégradé accent), plus un texte.
  final addButton = find.byIcon(Icons.add_rounded);
  await tester.enterText(find.byType(TextField), 'Lina');
  await tester.tap(addButton);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'Sam');
  await tester.tap(addButton);
  await tester.pumpAndSettle();
  expect(find.text('Lina'), findsOneWidget);
  expect(find.text('Sam'), findsOneWidget);
  await snap('03-players');
  await tapText(tester, "C'est parti");

  // B1 — home : les 8 jeux. La grille dépasse l'écran, certains n'y sont
  // visibles qu'après scroll.
  expect(find.text('Choisis un jeu'), findsOneWidget);
  expect(find.text('2 joueurs'), findsOneWidget);
  final grid = find.byType(Scrollable).first;
  for (final g in ['Action ou Vérité', 'Icebreaker', 'Mime', 'Dilemme']) {
    await tester.scrollUntilVisible(find.text(g), 200, scrollable: grid);
    expect(find.text(g), findsOneWidget, reason: 'jeu absent de la home : $g');
  }
  await snap('04-home');
  // La tuile visée peut être ailleurs que dans la fenêtre courante après les
  // scrolls précédents ; on la ramène en vue avant de la taper.
  await tester.scrollUntilVisible(find.text('Action ou Vérité'), -200, scrollable: grid);
  await tapText(tester, 'Action ou Vérité');

  // B1 — page du jeu, catégories.
  expect(find.text('Vérités légères'), findsOneWidget);
  await snap('05-game');
  await tapText(tester, 'Vérités légères');

  // B2 — config.
  expect(find.text('Lancer la partie'), findsOneWidget);
  expect(find.text('Normal'), findsWidgets); // intensité 3 par défaut
  await snap('06-config');
  await tapText(tester, 'Lancer la partie');

  // B3 → B5 en boucle, 10 cartes, votes alternés Oui/Non.
  var votes = 0;
  var guard = 0;
  final over = find.text('Partie terminée 🎉');
  while (over.evaluate().isEmpty && guard++ < 80) {
    if (find.text('Voir la carte').evaluate().isNotEmpty) {
      if (votes == 0) await snap('07-turn');
      await tapText(tester, 'Voir la carte');
      if (votes == 0) await snap('08-card');
    } else if (find.text('Voter').evaluate().isNotEmpty) {
      await tapText(tester, 'Voter');
      if (votes == 0) await snap('09-vote');
    } else if (find.text('Oui').evaluate().isNotEmpty) {
      // Le bouton empile emoji et libellé (réf. visuelle) : on tape sur le
      // libellé seul plutôt que sur un texte combiné qui n'existe plus.
      await tapText(tester, votes.isEven ? 'Oui' : 'Non');
      votes++;
    } else if (find.text('Je suis prêt').evaluate().isNotEmpty) {
      if (votes == 1) await snap('10-pass');
      await tapText(tester, 'Je suis prêt');
    } else {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }
  expect(votes, 10, reason: 'le vote est obligatoire : 10 cartes ⇒ 10 votes');

  // B6 — résultats : Lina (joueur 0, cartes paires) a gagné 5 points.
  expect(over, findsOneWidget);
  expect(find.text('5 pts'), findsOneWidget);
  expect(find.text('0 pt'), findsOneWidget);
  await snap('11-results');

  final sessions = await db.select(db.gameSessions).get();
  expect(sessions, hasLength(1));
  expect(sessions.single.cardsPlayed, 10);
  expect(sessions.single.playerCount, 2);
  final sp = await db.select(db.sessionPlayers).get();
  expect(sp.map((r) => r.score).toSet(), {5, 0});
  final players = await db.select(db.localPlayers).get();
  final lina = players.firstWhere((p) => p.name == 'Lina');
  expect(lina.totalScore, 5);
  expect(lina.gamesPlayed, 1);
  expect(lina.tagScoresJson, isNot('{}'), reason: 'les tags gagnés cumulent sur le profil');

  // B7 — Rejouer : retour à la config du même jeu.
  await tapText(tester, 'Rejouer');
  expect(find.text('Lancer la partie'), findsOneWidget);

  await db.close();
}
