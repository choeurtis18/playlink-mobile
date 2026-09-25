import 'package:clerk_flutter/clerk_flutter.dart';

/// Traduction FR des chaînes internes au SDK Clerk (formulaires de
/// connexion/inscription, réinitialisation, profil…) — le package
/// `clerk_flutter` (0.0.18-beta, la dernière version publiée) ne fournit
/// que l'anglais (`ClerkSdkLocalizationsEn`), donc sans ce fichier l'UI
/// Clerk reste en anglais quelle que soit la langue de l'app. Enregistrée
/// dans `ClerkAuthConfig.localizations` (voir `auth_config.dart`).
class ClerkSdkLocalizationsFr extends ClerkSdkLocalizations {
  ClerkSdkLocalizationsFr([super.locale = 'fr']);

  @override
  String aLengthOfBetweenMINAndMAX(int min, int max) => 'une longueur entre $min et $max';

  @override
  String aLengthOfMINOrGreater(int min) => 'une longueur d\'au moins $min';

  @override
  String get aLowercaseLetter => 'une lettre MINUSCULE';

  @override
  String get aNumber => 'un CHIFFRE';

  @override
  String aSpecialCharacter(String chars) => 'un CARACTÈRE SPÉCIAL ($chars)';

  @override
  String get abandoned => 'abandonné';

  @override
  String get acceptTerms => 'J\'accepte les conditions d\'utilisation et la politique de confidentialité';

  @override
  String get active => 'actif';

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String get addDomain => 'Ajouter un domaine';

  @override
  String get addEmailAddress => 'Ajouter une adresse email';

  @override
  String get addPasskey => 'Ajouter une clé d\'accès';

  @override
  String get addPhoneNumber => 'Ajouter un numéro de téléphone';

  @override
  String get alreadyHaveAnAccount => 'Déjà un compte ?';

  @override
  String get anUppercaseLetter => 'une lettre MAJUSCULE';

  @override
  String get and => 'et';

  @override
  String get areYouSure => 'Es-tu sûr ?';

  @override
  String authenticationServiceError(String arg) => 'Erreur du service d\'authentification : $arg';

  @override
  String get authenticatorApp => 'application d\'authentification';

  @override
  String get automaticInvitation => 'Invitation automatique';

  @override
  String get automaticSuggestion => 'Suggestion automatique';

  @override
  String get back => 'Retour';

  @override
  String get backupCode => 'code de secours';

  @override
  String get cancel => 'Annuler';

  @override
  String get cannotDeleteSelf => 'Tu n\'es pas autorisé à supprimer ton propre compte';

  @override
  String clickOnTheLinkThatsBeenSentTo(String identifier) =>
      'Clique sur le lien envoyé à $identifier puis reviens ici';

  @override
  String get clickOnTheLinkThatsBeenSentToYou => 'Clique sur le lien qui t\'a été envoyé puis reviens ici';

  @override
  String get complete => 'terminé';

  @override
  String get connectAccount => 'Connecter un compte';

  @override
  String get connectedAccounts => 'Comptes connectés';

  @override
  String get cont => 'Continuer';

  @override
  String get createOrganization => 'Créer une organisation';

  @override
  String get created => 'Créé';

  @override
  String get developmentMode => 'Mode développement';

  @override
  String get didntReceiveCode => 'Pas reçu le code ?';

  @override
  String get domainName => 'Nom de domaine';

  @override
  String get dontHaveAnAccount => 'Pas encore de compte ?';

  @override
  String get edit => 'modifier';

  @override
  String get emailAddress => 'adresse email';

  @override
  String get emailAddressConcise => 'email';

  @override
  String get emailAddresses => 'Adresses email';

  @override
  String get enrollment => 'Inscription';

  @override
  String get enrollmentMode => 'Mode d\'inscription :';

  @override
  String get enterOneOfYourBackupCodes => 'Entre un de tes codes de secours';

  @override
  String get enterTheCodeFromYourAuthenticatorApp => 'Entre le code généré par ton application d\'authentification';

  @override
  String enterTheCodeSentTo(String identifier) => 'Entre le code envoyé à $identifier';

  @override
  String get enterTheCodeSentToYou => 'Entre le code qui t\'a été envoyé';

  @override
  String get enterTheCodeSentToYouByEmail => 'Entre le code envoyé par email';

  @override
  String get enterTheCodeSentToYouByTextMessage => 'Entre le code envoyé par SMS';

  @override
  String get enterYourOrganizationDetailsToContinue => 'Entre les détails de ton organisation pour continuer';

  @override
  String get enterYourPassword => 'Entre ton mot de passe';

  @override
  String get expired => 'expiré';

  @override
  String externalError(String arg) => '$arg (ERREUR EXTERNE)';

  @override
  String get failed => 'échoué';

  @override
  String get firstName => 'prénom';

  @override
  String get forgottenPassword => 'Mot de passe oublié ?';

  @override
  String get generalDetails => 'Détails généraux';

  @override
  String invalidEmailAddress(String address) => 'Adresse email invalide : $address';

  @override
  String invalidPhoneNumber(String number) => 'Numéro de téléphone invalide : $number';

  @override
  String get join => 'REJOINDRE';

  @override
  String jwtPoorlyFormatted(String arg) => 'JWT mal formaté : $arg';

  @override
  String get lastName => 'nom';

  @override
  String get lastUsed => 'Dernière utilisation';

  @override
  String get leave => 'Quitter';

  @override
  String leaveOrg(String organization) => 'Quitter $organization';

  @override
  String get leaveOrganization => 'Quitter l\'organisation';

  @override
  String get legalAcceptanceRequired => 'L\'acceptation des conditions est requise pour s\'inscrire';

  @override
  String get loading => 'Chargement…';

  @override
  String get logo => 'Logo';

  @override
  String get longDateFormat => 'd MMMM y, \'à\' HH:mm';

  @override
  String get manualInvitation => 'Invitation manuelle';

  @override
  String get missingRequirements => 'critères manquants';

  @override
  String get myOrganization => 'Mon organisation';

  @override
  String get name => 'Nom';

  @override
  String get needsFirstFactor => 'premier facteur requis';

  @override
  String get needsIdentifier => 'identifiant requis';

  @override
  String get needsSecondFactor => 'second facteur requis';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordConfirmation => 'Confirmer le nouveau mot de passe';

  @override
  String noAssociatedCodeRetrievalMethod(String arg) => 'Aucune méthode de récupération de code pour $arg';

  @override
  String noAssociatedStrategy(String arg) => 'Aucune stratégie associée à $arg';

  @override
  String get noInitialCodeHasBeenSetUpToResend => 'Aucun code initial n\'a été configuré pour un renvoi';

  @override
  String noSessionFoundForUser(String arg) => 'Aucune session trouvée pour l\'utilisateur $arg';

  @override
  String get noSessionTokenRetrieved => 'Aucun jeton de session récupéré';

  @override
  String noStageForStatus(String arg) => 'Aucune étape trouvée pour le statut $arg';

  @override
  String noSuchFirstFactorStrategy(String arg) => 'Stratégie $arg non prise en charge comme premier facteur';

  @override
  String noSuchSecondFactorStrategy(String arg) => 'Stratégie $arg non prise en charge comme second facteur';

  @override
  String noUserAttributeForField(String arg) => 'Aucun attribut utilisateur trouvé pour le champ $arg';

  @override
  String get ok => 'OK';

  @override
  String get optional => '(facultatif)';

  @override
  String get or => 'ou';

  @override
  String get organizationProfile => 'Profil de l\'organisation';

  @override
  String get organizations => 'Organisations';

  @override
  String get passkey => 'clé d\'accès';

  @override
  String get passkeys => 'Clés d\'accès';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordConfirmation => 'confirmer le mot de passe';

  @override
  String get passwordMatchError => 'Le mot de passe et sa confirmation doivent être identiques';

  @override
  String get passwordMustBeSupplied => 'Un mot de passe doit être fourni';

  @override
  String get passwordRequires => 'Le mot de passe doit contenir :';

  @override
  String get pending => 'en attente';

  @override
  String get personalAccount => 'Compte personnel';

  @override
  String get phoneNumber => 'numéro de téléphone';

  @override
  String get phoneNumberConcise => 'téléphone';

  @override
  String get phoneNumbers => 'Numéros de téléphone';

  @override
  String get pleaseAddRequiredInformation => 'Il manque des informations. Merci de les compléter';

  @override
  String get pleaseChooseAnAccountToConnect => 'Choisis un compte à connecter';

  @override
  String get pleaseEnterYourIdentifier => 'Entre ton identifiant';

  @override
  String get primary => 'PRINCIPAL';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get profile => 'Profil';

  @override
  String get profileDetails => 'Détails du profil';

  @override
  String get recommendSize => 'Taille recommandée 1:1, jusqu\'à 5 Mo.';

  @override
  String get requiredField => '(requis)';

  @override
  String get requiredFieldsAreMissing => 'Des champs requis sont manquants';

  @override
  String get resend => 'Renvoyer';

  @override
  String get resetFailed => 'La réinitialisation a échoué. Un nouveau code a été envoyé.';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe et se connecter';

  @override
  String get selectAccount => 'Choisis le compte avec lequel continuer';

  @override
  String get sendMeTheCode => 'M\'envoyer le code de réinitialisation';

  @override
  String serverErrorResponse(String arg) => '$arg (ERREUR REÇUE DU SERVEUR)';

  @override
  String get setUpYourOrganization => 'Configure ton organisation';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInByCodeSentToYourEmail => 'Envoyer un code par email';

  @override
  String signInByEmailCode(String arg) => 'Code par email à $arg';

  @override
  String signInByEmailLink(String arg) => 'Lien par email à $arg';

  @override
  String get signInByEnteringOneOfYourBackupCodes => 'Utiliser un code de secours';

  @override
  String get signInByLinkSentToYourEmail => 'Envoyer un lien par email';

  @override
  String signInBySMSCode(String arg) => 'Envoyer un code SMS à $arg';

  @override
  String get signInBySMSCodeToYourPhone => 'Envoyer un code par SMS';

  @override
  String signInTo(String name) => 'Se connecter à $name';

  @override
  String get signInUsingEnterpriseSSO => 'Se connecter via le SSO d\'entreprise';

  @override
  String get signInUsingYourAuthenticatorApp => 'Utiliser ton application d\'authentification';

  @override
  String get signInWithOneOfYourBackupCodes => 'Utiliser un de tes codes de secours';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String signOutIdentifier(String identifier) => 'Déconnecter $identifier';

  @override
  String get signOutOfAllAccounts => 'Se déconnecter de tous les comptes';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String signUpTo(String name) => 'S\'inscrire à $name';

  @override
  String get slug => 'Identifiant (slug)';

  @override
  String get slugUrl => 'URL du slug';

  @override
  String get switchTo => 'Passer à';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get tooManyRetries => 'Désolé, le serveur est occupé. Réessaie plus tard.';

  @override
  String get transferable => 'transférable';

  @override
  String get twoStepVerification => 'Vérification en deux étapes';

  @override
  String typeTypeInvalid(String type) => 'Le type « $type » est invalide';

  @override
  String unknownError(String arg) => 'Une erreur inconnue s\'est produite : $arg';

  @override
  String unsupportedPasswordResetStrategy(String arg) => 'Stratégie de réinitialisation non prise en charge : $arg';

  @override
  String get unverified => 'non vérifié';

  @override
  String get usePasskeyInstead => 'Utiliser une clé d\'accès à la place';

  @override
  String get username => 'nom d\'utilisateur';

  @override
  String get verificationEmailAddress => 'Vérification de l\'adresse email';

  @override
  String get verificationPhoneNumber => 'Vérification du numéro de téléphone';

  @override
  String get verified => 'vérifié';

  @override
  String get verifiedDomains => 'Domaines vérifiés';

  @override
  String get verifyThisDevice => 'Vérifier cet appareil';

  @override
  String get verifyYourEmailAddress => 'Vérifie ton adresse email';

  @override
  String get verifyYourPhoneNumber => 'Vérifie ton numéro de téléphone';

  @override
  String get viaAutomaticInvitation => 'par invitation automatique';

  @override
  String get viaAutomaticSuggestion => 'par suggestion automatique';

  @override
  String get viaManualInvitation => 'par invitation manuelle';

  @override
  String get web3Wallet => 'portefeuille web3';

  @override
  String get welcomeBackPleaseSignInToContinue => 'Content de te revoir ! Connecte-toi pour continuer';

  @override
  String get welcomePleaseFillInTheDetailsToGetStarted => 'Bienvenue ! Remplis les détails pour commencer';
}
