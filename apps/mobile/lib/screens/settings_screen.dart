import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// F1 (langue) + F2 (thème) — le seul contenu de cet écran pour l'instant ;
/// F3 (notifications push) et F4 (confidentialité) sont hors scope, prévus
/// en Phase 6 et non construits ici.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final notifier = ref.read(prefsProvider.notifier);
    final currentLocale = ref.watch(localeProvider).languageCode;
    final themeMode = prefs.themeMode;
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _SectionLabel(t.settingsLanguage),
            const SizedBox(height: 8),
            Text(t.settingsLanguageBody, style: TextStyle(color: soft, fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _OptionTile(
                    label: t.settingsLanguageFr,
                    selected: currentLocale == 'fr',
                    // F1 : changer la langue UI recharge l'interface et
                    // bascule le contenu (fallback FR si carte non
                    // traduite, géré par ContentRepository) — un seul
                    // `set` déclenche les deux, `localeProvider` en dérive.
                    onTap: () => notifier.set(PrefKeys.locale, 'fr'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OptionTile(
                    label: t.settingsLanguageEn,
                    selected: currentLocale == 'en',
                    onTap: () => notifier.set(PrefKeys.locale, 'en'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionLabel(t.settingsTheme),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _OptionTile(
                    icon: Icons.wb_sunny_rounded,
                    label: t.settingsThemeLight,
                    selected: themeMode == 'light',
                    onTap: () => notifier.set(PrefKeys.themeMode, 'light'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OptionTile(
                    icon: Icons.nightlight_round,
                    label: t.settingsThemeDark,
                    selected: themeMode == 'dark',
                    onTap: () => notifier.set(PrefKeys.themeMode, 'dark'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OptionTile(
                    icon: Icons.settings_suggest_rounded,
                    label: t.settingsThemeSystem,
                    selected: themeMode == 'system',
                    onTap: () => notifier.set(PrefKeys.themeMode, 'system'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Text(text.toUpperCase(),
        style: TextStyle(color: soft, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600));
  }
}

/// Segment de choix (langue ou thème) — même principe visuel que
/// `_Segment` de l'écran config (intensité) : dégradé accent si
/// sélectionné, fond sombre uni sinon.
class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.selected, required this.onTap, this.icon});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soft = theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected ? accentGradient : null,
          color: selected ? null : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: selected ? null : Border.all(color: theme.dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: selected ? Colors.white : soft),
              const SizedBox(height: 6),
            ],
            Text(label, style: TextStyle(color: selected ? Colors.white : soft, fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
