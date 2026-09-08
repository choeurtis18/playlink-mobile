import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/e2e/full_game_flow.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('partie complète sur appareil, avec captures', (tester) async {
    await playFullGame(
      tester,
      useRealAssetBundle: true,
      shot: (name) async {
        await binding.takeScreenshot(name);
      },
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
