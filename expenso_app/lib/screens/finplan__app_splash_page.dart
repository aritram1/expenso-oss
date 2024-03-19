// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:expenso_app/screens/finplan__app_home_page.dart';
import 'package:expenso_app/screens/finplan__app_login.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FinPlanSplashPage extends StatefulWidget {
  const FinPlanSplashPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FinPlanSplashPage> createState() => _FinPlanSplashPageState();
}

class _FinPlanSplashPageState extends State<FinPlanSplashPage> {
  @override
  void initState() {
    super.initState();
    // Initialization logic here
  }

  checkLogin(){
    return SalesforceAuthService.getFromFile(key: 'access_token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } 
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        else {
          Logger().d('Inside build method of splash page, the value of token is ${snapshot.data}');
          final bool isLoggedIn = (snapshot.data != null) ? true : false;
          if (isLoggedIn) {
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
