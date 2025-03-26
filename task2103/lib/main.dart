import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2103/task_screen.dart';
import 'package:task2103/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task2103/task_model.dart';
import 'package:task2103/task_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  runApp(MultiProvider(
    providers: [
      
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => TaskProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return MaterialApp(
      title: 'ToDo List',
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const TaskScreen(),
    );
  }
}
