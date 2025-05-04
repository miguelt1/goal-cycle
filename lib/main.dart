import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/goal.dart';
import 'models/cycle.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(CycleAdapter());
  
  await Hive.openBox<Goal>('goals');
  await Hive.openBox<Cycle>('cycles');
  await Hive.openBox('timerState');

  runApp(const GoalTimerApp());
}

class GoalTimerApp extends StatelessWidget {
  const GoalTimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}