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
  String get onboardingAnalyticsTitle => 'Help us improve Playlink';

  @override
  String get onboardingAnalyticsBody =>
      'Anonymous stats, no name or e-mail. You can say no, nothing changes.';

  @override
  String get onboardingAnalyticsAccept => 'I\'m in';

  @override
  String get onboardingAnalyticsDecline => 'No thanks';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get playersTitle => 'Who\'s playing tonight?';

  @override
  String get playersSubtitle =>
      'Add the players around the phone. You can change the list anytime.';

  @override
  String get playerNameHint => 'First name';

  @override
  String get addPlayer => 'Add';

  @override
  String get duplicatePlayer => 'This name is already taken';

  @override
  String get needOnePlayer => 'Add at least one player';

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
  String get goHome => 'Back to home';

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
}
