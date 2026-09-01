import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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