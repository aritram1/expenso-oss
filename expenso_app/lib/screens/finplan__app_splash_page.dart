// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:expenso_app/screens/finplan__app_home_page.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FinPlanSplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenso'),
      ),
      body: Center(
        child: ElevatedButton(
            child: Text('Login With Salesforce'),
            onPressed: () async {
              Logger().d('Token call not started yet!');
              final token = await SalesforceAuthService.authenticate(context);
              Logger().d('Token is $token');
              if (token != null) {
                BuildContext currentContext = context;
                Navigator.pushReplacement(
                  currentContext,
                  MaterialPageRoute(
                    builder: (currentContext) =>
                        FinPlanAppHomePage(title: 'Expenso'),
                  ),
                );
              } else {
                // Authentication failed, handle error if needed
                Logger().d('Error');
              }
            }),
      ),
    );
  }
}
