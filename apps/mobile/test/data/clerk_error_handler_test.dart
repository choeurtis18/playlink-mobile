import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/data/clerk_error_handler.dart';

/// Le filtrage des messages d'erreur Clerk doit tenir sur deux fronts
/// opposés : masquer tout ce qui révèle l'existence d'un compte
/// (énumération), sans masquer les erreurs légitimes — sinon l'app devient
/// indébogable et l'utilisateur perd des indications utiles.
void main() {
  /// Reproduit une erreur telle que l'API Clerk la renvoie : le message porte
  /// `{arg}`, remplacé par `argument` dans `toString()`.
  clerk.ClerkError serverError(String text) => clerk.ClerkError(
        code: clerk.ClerkErrorCode.serverErrorResponse,
        message: '{arg}',
        argument: text,
      );

  group('révèle l\'existence d\'un compte → à neutraliser', () {
    test('le message observé en production', () {
      expect(revealsAccountExistence(serverError('identifier is invalid')), isTrue);
    });

    test('insensible à la casse', () {
      expect(revealsAccountExistence(serverError('Identifier Not Found')), isTrue);
    });

    test('reconnu au sein d\'une phrase plus longue', () {
      expect(
        revealsAccountExistence(serverError("Sorry, couldn't find your account.")),
        isTrue,
      );
    });
  });

  group('erreurs légitimes → à laisser passer', () {
    test('mot de passe compromis (message utile à l\'utilisateur)', () {
      expect(
        revealsAccountExistence(
          serverError('Password has been found in an online data breach.'),
        ),
        isFalse,
      );
    });

    test('code de vérification incorrect', () {
      expect(revealsAccountExistence(serverError('Incorrect code')), isFalse);
    });

    test('erreur réseau, hors du serveur d\'authentification', () {
      expect(
        revealsAccountExistence(clerk.ClerkError.external(Exception('SocketException'))),
        isFalse,
      );
    });

    test('erreur produite par l\'app elle-même, jamais filtrée', () {
      // Même texte révélateur : seul le code `serverErrorResponse` est filtré,
      // pour ne pas masquer nos propres messages par accident.
      expect(
        revealsAccountExistence(
          clerk.ClerkError.clientAppError(message: 'identifier is invalid'),
        ),
        isFalse,
      );
    });
  });
}
