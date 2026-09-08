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
  String get onboardingHowTitle => 'One phone, the whole group';

  @override
  String get onboardingHowBody =>
      'Pick a game, pass the phone around. On your turn: open the card, play it, the group votes.';

  @override
  String get onboardingAccountTitle => 'No account needed';

  @override
  String get onboardingAccountBody =>
      'Everything works offline. An account, later, only saves your progress.';

  @override
  String get onboardingAnalyticsTitle => 'Stats, not data';

  @override
  String get onboardingAnalyticsBody =>
      'We measure what\'s played to improve the content. Never an email, never a name, never the text of your answers.';

  @override
  String get onboardingAnalyticsToggleTitle => 'Share anonymous stats';

  @override
  String get onboardingAnalyticsToggleBody => 'No email, no name, no card text';

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
  String get homeTitle => 'Pick a game';

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
  String get categoriesTitle => 'Categories';

  @override
  String get rules => 'Rules';

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
  String get imReady => 'I\'m ready';

  @override
  String get gameOver => 'Game over 🎉';

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
  String get navPlay => 'Play';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navProfile => 'Profile';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get leaderboardSubtitle => 'Across your profiles · calculated locally';

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
  String get myCards => 'My cards';

  @override
  String get likedCards => 'Liked cards';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Language, theme, privacy';

  @override
  String get noPlayersYet => 'Add players to see the leaderboard';

  @override
  String get offlineReady => 'Offline ready';

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
}
