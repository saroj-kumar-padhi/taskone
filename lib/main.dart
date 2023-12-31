import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task2/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB1S4A3EZlIoMUeMB0WLcH_07Z4dWGc2EY",
      appId: "1:17119341384:android:2b5d36f5d44290c316a17d",
      messagingSenderId: "17119341384",
      projectId: "task-f41a0",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
