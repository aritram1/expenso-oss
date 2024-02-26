// ignore_for_file: prefer_const_constructors

import 'package:expenso_app/screens/finplan__app_bar.dart';
import 'package:expenso_app/widgets/finplanTile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FinPlanAppHomePage extends StatefulWidget {

  const FinPlanAppHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<FinPlanAppHomePage> createState() => _FinPlanAppHomePageState();
}

class _FinPlanAppHomePageState extends State<FinPlanAppHomePage> {
  
  static final Logger log = Logger();

  dynamic Function(String) onLoadComplete = (result) {
    log.d('Table loaded Result from HomeScreen0 => $result');
  };

  // Future<List<Map<String, dynamic>>> data = Future.value([]);

  // late double screenWidth;
  // late double screenHeight; 

  // late double row1Width;
  late double row1Height;

  // late double row2Width;
  late double row2Height;

  // late double row3Width;
  late double row3Height;

  // late double row4Width;
  late double row4Height;

  // late double row5Width;
  late double row5Height;

  late double padding;


  @override
  void initState() {
    super.initState();

    row1Height = 80;
    // row1Width = 80;

    row2Height = 80;

    row3Height = 80;
    // row3Width = 80;

    row4Height = 320;
    // row4Width = 240;

    row5Height = 120;
    // row5Width = 120;

    padding = 4;

    // data = getDataForLast1Year();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: FinPlanAppBar(
          title: 'Expenso',
          leadingIcon: Icons.savings,
          leadingIconAction: ({String input = ''}){ 
            return true; 
          },
          availableActions: [
            {
              Icons.access_alarm : ({input = ''}){
                return true;
              },
              Icons.satellite : ({input = ''}){
                return true;
              }
            },
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children : [
              // First Row
              /////////////////////////////////////////////// Row 1 ///////////////////////////////////////////
              Row(
                children: [
                  // First Row, First Column
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: row1Height,
                      // width: row1Width,
                      padding: EdgeInsets.all(padding),
                      child: FinPlanTile(
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month),
                            SizedBox(height: 2),
                            Text('Cal')
                          ],
                        ),
                        onCallBack: (){
                          var currentContext = context;
                          navigateTo(currentContext, null);
                        }
                      )
                    ),
                  ),
                  // First Row, Second Column
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      height: row1Height,
                      // width: row1Width,
                      child: FinPlanTile(
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bar_chart),
                            SizedBox(height: 2),
                            Text('Chart')
                          ],
                        ),
                        onCallBack: (){
                          var currentContext = context;
                          navigateTo(currentContext, null);  
                        }
                      )
                    ),
                  ),
                  // First Row, Third Column
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: row1Height,
                      // width: row1Width,
                      padding: EdgeInsets.all(padding),
                      child: FinPlanTile(
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.spa)
                          ],
                        ),
                        onCallBack: (){
                          var currentContext = context;
                          navigateTo(currentContext, null);
                        }
                      )
                    ),
                  ),
                ],
              ),
              /////////////////////////////////////////////// Row 2 ///////////////////////////////////////////
              // Second Row
              Column(
                children: [
                  // Second Row, First Column
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: row2Height,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.account_balance),
                                SizedBox(width: 10),
                                Text('Accounts')
                              ],
                            ),
                            topRight: Icon(Icons.arrow_outward),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);
                            }
                          )
                        ),
                      ),
                    ],
                  ),
                  // Second Row, Second Column
                  // Second Row, Third Column
                ],
              ),
              // Third Row
              /////////////////////////////////////////////// Row 3 ///////////////////////////////////////////
              Column(
                children: [
                  Row(
                    children: [
                      // Third Row, First Column
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: row3Height,
                          // width: row3Width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.message_rounded),
                                SizedBox(height: 2),
                                Text('Message')
                              ],
                            ),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);
                            }
                          )
                        ),
                      ),
                      // Third Row, Second Column
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: row3Height,
                          // width: row3Width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.payments),
                                Text('Transaction')
                              ],
                            ),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);  
                            }
                          )
                        ),
                      ),
                      // Third Row, Third Column
                      //
                    ],
                  ),
                ],
              ),
              /////////////////////////////////////////////// Row 4 ///////////////////////////////////////////
              // Fourth Row
              Column(
                children: [
                  // Fourth Row, First Column
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: row4Height,
                          // width: row4Width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: Icon(Icons.cabin),
                            topRight: Container(
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.all(padding),
                              child: FinPlanTile(
                                borderColor: Colors.purple.shade100,
                                gradientColors: [Colors.purple.shade100, Colors.purple.shade200],
                                center: Icon(Icons.near_me),
                                onCallBack: (){
                                  var currentContext = context;
                                  navigateTo(currentContext, null);   
                                }
                              ),
                            ),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);  
                            }
                          )
                        ),
                      ),
                    ],
                  ),
                  // Fourth Row, Second Column
                  // Fourth Row, Third Column
                ],
              ),
              // Fifth Row 
              /////////////////////////////////////////////// Row 5 ///////////////////////////////////////////
              Column(
                children: [
                  Row(
                    children: [
                      // Fifth Row, First Column
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: row5Height,
                          // width: row5Width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: Icon(Icons.spa),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);  
                            }
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: row5Height,
                          // width: row5Width,
                          padding: EdgeInsets.all(padding),
                          child: FinPlanTile(
                            center: Icon(Icons.spa),
                            onCallBack: (){
                              var currentContext = context;
                              navigateTo(currentContext, null);  
                            }
                          )
                        ),
                      ),
                      // Fifth Row, Second Column
                      // Fifth Row, Third Column  
                    ],
                  ),
                ],
              ),
            ]
          )
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   tooltip: 'Hello World!',
      //   child: const Icon(Icons.emoji_transportation_sharp),
      // ),
    );
  }

  // A generic method to handle routes
  void navigateTo(BuildContext context, Widget? widget) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context)=> widget ??  
          Scaffold(
            appBar: AppBar(), 
            body : Container(
              padding: EdgeInsets.all(8),
              // child: // FinPlanMonthView()
              child: Center(
                child: const Text("Hello Hi there!"),
              ),
            )
          )
      )
    );
  }
}