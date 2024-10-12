// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:expenso_app/screens/app_home/finplan__app_home_page.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FinPlanLoginPage extends StatefulWidget {
  const FinPlanLoginPage({super.key, this.message = 'You have not logged in yet!', this.showLoginButton = true});

  final String message;
  final bool showLoginButton;

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
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  widget.message, 
                  style: TextStyle(fontSize: 16), 
                  softWrap: true,
                  textAlign: TextAlign.center
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Visibility(
              visible: widget.showLoginButton,
              child: ElevatedButton(
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
                    Navigator.pushReplacement( // breaking change
                      currentContext,
                      MaterialPageRoute(
                        builder: (currentContext) => FinPlanAppHomePage(title: 'Expenso'),
                      ),
                    );
                  } else {
                    // Send to Login
                    Logger().d('Error');
                    Navigator.pushReplacement( // breaking change
                      currentContext,
                      MaterialPageRoute(
                        builder: (currentContext) => FinPlanLoginPage(),
                      ),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
