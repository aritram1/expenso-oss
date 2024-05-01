import 'package:expenso_app/screens/splash_page/finplan__app_splash_page.dart';
import 'package:expenso_app/db/services/finplan__DBInitializer.dart';
import 'package:expenso_app/util/finplan__constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {

  // initialize dot env
  loadDotEnvFile();

  // If not granted, request for permissions (sms read etc) on app startup
  handlePermissions();

  // initialize the db
  initDB();

  // Finally run the app
  runApp(const MyApp());
}

// initialize dot env
loadDotEnvFile() async{
  await dotenv.load(fileName: ".env"); 
}

// If not granted, request for permissions (sms read etc) on app startup
handlePermissions() async{
  PermissionStatus status = await Permission.sms.status;
  if (status != PermissionStatus.granted) {
    await Permission.sms.request();
  }
}

// initialize the db
initDB() async{
  WidgetsFlutterBinding.ensureInitialized();
  final isDbCreated = await DatabaseService.instance.initializeDatabase();
  Logger().d('DB Created > $isDbCreated');
  
  final db = await DatabaseService.instance.database;
  // await db.rawQuery("Drop table tasks"); // SELECT name FROM sqlite_master WHERE type='table'");
  
  List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

  Logger().d('All tables=> ${tables.map((table) => table['name'] as String).toList()}');

}

// Actual Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,// Set it to `true` for debug build
      title: FinPlanConstant.APP_NAME,  // 'Expenso' => This name is shown in `Recent Items` in android
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FinPlanSplashPage(title: 'Expenso'),
    );
  }
}
