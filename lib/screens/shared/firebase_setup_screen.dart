import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Setup Required')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.cloud_off,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Firebase is not configured',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The app cannot sign in until you add your real Firebase API keys. '
            'Placeholder values are still in the project.',
          ),
          const SizedBox(height: 24),
          _StepCard(
            number: '1',
            title: 'Create a Firebase project',
            body: 'Open Firebase Console and create a project (or use an existing one).',
            actionLabel: 'Open Firebase Console',
            onAction: () async {
              const url = 'https://console.firebase.google.com/';
              await Clipboard.setData(const ClipboardData(text: url));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URL copied — paste in browser')),
              );
            },
          ),
          _StepCard(
            number: '2',
            title: 'Enable Email/Password auth',
            body: 'In Firebase Console → Authentication → Sign-in method → enable Email/Password.',
          ),
          _StepCard(
            number: '3',
            title: 'Register your app',
            body: 'Project Settings → Your apps → Add Web app (for Chrome) or Android app. '
                'Copy the firebaseConfig values shown.',
          ),
          _StepCard(
            number: '4',
            title: 'Paste keys into the project',
            body: 'Edit this file in your project:\n\nlib/firebase_options_local.dart\n\n'
                'Replace YOUR_WEB_API_KEY, YOUR_WEB_APP_ID, YOUR_PROJECT_ID, etc. '
                'with values from Firebase Console.',
          ),
          _StepCard(
            number: '5',
            title: 'Restart the app',
            body: 'Stop flutter run and start again (hot restart is not enough).',
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optional: automatic setup',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Install Firebase CLI, log in, then run:\n\n'
                    'firebase login\n'
                    'dart pub global activate flutterfire_cli\n'
                    'flutterfire configure',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StepCard({
    required this.number,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(number, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(body),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 8),
                    TextButton(onPressed: onAction, child: Text(actionLabel!)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
