// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:expenso_app/screens/app_home/finplan__app_home_page.dart';
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenso'),
      ),
      body: 
      isLoading ? CircularProgressIndicator() 
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are currently not logged in!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Login With Salesforce'),
              onPressed: () async {
                BuildContext currentContext = context;
                Logger().d('Token call not started yet!');
                
                setState(() {
                  isLoading = true;
                });

                String? token;
                try{
                  token = await SalesforceAuthService.authenticate(context);
                }
                catch(e){
                  Logger().d('Error occurred in Login Page build : ${e.toString()}');
                }
   
                setState(() {
                  isLoading = false;
                });
          
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
              }
            ),
          ],
        ),
      ),
    );
  }
}
