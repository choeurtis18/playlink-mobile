import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Neutralise les messages d'erreur qui révèlent l'existence d'un compte.
///
/// Saisir un email inconnu à la connexion faisait répondre « identifier is
/// invalid » : de quoi énumérer les comptes d'une liste d'adresses. Le
/// message doit rester indifférencié — sans dire si c'est l'identifiant ou
/// le mot de passe qui est en cause.
///
/// Le filtrage est fait ICI parce que c'est le seul point de passage commun :
/// le formulaire vient du SDK (`ClerkAuthentication`), ses messages viennent
/// de l'API Clerk, mais tout transite par le `ClerkErrorListener` monté
/// globalement dans `app.dart`. Une seule correction couvre donc la
/// connexion, l'inscription et le mot de passe oublié.
///
/// Complément côté dashboard Clerk (hors code) : *Protect → Rules → User
/// enumeration protection → Strict* empêche le serveur de révéler
/// l'existence d'un compte. Les deux se complètent — Strict traite la
/// source, ceci traite l'affichage.

/// Fragments de messages Clerk révélant qu'aucun compte ne correspond.
///
/// Comparés en minuscules. Ce sont des textes renvoyés par l'API Clerk, donc
/// susceptibles de changer : au moindre doute, vérifier avec un email inconnu
/// que le message générique s'affiche toujours.
const _accountExistencePatterns = [
  'identifier is invalid',
  'identifier not found',
  "couldn't find your account",
  'could not find your account',
  'no account found',
  "account doesn't exist",
];

/// true si [error] laisse deviner qu'un compte existe — ou non.
///
/// Volontairement étroit : seules les réponses du serveur d'authentification
/// sont filtrées. Masquer toutes les erreurs rendrait l'app impossible à
/// déboguer et priverait l'utilisateur d'indications légitimes (mot de passe
/// trop faible, code expiré, réseau coupé).
bool revealsAccountExistence(clerk.ClerkError error) {
  if (error.code != clerk.ClerkErrorCode.serverErrorResponse) return false;
  final message = error.toString().toLowerCase();
  return _accountExistencePatterns.any(message.contains);
}

/// Branché sur le `ClerkErrorListener` global (voir `app.dart`).
///
/// Reprend l'affichage par défaut du SDK (SnackBar à coins arrondis), au
/// message près. `error.localizedMessage()` n'est pas accessible — extension
/// privée du package — d'où `toString()`, qui substitue l'argument du message.
FutureOr<void> handleClerkError(BuildContext context, clerk.ClerkError error) {
  final message = revealsAccountExistence(error)
      ? AppLocalizations.of(context).signInInvalidCredentials
      : error.toString();

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: Text(message),
      ),
    );
}
