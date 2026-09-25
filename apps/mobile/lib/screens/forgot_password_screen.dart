import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// Écran maison de réinitialisation du mot de passe (§04) — remplace
/// `ClerkForgottenPasswordPanel` du SDK, dont la fenêtre modale plante à la
/// fermeture (bug confirmé sur clerk_flutter 0.0.18-beta, la dernière
/// version publiée : `ClerkErrorListener` tente d'afficher une erreur sur un
/// `BuildContext` désactivé pendant le pop du dialogue). On rejoue le même
/// flux (email → code → nouveau mot de passe) avec les méthodes de bas
/// niveau de `ClerkAuthState` (`initiatePasswordReset`/`attemptSignIn`,
/// héritées de `clerk.Auth`), dans un écran classique de la pile de
/// navigation plutôt qu'un dialogue — jamais démonté sous nos pieds par la
/// redirection post-connexion de `SignInScreen`.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum _Step { requestCode, resetPassword }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  _Step _step = _Step.requestCode;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _requestCode(ClerkAuthState authState) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _busy = true);
    try {
      await authState.initiatePasswordReset(
        identifier: email,
        strategy: clerk.Strategy.resetPasswordEmailCode,
      );
      if (!mounted) return;
      if (authState.signIn?.status == clerk.Status.needsFirstFactor) {
        setState(() => _step = _Step.resetPassword);
      } else {
        _showError(AppLocalizations.of(context).forgotPasswordRequestFailed);
      }
    } catch (e) {
      _showError('$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submitReset(ClerkAuthState authState) async {
    final t = AppLocalizations.of(context);
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (code.length != 6) {
      _showError(t.forgotPasswordCodeLength);
      return;
    }
    if (password != confirm) {
      _showError(t.forgotPasswordMismatch);
      return;
    }
    if (authState.checkPassword(password, confirm, context) case String errorMessage) {
      _showError(errorMessage);
      return;
    }

    setState(() => _busy = true);
    try {
      await authState.attemptSignIn(
        strategy: clerk.Strategy.resetPasswordEmailCode,
        identifier: _emailController.text.trim(),
        password: password,
        code: code,
      );
      if (!mounted) return;
      if (authState.isSignedIn) {
        context.go('/profile');
      } else {
        _showError(t.forgotPasswordResetFailed);
      }
    } catch (e) {
      _showError('$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final authState = ClerkAuth.of(context);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    final criteria = authState.env.user.passwordSettings;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(t.forgottenPasswordTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_step == _Step.requestCode) ...[
                Text(t.forgotPasswordIntro, style: TextStyle(color: soft, fontSize: 13.5, height: 1.4)),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: t.emailLabel),
                  onSubmitted: (_) => _requestCode(authState),
                ),
                const SizedBox(height: 20),
                _PrimaryButton(
                  label: t.forgotPasswordSendCode,
                  busy: _busy,
                  onPressed: () => _requestCode(authState),
                ),
              ] else ...[
                Text(
                  t.forgotPasswordCodeSentTo(_emailController.text.trim()),
                  style: TextStyle(color: soft, fontSize: 13.5, height: 1.4),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(labelText: t.forgotPasswordCodeLabel),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: t.newPassword,
                    helperText: criteria.maxLength > 0
                        ? t.forgotPasswordLengthRangeHint(criteria.minLength, criteria.maxLength)
                        : t.forgotPasswordMinLengthHint(criteria.minLength),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmController,
                  obscureText: _obscure,
                  decoration: InputDecoration(labelText: t.newPasswordConfirmation),
                  onSubmitted: (_) => _submitReset(authState),
                ),
                const SizedBox(height: 20),
                _PrimaryButton(
                  label: t.resetPassword,
                  busy: _busy,
                  onPressed: () => _submitReset(authState),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _busy ? null : () => setState(() => _step = _Step.requestCode),
                  child: Text(t.forgotPasswordDidntReceiveCode),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.busy, required this.onPressed});
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.pill)),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: busy ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.pill)),
          ),
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
