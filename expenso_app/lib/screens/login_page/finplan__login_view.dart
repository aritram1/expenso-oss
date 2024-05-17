// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:expenso_app/screens/app_home/finplan__app_home_page.dart';
import 'package:expenso_app/util/finplan__constants.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FinPlanLoginPage extends StatefulWidget {
  const FinPlanLoginPage({super.key, required this.title});

  final String title;

  @override
  FinPlanLoginPageState createState() => FinPlanLoginPageState();
}

class FinPlanLoginPageState extends State<FinPlanLoginPage> {

  // generic variables
  static final Logger log = Logger();
  static final bool debug = FinPlanConstant.DEBUG;
  static final bool detaildebug = FinPlanConstant.DETAILED_DEBUG;
  
  // bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenso'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are currently not logged in!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Login With Salesforce'),
              onPressed: () async {
                BuildContext currentContext = context;
                log.d('Token call not started yet!');
                
                // isLoading = true;
                final token = await SalesforceAuthService.authenticate(context);
                // isLoading = false;
          
                log.d('Token is $token');
                if (token != null) {
                  Navigator.push(
                    currentContext,
                    MaterialPageRoute(
                      builder: (currentContext) => FinPlanAppHomePage(title: 'Expenso'),
                    ),
                  );
                } else {
                  // Send to Login
                  log.d('Error');
                  Navigator.push(
                    currentContext,
                    MaterialPageRoute(
                      builder: (currentContext) => FinPlanLoginPage(title: 'Expenso'),
                    ),
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}
