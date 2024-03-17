// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:expenso_app/screens/finplan__app_login.dart';
import 'package:expenso_app/widgets/finplan__Tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanSplashPage extends StatefulWidget {

  const FinPlanSplashPage({super.key, required this.title});

  final String title;

  @override
  FinPlanSplashPageState createState() => FinPlanSplashPageState();
}

class FinPlanSplashPageState extends State<FinPlanSplashPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=> Scaffold(body : FinPlanLoginPage(title: 'Expenso')))
            );
          },
          icon: const Icon(Icons.cloud),
          label: const Text("Login With Salesforce")
        ),
      ) 
    );
  }

}