// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:expenso_app/screens/account/finplan__all_accounts_view.dart';
import 'package:expenso_app/screens/app_bar/finplan__app_bar.dart';
import 'package:expenso_app/screens/calendar/finplan__calendar_view.dart';
import 'package:expenso_app/screens/login_page/finplan__login_view.dart';
import 'package:expenso_app/screens/message/finplan__all_messages_view.dart';
import 'package:expenso_app/screens/transaction/finplan__transactions_all.dart';
import 'package:expenso_app/util/finplan__secure_filemanager.dart';
import 'package:expenso_app/widgets/finplan__Tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:expenso_app/util/finplan__salesforce_util_oauth2.dart';

class FinPlanAppHomePage extends StatefulWidget {

  const FinPlanAppHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<FinPlanAppHomePage> createState() => _FinPlanAppHomePageState();
}

class _FinPlanAppHomePageState extends State<FinPlanAppHomePage> {
  
  String tokenFileName = dotenv.env['tokenFileName'] ?? '';
  
  static final Logger log = Logger();

  // static bool isLoggedIn = false;
  // static String? accessToken;


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
    // getTokenFilecontent();
  }

  // testing
  // getTokenFilecontent() async{
  //   Logger().d('Inside getTokenFilecontent methodToken is getting saved as');
  //   String tokenFileName = dotenv.env['tokenFileName'] ?? '';
  //   String? content = await SalesforceAuthService.getFromFile(tokenFileName);
  //   Logger().d('File content before the Home Page is loaded : $content');
  //   accessToken = await SalesforceAuthService.getFromFile(tokenFileName, key : 'access_token');
  //   isLoggedIn = accessToken != null;
  // }

  
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
                  Icons.logout : ({input = ''}) async{
                    try{
                      await SalesforceAuthService.logout();
                    }
                    catch(error){
                      log.e('Error while doing logout : $error');
                    }
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FinPlanLoginPage(title: 'Expenso')));
                    
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (_)=>
                    //     Scaffold(
                    //       appBar: AppBar(),
                    //       body: Center(
                    //         child: SizedBox(
                    //           height: 200,
                    //           width: 200,
                    //           child: AppBar(
                    //             // sms: jsonEncode(each),
                    //             // onCallBack: (){}
                    //           ),
                    //         ),
                    //       )
                    //     )
                    //   )
                    // );
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
                              navigateTo(currentContext, Scaffold(
                                // appBar: AppBar(), 
                                body: FinPlanCalendar(
                                  onCallBack: ()=>{

                                  }
                                )
                              ));
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
                              // final fileContent = await FileManager.getFromFile(tokenFileName) ?? 'Error : File is blank!'; 
                              final accessToken = await SecureFileManager.getAccessToken() ?? 'Error : no token found!'; 
                              navigateTo(currentContext, Scaffold(appBar: AppBar(), body: Center(child: Text(accessToken)))); 
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
                                  navigateTo(currentContext, Scaffold(body: FinPlanAllAccounts()));
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
                                  navigateTo(currentContext, Scaffold(body: FinPlanAllMessages()));
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
                                  navigateTo(currentContext, Scaffold(body: FinPlanAllTransactions()));
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
    String accessToken = await SecureFileManager.getAccessToken() ?? 'Error! You are not logged in yet';
    Logger().d('Inside navigate to method accessToken : $accessToken');
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
                child: Text(accessToken),
              ),
            )
          )
      )
    );
  }

}