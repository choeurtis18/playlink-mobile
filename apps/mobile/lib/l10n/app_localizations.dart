import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Playlink'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In fr, this message translates to:
  /// **'Les jeux qui délient les langues'**
  String get splashTagline;

  /// No description provided for @onboardingHowTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un téléphone pour tout le groupe'**
  String get onboardingHowTitle;

  /// No description provided for @onboardingHowBody.
  ///
  /// In fr, this message translates to:
  /// **'On choisit un jeu, on se passe le téléphone. À ton tour : tu ouvres la carte, tu joues, le groupe vote si tu mérites ou non un point, tu passes le téléphone à la personne suivante.'**
  String get onboardingHowBody;

  /// No description provided for @onboardingAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte requis'**
  String get onboardingAccountTitle;

  /// No description provided for @onboardingAccountBody.
  ///
  /// In fr, this message translates to:
  /// **'Tout marche hors-ligne. Mais tu peux créer un compte et débloquer des fonctionnalités supplémentaires !'**
  String get onboardingAccountBody;

  /// No description provided for @onboardingAnalyticsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Des stats, pas des données'**
  String get onboardingAnalyticsTitle;

  /// No description provided for @onboardingAnalyticsBody.
  ///
  /// In fr, this message translates to:
  /// **'On mesure ce qui est joué pour améliorer le contenu. Aucunes données personnelles ne sont exploitées, jamais d\'email, jamais de nom, jamais le texte de tes réponses.'**
  String get onboardingAnalyticsBody;

  /// No description provided for @onboardingAnalyticsToggleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partager ses stats anonymement pour aider à améliorer le jeu.'**
  String get onboardingAnalyticsToggleTitle;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @skip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @playersTitleStart.
  ///
  /// In fr, this message translates to:
  /// **'Qui joue'**
  String get playersTitleStart;

  /// No description provided for @playersTitleHighlight.
  ///
  /// In fr, this message translates to:
  /// **'ce soir ?'**
  String get playersTitleHighlight;

  /// No description provided for @playersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute au moins 1 joueur pour commencer. Tu pourras changer la liste à tout moment !'**
  String get playersSubtitle;

  /// No description provided for @playerNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get playerNameHint;

  /// No description provided for @addPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addPlayer;

  /// No description provided for @duplicatePlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} joue déjà ce soir'**
  String duplicatePlayer(String name);

  /// No description provided for @needOnePlayer.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute au moins un joueur'**
  String get needOnePlayer;

  /// No description provided for @playerExistsTitle.
  ///
  /// In fr, this message translates to:
  /// **'{name} existe déjà'**
  String playerExistsTitle(String name);

  /// No description provided for @playerExistsBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà un profil {name} sur cet appareil, avec {points} et {games}.'**
  String playerExistsBody(String name, String points, String games);

  /// No description provided for @playerExistsImport.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter {name}'**
  String playerExistsImport(String name);

  /// No description provided for @playerExistsRename.
  ///
  /// In fr, this message translates to:
  /// **'Non, créer un nouveau profil'**
  String get playerExistsRename;

  /// No description provided for @editPlayerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier {name}'**
  String editPlayerTitle(String name);

  /// No description provided for @editPlayerName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get editPlayerName;

  /// No description provided for @editPlayerAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Avatar'**
  String get editPlayerAvatar;

  /// No description provided for @editPlayerSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get editPlayerSave;

  /// No description provided for @editPlayerNameTaken.
  ///
  /// In fr, this message translates to:
  /// **'Ce prénom est déjà utilisé'**
  String get editPlayerNameTaken;

  /// No description provided for @playerExistsChooseAnotherName.
  ///
  /// In fr, this message translates to:
  /// **'{name} existe déjà, choisis un autre nom'**
  String playerExistsChooseAnotherName(String name);

  /// No description provided for @pointsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 point} =1{1 point} other{{count} points}}'**
  String pointsCount(int count);

  /// No description provided for @letsPlay.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti'**
  String get letsPlay;

  /// No description provided for @homeTitleStart_1.
  ///
  /// In fr, this message translates to:
  /// **'Quel jeu'**
  String get homeTitleStart_1;

  /// No description provided for @homeTitleHighlight.
  ///
  /// In fr, this message translates to:
  /// **'oseras-tu'**
  String get homeTitleHighlight;

  /// No description provided for @homeTitleStart_2.
  ///
  /// In fr, this message translates to:
  /// **'tester ?'**
  String get homeTitleStart_2;

  /// No description provided for @playersButton.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 joueur} other{{count} joueurs}}'**
  String playersButton(int count);

  /// No description provided for @cardsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} cartes'**
  String cardsCount(int count);

  /// No description provided for @categoriesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 catégorie} =1{1 catégorie} other{{count} catégories}}'**
  String categoriesCount(int count);

  /// No description provided for @categoriesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categoriesTitle;

  /// No description provided for @rules.
  ///
  /// In fr, this message translates to:
  /// **'Règles'**
  String get rules;

  /// No description provided for @rulesModalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règle du jeu'**
  String get rulesModalTitle;

  /// No description provided for @chooseCategory.
  ///
  /// In fr, this message translates to:
  /// **'Choisis une catégorie'**
  String get chooseCategory;

  /// No description provided for @preview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu'**
  String get preview;

  /// No description provided for @intensity.
  ///
  /// In fr, this message translates to:
  /// **'Intensité'**
  String get intensity;

  /// No description provided for @difficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get difficulty;

  /// No description provided for @cardsPerGame.
  ///
  /// In fr, this message translates to:
  /// **'Cartes par partie'**
  String get cardsPerGame;

  /// No description provided for @startGame.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la partie'**
  String get startGame;

  /// No description provided for @yourTurn.
  ///
  /// In fr, this message translates to:
  /// **'C\'est à ton tour !'**
  String get yourTurn;

  /// No description provided for @seeCard.
  ///
  /// In fr, this message translates to:
  /// **'Voir la carte'**
  String get seeCard;

  /// No description provided for @turnOf.
  ///
  /// In fr, this message translates to:
  /// **'C\'est au tour de {name}'**
  String turnOf(String name);

  /// No description provided for @vote.
  ///
  /// In fr, this message translates to:
  /// **'Voter'**
  String get vote;

  /// No description provided for @hintsLeft.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Plus d\'indice} =1{1 indice restant} other{{count} indices restants}}'**
  String hintsLeft(int count);

  /// No description provided for @useHint.
  ///
  /// In fr, this message translates to:
  /// **'Indice utilisé'**
  String get useHint;

  /// No description provided for @deservesPoint.
  ///
  /// In fr, this message translates to:
  /// **'Est-ce que {name} mérite un point ?'**
  String deservesPoint(String name);

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @voteIsMandatory.
  ///
  /// In fr, this message translates to:
  /// **'Le vote est obligatoire — c\'est lui qui fait avancer le compteur.'**
  String get voteIsMandatory;

  /// No description provided for @passPhoneTo.
  ///
  /// In fr, this message translates to:
  /// **'Passe le téléphone à {name}'**
  String passPhoneTo(String name);

  /// No description provided for @passPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'La carte suivante reste cachée jusqu\'à ce qu\'il confirme.'**
  String get passPhoneHint;

  /// No description provided for @dontPeekHint.
  ///
  /// In fr, this message translates to:
  /// **'Ne regarde pas l\'écran tant que ce n\'est pas ton tour.'**
  String get dontPeekHint;

  /// No description provided for @itsMe.
  ///
  /// In fr, this message translates to:
  /// **'C\'est moi, {name}'**
  String itsMe(String name);

  /// No description provided for @imReady.
  ///
  /// In fr, this message translates to:
  /// **'Je suis prêt'**
  String get imReady;

  /// No description provided for @gameOver.
  ///
  /// In fr, this message translates to:
  /// **'Partie terminée 🎉'**
  String get gameOver;

  /// No description provided for @winnerAnnounce.
  ///
  /// In fr, this message translates to:
  /// **'{name} remporte la manche'**
  String winnerAnnounce(String name);

  /// No description provided for @sessionScore.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 pt} =1{1 pt} other{{count} pts}}'**
  String sessionScore(int count);

  /// No description provided for @totalScore.
  ///
  /// In fr, this message translates to:
  /// **'Total : {count}'**
  String totalScore(int count);

  /// No description provided for @replay.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get replay;

  /// No description provided for @goHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get goHome;

  /// No description provided for @shareScore.
  ///
  /// In fr, this message translates to:
  /// **'Partager le score'**
  String get shareScore;

  /// No description provided for @cardOf.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {total}'**
  String cardOf(int current, int total);

  /// No description provided for @quitGame.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la partie ?'**
  String get quitGame;

  /// No description provided for @quitGameBody.
  ///
  /// In fr, this message translates to:
  /// **'Les points de cette partie seront perdus.'**
  String get quitGameBody;

  /// No description provided for @quit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get quit;

  /// No description provided for @loadingContent.
  ///
  /// In fr, this message translates to:
  /// **'Préparation des cartes…'**
  String get loadingContent;

  /// No description provided for @navPlay.
  ///
  /// In fr, this message translates to:
  /// **'Jeux'**
  String get navPlay;

  /// No description provided for @navLeaderboard.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get navLeaderboard;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @leaderboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Alors qui est le meilleur joueur ?'**
  String get leaderboardSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileLocalMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode local — aucun compte'**
  String get profileLocalMode;

  /// No description provided for @profileLocalCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout marche sans compte'**
  String get profileLocalCardTitle;

  /// No description provided for @profileLocalCardBody.
  ///
  /// In fr, this message translates to:
  /// **'Parties, badges et historique vivent sur cet appareil. Un compte sert à sauvegarder, créer des cartes et liker.'**
  String get profileLocalCardBody;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @profileSignedInTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte connecté'**
  String get profileSignedInTitle;

  /// No description provided for @profileSignedInFallback.
  ///
  /// In fr, this message translates to:
  /// **'Connecté'**
  String get profileSignedInFallback;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @myCards.
  ///
  /// In fr, this message translates to:
  /// **'Mes cartes'**
  String get myCards;

  /// No description provided for @myCardsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes cartes, jouables dès qu\'elles sont actives — jamais visibles par personne d\'autre'**
  String get myCardsSubtitle;

  /// No description provided for @myCardsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune carte créée pour l\'instant'**
  String get myCardsEmpty;

  /// No description provided for @createCardCta.
  ///
  /// In fr, this message translates to:
  /// **'Créer une carte'**
  String get createCardCta;

  /// No description provided for @createCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle carte'**
  String get createCardTitle;

  /// No description provided for @editCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la carte'**
  String get editCardTitle;

  /// No description provided for @createCardGame.
  ///
  /// In fr, this message translates to:
  /// **'Jeu'**
  String get createCardGame;

  /// No description provided for @createCardCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get createCardCategory;

  /// No description provided for @createCardTextHint.
  ///
  /// In fr, this message translates to:
  /// **'Texte de la carte'**
  String get createCardTextHint;

  /// No description provided for @createCardTextEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Le texte de la carte ne peut pas être vide'**
  String get createCardTextEmpty;

  /// No description provided for @createCardActive.
  ///
  /// In fr, this message translates to:
  /// **'Activer la carte pour qu\'elle soit jouable'**
  String get createCardActive;

  /// No description provided for @createCardSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get createCardSave;

  /// No description provided for @deleteCard.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteCard;

  /// No description provided for @deleteCardConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette carte ?'**
  String get deleteCardConfirmTitle;

  /// No description provided for @deleteCardConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est définitive.'**
  String get deleteCardConfirmBody;

  /// No description provided for @cardActive.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get cardActive;

  /// No description provided for @cardInactive.
  ///
  /// In fr, this message translates to:
  /// **'Inactive'**
  String get cardInactive;

  /// No description provided for @likedCards.
  ///
  /// In fr, this message translates to:
  /// **'Cartes likées'**
  String get likedCards;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue, thème, autres'**
  String get settingsSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageBody.
  ///
  /// In fr, this message translates to:
  /// **'FR/EN — recharge l\'interface et bascule le contenu (les cartes non traduites restent en français)'**
  String get settingsLanguageBody;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get settingsLanguageEn;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @noPlayersYet.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des joueurs pour voir le classement'**
  String get noPlayersYet;

  /// No description provided for @badgeUnlockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations !'**
  String get badgeUnlockedTitle;

  /// No description provided for @badgeUnlockedBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu as débloqué le badge'**
  String get badgeUnlockedBody;

  /// No description provided for @badgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Badges'**
  String get badgesTitle;

  /// No description provided for @badgesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Débloqués en jouant.'**
  String get badgesSubtitle;

  /// No description provided for @badgeLocked.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillé'**
  String get badgeLocked;

  /// No description provided for @badgeEarnedOn.
  ///
  /// In fr, this message translates to:
  /// **'Débloqué le {date}'**
  String badgeEarnedOn(String date);

  /// No description provided for @offlineReady.
  ///
  /// In fr, this message translates to:
  /// **'Hors-ligne prêt'**
  String get offlineReady;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @signInSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie — redirection…'**
  String get signInSuccess;

  /// No description provided for @signInUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'La connexion n\'est pas encore disponible sur cette version. Tout continue de fonctionner hors-ligne, sans compte.'**
  String get signInUnavailable;

  /// No description provided for @goPremium.
  ///
  /// In fr, this message translates to:
  /// **'Devenir premium'**
  String get goPremium;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @playersEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get playersEdit;

  /// No description provided for @gamesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 partie} =1{1 partie} other{{count} parties}}'**
  String gamesCount(int count);

  /// No description provided for @forgottenPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgottenPasswordTitle;

  /// No description provided for @forgotPasswordIntro.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton email, on t\'envoie un code pour choisir un nouveau mot de passe.'**
  String get forgotPasswordIntro;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @forgotPasswordSendCode.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code'**
  String get forgotPasswordSendCode;

  /// No description provided for @forgotPasswordRequestFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'envoyer le code. Vérifie l\'adresse et réessaie.'**
  String get forgotPasswordRequestFailed;

  /// No description provided for @forgotPasswordCodeSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Code envoyé à {email}'**
  String forgotPasswordCodeSentTo(String email);

  /// No description provided for @forgotPasswordCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code reçu par email'**
  String get forgotPasswordCodeLabel;

  /// No description provided for @forgotPasswordCodeLength.
  ///
  /// In fr, this message translates to:
  /// **'Le code fait 6 chiffres.'**
  String get forgotPasswordCodeLength;

  /// No description provided for @forgotPasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe ne correspondent pas.'**
  String get forgotPasswordMismatch;

  /// No description provided for @forgotPasswordLengthRangeHint.
  ///
  /// In fr, this message translates to:
  /// **'Entre {min} et {max} caractères'**
  String forgotPasswordLengthRangeHint(int min, int max);

  /// No description provided for @forgotPasswordMinLengthHint.
  ///
  /// In fr, this message translates to:
  /// **'{min} caractères minimum'**
  String forgotPasswordMinLengthHint(int min);

  /// No description provided for @forgotPasswordResetFailed.
  ///
  /// In fr, this message translates to:
  /// **'La réinitialisation a échoué. Vérifie le code et réessaie.'**
  String get forgotPasswordResetFailed;

  /// No description provided for @forgotPasswordDidntReceiveCode.
  ///
  /// In fr, this message translates to:
  /// **'Je n\'ai pas reçu le code'**
  String get forgotPasswordDidntReceiveCode;

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPassword;

  /// No description provided for @newPasswordConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le nouveau mot de passe'**
  String get newPasswordConfirmation;

  /// No description provided for @resetPassword.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
