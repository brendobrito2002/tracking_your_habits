import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracking_your_habits/src/models/user.dart';
import 'package:tracking_your_habits/src/models/habit.dart';
import 'package:tracking_your_habits/src/models/checkin.dart';
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
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(CheckInAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<CheckIn>('checkins');

  runApp(
  MultiProvider(
    providers: appProviders,
    child: const App(),
  ),
);
}


