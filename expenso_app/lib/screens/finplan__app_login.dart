// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:expenso_app/screens/finplan__app_home_page.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:expenso_app/widgets/finplan__Tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanLoginPage extends StatefulWidget {
  const FinPlanLoginPage({super.key, required this.title});

  final String title;

  @override
  FinPlanLoginPageState createState() => FinPlanLoginPageState();
}

class FinPlanLoginPageState extends State<FinPlanLoginPage> {

  // bool isLoading = false;

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
              BuildContext currentContext = context;
              Logger().d('Token call not started yet!');
              
              // isLoading = true;
              final token = await SalesforceAuthService.authenticate(context);
              // isLoading = false;

              Logger().d('Token is $token');
              if (token != null) {
                Navigator.push(
                  currentContext,
                  MaterialPageRoute(
                    builder: (currentContext) => FinPlanAppHomePage(title: 'Expenso'),
                  ),
                );
              } else {
                // Send to Login
                Logger().d('Error');
                Navigator.push(
                  currentContext,
                  MaterialPageRoute(
                    builder: (currentContext) => FinPlanLoginPage(title: 'Expenso'),
                  ),
                );
              }
            }),
      ),
    );
  }
}
