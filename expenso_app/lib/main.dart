import 'package:expenso_app/screens/finplan__app_login.dart';
import 'package:expenso_app/screens/finplan__app_splash_page.dart';
import 'package:flutter/material.dart';
import 'package:expenso_app/screens/finplan__app_home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {

  // initialize dot env
  await dotenv.load(fileName: ".env"); 

  // initialize the db
  // WidgetsFlutterBinding.ensureInitialized();
  // final isDbCreated = await DatabaseService.instance.initializeDatabase();
  // Logger().d('Created > $isDbCreated');

  // If not granted, request for permissions (sms read etc) on app startup
  PermissionStatus status = await Permission.sms.status;
  if (status != PermissionStatus.granted) {
    await Permission.sms.request();
  }

  // Finally unt the app
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
      home: const FinPlanSplashPage(title: 'Expenso',),     // This title is shown in as header text
      // home: const FinPlanLoginPage(title: 'Expenso'),    // This title is shown in as header text
      // home: const FinPlanAppHomePage(title: 'Expenso'),  // This title is shown in as header text
    );
  }
}
