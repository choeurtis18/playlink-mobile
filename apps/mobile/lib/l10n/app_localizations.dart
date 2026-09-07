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
  /// **'Les jeux qui font parler'**
  String get splashTagline;

  /// No description provided for @onboardingHowTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un téléphone, tout le groupe'**
  String get onboardingHowTitle;

  /// No description provided for @onboardingHowBody.
  ///
  /// In fr, this message translates to:
  /// **'On choisit un jeu, on se passe le téléphone. À ton tour : tu ouvres la carte, tu joues, le groupe vote.'**
  String get onboardingHowBody;

  /// No description provided for @onboardingAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte requis'**
  String get onboardingAccountTitle;

  /// No description provided for @onboardingAccountBody.
  ///
  /// In fr, this message translates to:
  /// **'Tout marche hors-ligne. Un compte, plus tard, servira seulement à sauvegarder ta progression.'**
  String get onboardingAccountBody;

  /// No description provided for @onboardingAnalyticsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous aider à améliorer Playlink'**
  String get onboardingAnalyticsTitle;

  /// No description provided for @onboardingAnalyticsBody.
  ///
  /// In fr, this message translates to:
  /// **'Des statistiques anonymes, sans nom ni e-mail. Tu peux refuser, rien ne change.'**
  String get onboardingAnalyticsBody;

  /// No description provided for @onboardingAnalyticsAccept.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte'**
  String get onboardingAnalyticsAccept;

  /// No description provided for @onboardingAnalyticsDecline.
  ///
  /// In fr, this message translates to:
  /// **'Sans moi'**
  String get onboardingAnalyticsDecline;

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

  /// No description provided for @playersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Qui joue ce soir ?'**
  String get playersTitle;

  /// No description provided for @playersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute les joueurs autour du téléphone. Tu pourras changer la liste à tout moment.'**
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
  /// **'Ce prénom est déjà utilisé'**
  String get duplicatePlayer;

  /// No description provided for @needOnePlayer.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute au moins un joueur'**
  String get needOnePlayer;

  /// No description provided for @letsPlay.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti'**
  String get letsPlay;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un jeu'**
  String get homeTitle;

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
  /// **'Retour à l\'accueil'**
  String get goHome;

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
