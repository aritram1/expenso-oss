import 'package:flutter/material.dart';
import 'package:expenso_app/screens/finplan__app_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set to true for debug build
      title: 'Expenso', // This name is shown in `Recent Items` in android
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FinPlanAppHomePage(title: 'Expenso'), // This title is shown in as header text
    );
  }
}

