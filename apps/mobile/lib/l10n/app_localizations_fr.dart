// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Playlink';

  @override
  String get splashTagline => 'Les jeux qui font parler';

  @override
  String get onboardingHowTitle => 'Un téléphone, tout le groupe';

  @override
  String get onboardingHowBody =>
      'On choisit un jeu, on se passe le téléphone. À ton tour : tu ouvres la carte, tu joues, le groupe vote.';

  @override
  String get onboardingAccountTitle => 'Aucun compte requis';

  @override
  String get onboardingAccountBody =>
      'Tout marche hors-ligne. Un compte, plus tard, servira seulement à sauvegarder ta progression.';

  @override
  String get onboardingAnalyticsTitle => 'Nous aider à améliorer Playlink';

  @override
  String get onboardingAnalyticsBody =>
      'Des statistiques anonymes, sans nom ni e-mail. Tu peux refuser, rien ne change.';

  @override
  String get onboardingAnalyticsAccept => 'J\'accepte';

  @override
  String get onboardingAnalyticsDecline => 'Sans moi';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get playersTitle => 'Qui joue ce soir ?';

  @override
  String get playersSubtitle =>
      'Ajoute les joueurs autour du téléphone. Tu pourras changer la liste à tout moment.';

  @override
  String get playerNameHint => 'Prénom';

  @override
  String get addPlayer => 'Ajouter';

  @override
  String get duplicatePlayer => 'Ce prénom est déjà utilisé';

  @override
  String get needOnePlayer => 'Ajoute au moins un joueur';

  @override
  String get letsPlay => 'C\'est parti';

  @override
  String get homeTitle => 'Choisis un jeu';

  @override
  String playersButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs',
      one: '1 joueur',
    );
    return '$_temp0';
  }

  @override
  String cardsCount(int count) {
    return '$count cartes';
  }

  @override
  String get categoriesTitle => 'Catégories';

  @override
  String get rules => 'Règles';

  @override
  String get chooseCategory => 'Choisis une catégorie';

  @override
  String get preview => 'Aperçu';

  @override
  String get intensity => 'Intensité';

  @override
  String get difficulty => 'Difficulté';

  @override
  String get cardsPerGame => 'Cartes par partie';

  @override
  String get startGame => 'Lancer la partie';

  @override
  String get yourTurn => 'C\'est à ton tour !';

  @override
  String get seeCard => 'Voir la carte';

  @override
  String turnOf(String name) {
    return 'C\'est au tour de $name';
  }

  @override
  String get vote => 'Voter';

  @override
  String hintsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count indices restants',
      one: '1 indice restant',
      zero: 'Plus d\'indice',
    );
    return '$_temp0';
  }

  @override
  String get useHint => 'Indice utilisé';

  @override
  String deservesPoint(String name) {
    return 'Est-ce que $name mérite un point ?';
  }

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String passPhoneTo(String name) {
    return 'Passe le téléphone à $name';
  }

  @override
  String get passPhoneHint =>
      'La carte suivante reste cachée jusqu\'à ce qu\'il confirme.';

  @override
  String get imReady => 'Je suis prêt';

  @override
  String get gameOver => 'Partie terminée 🎉';

  @override
  String sessionScore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pts',
      one: '1 pt',
      zero: '0 pt',
    );
    return '$_temp0';
  }

  @override
  String totalScore(int count) {
    return 'Total : $count';
  }

  @override
  String get replay => 'Rejouer';

  @override
  String get goHome => 'Retour à l\'accueil';

  @override
  String cardOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get quitGame => 'Quitter la partie ?';

  @override
  String get quitGameBody => 'Les points de cette partie seront perdus.';

  @override
  String get quit => 'Quitter';

  @override
  String get loadingContent => 'Préparation des cartes…';
}
