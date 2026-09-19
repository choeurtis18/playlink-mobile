import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/data/custom_cards_repository.dart';
import 'package:playlink/data/database.dart';

void main() {
  late AppDatabase db;
  late CustomCardsRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = CustomCardsRepository(db);
    // `CustomCards` référence gameId/categoryId par clé étrangère : ces
    // lignes de contenu factices existent uniquement pour satisfaire la
    // contrainte, leur contenu réel n'a aucune importance ici.
    await db.into(db.games).insert(GamesCompanion.insert(
          id: 'g1', slug: 'g1', name: 'Jeu', colorMain: '#000000', colorSecondary: '#000000', sortOrder: 0,
        ));
    await db.into(db.categories).insert(CategoriesCompanion.insert(
          id: 'c1', gameId: 'g1', slug: 'c1', name: 'Catégorie 1', sortOrder: 0,
        ));
    await db.into(db.categories).insert(CategoriesCompanion.insert(
          id: 'c2', gameId: 'g1', slug: 'c2', name: 'Catégorie 2', sortOrder: 1,
        ));
  });

  tearDown(() async => db.close());

  test('create() puis all() renvoie la carte, active par défaut', () async {
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'Ma carte perso');
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(all.single.text, 'Ma carte perso');
    expect(all.single.active, isTrue);
    expect(all.single.intensity, 3, reason: 'pas de champ intensité au formulaire (§14) : Normal par défaut');
  });

  test('activeFor() ne renvoie que les cartes actives de CETTE catégorie', () async {
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'Active c1');
    await repo.create(gameId: 'g1', categoryId: 'c2', text: 'Active c2');
    final inactive = await repo.all();
    await repo.setActive(inactive.firstWhere((c) => c.text == 'Active c1').id, false);

    final activeC1 = await repo.activeFor('c1');
    expect(activeC1, isEmpty, reason: 'désactivée, ne doit plus entrer dans le pool de tirage (C2)');

    final activeC2 = await repo.activeFor('c2');
    expect(activeC2, hasLength(1));
    expect(activeC2.single.text, 'Active c2');
  });

  test('setActive(false) désactive sans supprimer', () async {
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'Carte');
    final card = (await repo.all()).single;
    await repo.setActive(card.id, false);

    final all = await repo.all();
    expect(all, hasLength(1), reason: 'toujours en base — désactiver n\'est pas une suppression déguisée');
    expect(all.single.active, isFalse);
  });

  test('updateText() change le texte, delete() la retire vraiment', () async {
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'Avant');
    final card = (await repo.all()).single;

    await repo.updateText(card.id, 'Après');
    expect((await repo.all()).single.text, 'Après');

    await repo.delete(card.id);
    expect(await repo.all(), isEmpty);
  });

  test('countAll() compte toutes les cartes, actives et inactives', () async {
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'A');
    await repo.create(gameId: 'g1', categoryId: 'c1', text: 'B');
    final b = (await repo.all()).firstWhere((c) => c.text == 'B');
    await repo.setActive(b.id, false);

    expect(await repo.countAll(), 2);
  });
}
