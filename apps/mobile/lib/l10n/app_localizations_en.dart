// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Playlink';

  @override
  String get splashTagline => 'Games that get people talking';

  @override
  String get onboardingHowTitle => 'One phone for the whole group';

  @override
  String get onboardingHowBody =>
      'Pick a game, pass the phone around. On your turn: open the card, play it, the group votes whether you earn a point, then you pass the phone to the next person.';

  @override
  String get onboardingAccountTitle => 'No account needed';

  @override
  String get onboardingAccountBody =>
      'Everything works offline. But you can create an account and unlock extra features!';

  @override
  String get onboardingAnalyticsTitle => 'Stats, not data';

  @override
  String get onboardingAnalyticsBody =>
      'We measure what\'s played to improve the content. No personal data is ever used, never an email, never a name, never the text of your answers.';

  @override
  String get onboardingAnalyticsToggleTitle =>
      'Share your stats anonymously to help improve the game.';

  @override
  String get onboardingStart => 'Start';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get playersTitleStart => 'Who\'s playing';

  @override
  String get playersTitleHighlight => 'tonight?';

  @override
  String get playersSubtitle =>
      'Add at least 1 player — the list carries over between games.';

  @override
  String get playerNameHint => 'First name';

  @override
  String get addPlayer => 'Add';

  @override
  String duplicatePlayer(String name) {
    return '$name is already playing tonight';
  }

  @override
  String get needOnePlayer => 'Add at least one player';

  @override
  String playerExistsTitle(String name) {
    return '$name already exists';
  }

  @override
  String playerExistsBody(String name, String points, String games) {
    return 'You already have a $name profile on this device, with $points and $games.';
  }

  @override
  String playerExistsImport(String name) {
    return 'Add $name';
  }

  @override
  String get playerExistsRename => 'No, create a new profile';

  @override
  String editPlayerTitle(String name) {
    return 'Edit $name';
  }

  @override
  String get editPlayerName => 'First name';

  @override
  String get editPlayerAvatar => 'Avatar';

  @override
  String get editPlayerSave => 'Save';

  @override
  String get editPlayerNameTaken => 'This name is already taken';

  @override
  String playerExistsChooseAnotherName(String name) {
    return '$name already exists, choose another name';
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
  String get letsPlay => 'Let\'s play';

  @override
  String get homeTitleStart_1 => 'Which game will you';

  @override
  String get homeTitleHighlight => 'dare';

  @override
  String get homeTitleStart_2 => 'to try?';

  @override
  String playersButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '1 player',
    );
    return '$_temp0';
  }

  @override
  String cardsCount(int count) {
    return '$count cards';
  }

  @override
  String categoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '1 category',
      zero: '0 categories',
    );
    return '$_temp0';
  }

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get rules => 'Rules';

  @override
  String get rulesModalTitle => 'Game rules';

  @override
  String get chooseCategory => 'Pick a category';

  @override
  String get preview => 'Preview';

  @override
  String get intensity => 'Intensity';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get cardsPerGame => 'Cards per game';

  @override
  String get startGame => 'Start the game';

  @override
  String get yourTurn => 'Your turn!';

  @override
  String get seeCard => 'Reveal the card';

  @override
  String turnOf(String name) {
    return 'It\'s $name\'s turn';
  }

  @override
  String get vote => 'Vote';

  @override
  String hintsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hints left',
      one: '1 hint left',
      zero: 'No hints left',
    );
    return '$_temp0';
  }

  @override
  String get useHint => 'Hint used';

  @override
  String deservesPoint(String name) {
    return 'Does $name deserve a point?';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get voteIsMandatory =>
      'The vote is mandatory — it\'s what advances the count.';

  @override
  String passPhoneTo(String name) {
    return 'Pass the phone to $name';
  }

  @override
  String get passPhoneHint => 'The next card stays hidden until they confirm.';

  @override
  String get dontPeekHint => 'Don\'t look at the screen until it\'s your turn.';

  @override
  String itsMe(String name) {
    return 'It\'s me, $name';
  }

  @override
  String get imReady => 'I\'m ready';

  @override
  String get gameOver => 'Game over 🎉';

  @override
  String winnerAnnounce(String name) {
    return '$name wins the round';
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
    return 'Total: $count';
  }

  @override
  String get replay => 'Play again';

  @override
  String get goHome => 'Home';

  @override
  String get shareScore => 'Share the score';

  @override
  String cardOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get quitGame => 'Leave the game?';

  @override
  String get quitGameBody => 'This game\'s points will be lost.';

  @override
  String get quit => 'Leave';

  @override
  String get loadingContent => 'Getting the cards ready…';

  @override
  String get navPlay => 'Games';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navProfile => 'Profile';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get leaderboardSubtitle => 'So, who\'s the best player?';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLocalMode => 'Local mode — no account';

  @override
  String get profileLocalCardTitle => 'Everything works without an account';

  @override
  String get profileLocalCardBody =>
      'Games, badges and history live on this device. An account is for saving progress, creating cards and liking.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get profileSignedInTitle => 'Account connected';

  @override
  String get profileSignedInFallback => 'Signed in';

  @override
  String get syncNow => 'Sync my data';

  @override
  String get syncSuccess => 'Data synced';

  @override
  String get syncFailed => 'Couldn\'t sync — try again later';

  @override
  String get signOut => 'Sign out';

  @override
  String get myCards => 'My cards';

  @override
  String get myCardsSubtitle =>
      'Your cards, playable as soon as they\'re active — never visible to anyone else';

  @override
  String get myCardsEmpty => 'No cards created yet';

  @override
  String get createCardCta => 'Create a card';

  @override
  String get createCardTitle => 'New card';

  @override
  String get editCardTitle => 'Edit card';

  @override
  String get createCardGame => 'Game';

  @override
  String get createCardCategory => 'Category';

  @override
  String get createCardTextHint => 'Card text';

  @override
  String get createCardTextEmpty => 'The card text cannot be empty';

  @override
  String get createCardActive => 'Turn the card on so it\'s playable';

  @override
  String get createCardSave => 'Save';

  @override
  String get deleteCard => 'Delete';

  @override
  String get deleteCardConfirmTitle => 'Delete this card?';

  @override
  String get deleteCardConfirmBody => 'This action is permanent.';

  @override
  String get cardActive => 'Active';

  @override
  String get cardInactive => 'Inactive';

  @override
  String get likedCards => 'Liked cards';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Language, theme, other';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageBody =>
      'FR/EN — reloads the interface and switches content (untranslated cards stay in French)';

  @override
  String get settingsLanguageFr => 'French';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get noPlayersYet => 'Add players to see the leaderboard';

  @override
  String get badgeUnlockedTitle => 'Congratulations!';

  @override
  String get badgeUnlockedBody => 'You unlocked the badge';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get badgesSubtitle => 'Unlocked by playing.';

  @override
  String get badgeLocked => 'Locked';

  @override
  String badgeEarnedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get offlineReady => 'Offline ready';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSuccess => 'Signed in — redirecting…';

  @override
  String get signInUnavailable =>
      'Sign-in isn\'t available on this build yet. Everything keeps working offline, without an account.';

  @override
  String get signInInvalidCredentials => 'Invalid credentials';

  @override
  String get goPremium => 'Go premium';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get playersEdit => 'Edit';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '1 game',
      zero: '0 games',
    );
    return '$_temp0';
  }

  @override
  String get forgottenPasswordTitle => 'Forgotten password';

  @override
  String get forgotPasswordIntro =>
      'Enter your email and we\'ll send you a code to choose a new password.';

  @override
  String get emailLabel => 'Email';

  @override
  String get forgotPasswordSendCode => 'Send code';

  @override
  String get forgotPasswordRequestFailed =>
      'Couldn\'t send the code. Check the address and try again.';

  @override
  String forgotPasswordCodeSentTo(String email) {
    return 'Code sent to $email';
  }

  @override
  String get forgotPasswordCodeLabel => 'Code received by email';

  @override
  String get forgotPasswordCodeLength => 'The code is 6 digits.';

  @override
  String get forgotPasswordMismatch => 'The two passwords don\'t match.';

  @override
  String forgotPasswordLengthRangeHint(int min, int max) {
    return 'Between $min and $max characters';
  }

  @override
  String forgotPasswordMinLengthHint(int min) {
    return '$min characters minimum';
  }

  @override
  String get forgotPasswordResetFailed =>
      'The reset failed. Check the code and try again.';

  @override
  String get forgotPasswordDidntReceiveCode => 'I didn\'t receive the code';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordConfirmation => 'Confirm new password';

  @override
  String get resetPassword => 'Reset password';
}
