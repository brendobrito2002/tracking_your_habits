import 'package:flutter/material.dart';

import '/../l10n/app_localizations.dart';
import '../habits/habits_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(child: Text(l10n.loginSuccess)),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: l10n.habits,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HabitsView()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
