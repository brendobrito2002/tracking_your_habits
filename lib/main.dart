import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracking_your_habits/src/models/user.dart';
import 'src/app.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'src/dependancies.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //autenticação do firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //persistência local
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>('users');

  runApp(
  MultiProvider(
    providers: appProviders,
    child: const App(),
  ),
);
}


