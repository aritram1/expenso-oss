// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
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

class FinPlanLoginPageState extends State<FinPlanLoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : ElevatedButton(
          child: Text('Login With Salesforce'),
          onPressed: (){
            
          }
        )
      ) 
    );
  }

}