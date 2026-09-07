import 'package:flutter_test/flutter_test.dart';

import 'full_game_flow.dart';

void main() {
  testWidgets('une partie complète, A1 → B7, hors-ligne', (tester) async {
    await playFullGame(tester);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
