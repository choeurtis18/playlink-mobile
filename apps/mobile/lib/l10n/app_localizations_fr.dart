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
  String get onboardingAnalyticsTitle => 'Des stats, pas des données';

  @override
  String get onboardingAnalyticsBody =>
      'On mesure ce qui est joué pour améliorer le contenu. Jamais d\'email, jamais de nom, jamais le texte de tes réponses.';

  @override
  String get onboardingAnalyticsToggleTitle => 'Partager des stats anonymes';

  @override
  String get onboardingAnalyticsToggleBody =>
      'Aucun email, aucun nom, aucun texte de carte';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get skip => 'Passer';

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
  String get voteIsMandatory =>
      'Le vote est obligatoire — c\'est lui qui fait avancer le compteur.';

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
  String get goHome => 'Accueil';

  @override
  String get shareScore => 'Partager le score';

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

  @override
  String get navPlay => 'Jouer';

  @override
  String get navLeaderboard => 'Classement';

  @override
  String get navProfile => 'Profil';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get leaderboardSubtitle => 'Entre tes profils · calculé en local';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileLocalMode => 'Mode local — aucun compte';

  @override
  String get profileLocalCardTitle => 'Tout marche sans compte';

  @override
  String get profileLocalCardBody =>
      'Parties, badges et historique vivent sur cet appareil. Un compte sert à sauvegarder, créer des cartes et liker.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get myCards => 'Mes cartes';

  @override
  String get likedCards => 'Cartes likées';

  @override
  String get settings => 'Réglages';

  @override
  String get settingsSubtitle => 'Langue, thème, confidentialité';

  @override
  String get noPlayersYet => 'Ajoute des joueurs pour voir le classement';

  @override
  String get offlineReady => 'Hors-ligne prêt';

  @override
  String get playersEdit => 'Modifier';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties',
      one: '1 partie',
      zero: '0 partie',
    );
    return '$_temp0';
  }
}
