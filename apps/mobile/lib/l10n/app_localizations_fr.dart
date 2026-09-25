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
  String get splashTagline => 'Les jeux qui délient les langues';

  @override
  String get onboardingHowTitle => 'Un téléphone pour tout le groupe';

  @override
  String get onboardingHowBody =>
      'On choisit un jeu, on se passe le téléphone. À ton tour : tu ouvres la carte, tu joues, le groupe vote si tu mérites ou non un point, tu passes le téléphone à la personne suivante.';

  @override
  String get onboardingAccountTitle => 'Aucun compte requis';

  @override
  String get onboardingAccountBody =>
      'Tout marche hors-ligne. Mais tu peux créer un compte et débloquer des fonctionnalités supplémentaires !';

  @override
  String get onboardingAnalyticsTitle => 'Des stats, pas des données';

  @override
  String get onboardingAnalyticsBody =>
      'On mesure ce qui est joué pour améliorer le contenu. Aucunes données personnelles ne sont exploitées, jamais d\'email, jamais de nom, jamais le texte de tes réponses.';

  @override
  String get onboardingAnalyticsToggleTitle =>
      'Partager ses stats anonymement pour aider à améliorer le jeu.';

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
  String get playersTitleStart => 'Qui joue';

  @override
  String get playersTitleHighlight => 'ce soir ?';

  @override
  String get playersSubtitle =>
      'Ajoute au moins 1 joueur pour commencer. Tu pourras changer la liste à tout moment !';

  @override
  String get playerNameHint => 'Prénom';

  @override
  String get addPlayer => 'Ajouter';

  @override
  String duplicatePlayer(String name) {
    return '$name joue déjà ce soir';
  }

  @override
  String get needOnePlayer => 'Ajoute au moins un joueur';

  @override
  String playerExistsTitle(String name) {
    return '$name existe déjà';
  }

  @override
  String playerExistsBody(String name, String points, String games) {
    return 'Tu as déjà un profil $name sur cet appareil, avec $points et $games.';
  }

  @override
  String playerExistsImport(String name) {
    return 'Ajouter $name';
  }

  @override
  String get playerExistsRename => 'Non, créer un nouveau profil';

  @override
  String editPlayerTitle(String name) {
    return 'Modifier $name';
  }

  @override
  String get editPlayerName => 'Prénom';

  @override
  String get editPlayerAvatar => 'Avatar';

  @override
  String get editPlayerSave => 'Enregistrer';

  @override
  String get editPlayerNameTaken => 'Ce prénom est déjà utilisé';

  @override
  String playerExistsChooseAnotherName(String name) {
    return '$name existe déjà, choisis un autre nom';
  }

  @override
  String pointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
      zero: '0 point',
    );
    return '$_temp0';
  }

  @override
  String get letsPlay => 'C\'est parti';

  @override
  String get homeTitleStart_1 => 'Quel jeu';

  @override
  String get homeTitleHighlight => 'oseras-tu';

  @override
  String get homeTitleStart_2 => 'tester ?';

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
  String categoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count catégories',
      one: '1 catégorie',
      zero: '0 catégorie',
    );
    return '$_temp0';
  }

  @override
  String get categoriesTitle => 'Catégories';

  @override
  String get rules => 'Règles';

  @override
  String get rulesModalTitle => 'Règle du jeu';

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
  String get dontPeekHint =>
      'Ne regarde pas l\'écran tant que ce n\'est pas ton tour.';

  @override
  String itsMe(String name) {
    return 'C\'est moi, $name';
  }

  @override
  String get imReady => 'Je suis prêt';

  @override
  String get gameOver => 'Partie terminée 🎉';

  @override
  String winnerAnnounce(String name) {
    return '$name remporte la manche';
  }

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
  String get navPlay => 'Jeux';

  @override
  String get navLeaderboard => 'Classement';

  @override
  String get navProfile => 'Profil';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get leaderboardSubtitle => 'Alors qui est le meilleur joueur ?';

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
  String get profileSignedInTitle => 'Compte connecté';

  @override
  String get profileSignedInFallback => 'Connecté';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get myCards => 'Mes cartes';

  @override
  String get myCardsSubtitle =>
      'Tes cartes, jouables dès qu\'elles sont actives — jamais visibles par personne d\'autre';

  @override
  String get myCardsEmpty => 'Aucune carte créée pour l\'instant';

  @override
  String get createCardCta => 'Créer une carte';

  @override
  String get createCardTitle => 'Nouvelle carte';

  @override
  String get editCardTitle => 'Modifier la carte';

  @override
  String get createCardGame => 'Jeu';

  @override
  String get createCardCategory => 'Catégorie';

  @override
  String get createCardTextHint => 'Texte de la carte';

  @override
  String get createCardTextEmpty =>
      'Le texte de la carte ne peut pas être vide';

  @override
  String get createCardActive => 'Activer la carte pour qu\'elle soit jouable';

  @override
  String get createCardSave => 'Enregistrer';

  @override
  String get deleteCard => 'Supprimer';

  @override
  String get deleteCardConfirmTitle => 'Supprimer cette carte ?';

  @override
  String get deleteCardConfirmBody => 'Cette action est définitive.';

  @override
  String get cardActive => 'Active';

  @override
  String get cardInactive => 'Inactive';

  @override
  String get likedCards => 'Cartes likées';

  @override
  String get settings => 'Réglages';

  @override
  String get settingsSubtitle => 'Langue, thème, autres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageBody =>
      'FR/EN — recharge l\'interface et bascule le contenu (les cartes non traduites restent en français)';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'Anglais';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get noPlayersYet => 'Ajoute des joueurs pour voir le classement';

  @override
  String get badgeUnlockedTitle => 'Félicitations !';

  @override
  String get badgeUnlockedBody => 'Tu as débloqué le badge';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get badgesSubtitle => 'Débloqués en jouant.';

  @override
  String get badgeLocked => 'Verrouillé';

  @override
  String badgeEarnedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get offlineReady => 'Hors-ligne prêt';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInSuccess => 'Connexion réussie — redirection…';

  @override
  String get signInUnavailable =>
      'La connexion n\'est pas encore disponible sur cette version. Tout continue de fonctionner hors-ligne, sans compte.';

  @override
  String get goPremium => 'Devenir premium';

  @override
  String get comingSoon => 'Bientôt disponible';

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

  @override
  String get forgottenPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordIntro =>
      'Entre ton email, on t\'envoie un code pour choisir un nouveau mot de passe.';

  @override
  String get emailLabel => 'Email';

  @override
  String get forgotPasswordSendCode => 'Envoyer le code';

  @override
  String get forgotPasswordRequestFailed =>
      'Impossible d\'envoyer le code. Vérifie l\'adresse et réessaie.';

  @override
  String forgotPasswordCodeSentTo(String email) {
    return 'Code envoyé à $email';
  }

  @override
  String get forgotPasswordCodeLabel => 'Code reçu par email';

  @override
  String get forgotPasswordCodeLength => 'Le code fait 6 chiffres.';

  @override
  String get forgotPasswordMismatch =>
      'Les deux mots de passe ne correspondent pas.';

  @override
  String forgotPasswordLengthRangeHint(int min, int max) {
    return 'Entre $min et $max caractères';
  }

  @override
  String forgotPasswordMinLengthHint(int min) {
    return '$min caractères minimum';
  }

  @override
  String get forgotPasswordResetFailed =>
      'La réinitialisation a échoué. Vérifie le code et réessaie.';

  @override
  String get forgotPasswordDidntReceiveCode => 'Je n\'ai pas reçu le code';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordConfirmation => 'Confirmer le nouveau mot de passe';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';
}
