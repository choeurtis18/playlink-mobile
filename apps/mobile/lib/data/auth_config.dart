import 'package:app_links/app_links.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

import 'clerk_sdk_localizations_fr.dart';

/// Schéma de retour après une connexion Google/Apple (§04) — enregistré
/// côté natif (`Info.plist`/`AndroidManifest.xml`) et doit être ajouté aux
/// « Allowed redirect URLs » de l'instance Clerk JOUEURS (dashboard, User &
/// Authentication → Restrictions, ou SSO Connections selon la version).
final oauthRedirectUri = Uri.parse('com.playlink.app://oauth-callback');

final _appLinks = AppLinks();

/// Clé publique de l'instance Clerk JOUEURS (distincte de celle des
/// éditeurs back-office, cf. CLAUDE.md « ne jamais mélanger les deux »).
///
/// Fournie au build via `--dart-define=CLERK_PUBLISHABLE_KEY=pk_...`,
/// jamais committée en dur — voir README pour la valeur de dev.
const _clerkPublishableKey = String.fromEnvironment('CLERK_PUBLISHABLE_KEY');

/// true si aucune clé n'a été fournie au build — l'app doit alors se
/// comporter comme hors-ligne pur (aucun compte), pas planter au démarrage.
bool get clerkConfigured => _clerkPublishableKey.isNotEmpty;

ClerkAuthConfig buildClerkConfig() {
  return ClerkAuthConfig(
    publishableKey: _clerkPublishableKey,
    // Le simulateur iOS n'a pas de Secure Enclave : les clés matérielles
    // (passkeys) y échoueraient silencieusement sans ce flag (cf. doc du
    // package, `supportsHardwareSecurityKeys`).
    supportsHardwareSecurityKeys: false,
    // Le SDK (0.0.18-beta, la dernière version publiée) ne fournit que
    // l'anglais par défaut — sans ceci, les formulaires Clerk (connexion,
    // inscription…) restent en anglais quelle que soit la langue de
    // l'app. `fallbackLocalization` couvre l'EN déjà géré par le SDK.
    localizations: {'fr': ClerkSdkLocalizationsFr()},
    // Sans ceci, Google/Apple passent par la WebView interne du SDK, dont
    // la fermeture plante de façon fiable (bug confirmé sur 0.0.18-beta,
    // la dernière version publiée — `_title!` dans `_SsoWebViewOverlay`
    // accédé sur un widget désactivé). En fournissant un redirect, le SDK
    // ouvre le navigateur externe à la place (`launchUrl`) et revient par
    // deep link — plus robuste, et la pratique recommandée par Apple/
    // Google pour l'OAuth tiers de toute façon (jamais d'in-app WebView).
    redirectionGenerator: (_, _) => oauthRedirectUri,
    deepLinkStream: _appLinks.uriLinkStream,
  );
}
