// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:expenso_app/screens/finplan__app_bar.dart';
import 'package:expenso_app/screens/finplan__messages_all.dart';
import 'package:expenso_app/util/expense_data_generator.dart';
import 'package:expenso_app/widgets/finplan__Tile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';

class FinPlanAppHomePage extends StatefulWidget {

  const FinPlanAppHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<FinPlanAppHomePage> createState() => _FinPlanAppHomePageState();
}

class _FinPlanAppHomePageState extends State<FinPlanAppHomePage> {
  
  static final Logger log = Logger();

  static bool isLoggedIn = false;
  static String? accessToken;

  dynamic Function(String) onLoadComplete = (result) {
    log.d('Table loaded Result from HomeScreen0 => $result');
  };

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

    // testing
    getTokenFilecontent();
  }

  // testing
  getTokenFilecontent() async{
    Logger().d('Inside getTokenFilecontent methodToken is getting saved as');
    String? content = await SalesforceAuthService.getFromFile();
    Logger().d('File content before the Home Page is loaded : $content');
    accessToken = await SalesforceAuthService.getFromFile(key : 'access_token');
    isLoggedIn = accessToken != null;
  }

  
  @override
  Widget build(BuildContext context) {
    BuildContext currentContext = context;
    return 
      Scaffold(
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: FinPlanAppBar(
              title: widget.title,
              leadingIcon: Icons.savings,
              leadingIconAction: ({String input = ''}){ 
                return true; 
              },
              availableActions: [
                {
                  Icons.access_alarm : ({input = ''}) async{
                    return true;
                  },
                  Icons.satellite : ({input = ''}) async{
                    return true;
                  },
                  Icons.refresh : ({input = ''}) async{
                    BuildContext currentContext = context;
                    // Get an alert dialog as confirmation box
                    bool shouldProceed = await showConfirmationBox(currentContext, 'Sync');
                    if(shouldProceed){
                      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
                      String deviceId = androidInfo.model;
                      await ExpenseDataGenerator.syncMessages(deviceId); // Call the method now
                    }
                    Navigator.of(context).pop();
                    return true;
                  },
                  Icons.logout : ({input = ''}) async{
                    try{
                      await SalesforceAuthService.logout();
                    }
                    catch(error){
                      log.e('Error while doing logout : $error');
                    }
                    Navigator.of(context).pop();
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
                            onCallBack: () async{
                              var currentContext = context;
                              final fileContent = await SalesforceAuthService.getFromFile() ?? 'Nothing is present'; 
                              navigateTo(currentContext, Scaffold(appBar: AppBar(), body: Center(child: Text(fileContent)))); 
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
                                  navigateTo(currentContext, Scaffold(appBar: AppBar(), body: FinPlanAllMessages()));
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
  void navigateTo(BuildContext context, Widget? widget) async {
    String contents = await SalesforceAuthService.getFromFile() ?? ''; // 'access_token') ?? 'Hello Hi there, no token yet!';
    String value = 'pyak pyak (you are not logged in yet)';
    Logger().d('Inside navigate to method : $contents');
    if(contents != ''){
      final Map<String, dynamic> data = json.decode(contents);
      value = data['access_token'];
    }
    // String value = ((key != null) ? data[key] : json.encode(data)) ?? 'pyak pyak'; // an example key is access_token, for all keys refer below
    
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
                child: Text(value),
              ),
            )
          )
      )
    );
  }

  // A confirmation box to show if its ok to proceed with sync and delete operation
  static Future<dynamic> showConfirmationBox(BuildContext context, String opType){
    String title = 'Please confirm'; 
    String choiceYes = 'Yes';
    String choiceNo = 'No';
    String content =  (opType == 'Sync') 
                            ? 'This will delete existing messages and recreate them. Proceed?' 
                            : 'This will delete all messages and transactions. Proceed?' ;
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked No
              },
              child: Text(choiceNo),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked Yes
              },
              child: Text(choiceYes),
            ),
          ],
        );
      },
    );
  }
}