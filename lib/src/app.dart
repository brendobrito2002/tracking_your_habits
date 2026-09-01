import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('pt', 'BR'),
      ],
      
      title: 'Tracking Your Habits',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tracking Your Habits'),
        ),
        body: const Center(
          child: Text('Firebase + Hive configurados!'),
        ),
      ),
    );
  }
}