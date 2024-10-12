// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:expenso_app/screens/app_home/finplan__app_home_page.dart';
// import 'package:expenso_app/screens/calendar/finplan__calendar_view.dart';
import 'package:expenso_app/screens/login_page/finplan__login_view.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:expenso_app/util/finplan__secure_filemanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class FinPlanSplashPage extends StatefulWidget {
  const FinPlanSplashPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FinPlanSplashPage> createState() => _FinPlanSplashPageState();
}

class _FinPlanSplashPageState extends State<FinPlanSplashPage> {
  
  // String tokenFileName = dotenv.env['tokenFileName'] ?? '';

  @override
  void initState() {
    super.initState();
    // No Custom Initialization logic yet
  }

  getToken (){
    return SecureFileManager.getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } 
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        else {
          Logger().d('Inside build method of splash page, the value of token is ${snapshot.data}');
          if (snapshot.data != null && snapshot.data != '' && !snapshot.data!.toUpperCase().startsWith('ERROR')){
            
            // Navigator.of(context).pop();

            return Scaffold(
              body: FinPlanAppHomePage(title: 'Expenso')
            );
          } else {
            return Scaffold(
              body: FinPlanLoginPage(title: 'Expenso')
            );
          }
        }
      },
    );
  }
}
