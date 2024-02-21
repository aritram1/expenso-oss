// ignore_for_file: prefer_const_constructors

import 'package:expenso_app/screens/finplan__app_bar.dart';
import 'package:flutter/material.dart';

class FinPlanAppHomePage extends StatefulWidget {

  const FinPlanAppHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<FinPlanAppHomePage> createState() => _FinPlanAppHomePageState();
}

class _FinPlanAppHomePageState extends State<FinPlanAppHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: FinPlanAppBar(
          title: 'Hello World!',
          leadingIcon: Icons.access_alarm,
          leadingIconAction: ({String input = ''}){ 
            return true; 
          },
          availableActions: [
            {
              Icons.savings : ({input = ''}){
                return true;
              },
              Icons.satellite : ({input = ''}){
                return true;
              }
            },
          ],
        ),
      ),
      body: Center(child : const Text('Hello World!',)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Hello World!',
        child: const Icon(Icons.emoji_transportation_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
