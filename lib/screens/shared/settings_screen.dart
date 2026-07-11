import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme'),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_localeName(localeProvider.locale.languageCode)),
          ),
          ...['en', 'si', 'ta'].map((code) {
            return RadioListTile<String>(
              title: Text(_localeName(code)),
              value: code,
              groupValue: localeProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(Locale(value));
                }
              },
            );
          }),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Batta Tracker v1.0.0\nKalpitiya – Kandalkuliya Route'),
          ),
        ],
      ),
    );
  }

  String _localeName(String code) {
    switch (code) {
      case 'si':
        return 'Sinhala (සිංහල)';
      case 'ta':
        return 'Tamil (தமிழ்)';
      default:
        return 'English';
    }
  }
}
