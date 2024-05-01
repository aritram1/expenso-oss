// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:expenso_app/screens/app_bar/finplan__app_bar.dart';
import 'package:expenso_app/screens/message/finplan__message_view.dart';
import 'package:expenso_app/util/expense_data_generator.dart';
import 'package:expenso_app/widgets/finplan__datepicker_panel.dart';
import 'package:expenso_app/widgets/finplan__table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanAllTransactions extends StatefulWidget {
  const FinPlanAllTransactions({super.key});

  @override
  FinPlanAllTransactionsState createState() => FinPlanAllTransactionsState();
}

class FinPlanAllTransactionsState extends State<FinPlanAllTransactions> {
  // Declare the required state variables for this page

  static final Logger log = Logger();
  DateTime selectedStartDate = DateTime.now().add(const Duration(days: -7));
  DateTime selectedEndDate = DateTime.now();
  static bool showDatePickerPanel = false;
  static late Future<List<Map<String, dynamic>>> data;
  // static final Future<List<Map<String, dynamic>>> immutableData = DataGenerator.generateDataForFinPlanAllTransactions(startDate : selectedStartDate, endDate : selectedEndDate);

  bool isLoading = false;

  dynamic Function(String) onLoadComplete = (result) {
    log.d('Table loaded Result from FinPlanAllTransactions => $result');
  };

  @override
  void initState() {
    super.initState();
    data = handleFutureDataForExpense1(selectedStartDate, selectedEndDate); // generate the data for the first time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
              
        //       if(isLoading) return; // early return in case the page is already loading

        //       BuildContext currentContext = context;
        //       // Get an alert dialog as confirmation box
        //       bool shouldProceed = await showConfirmationBox(currentContext, 'Sync');
        //       if (shouldProceed) {
        //         setState(() {
        //           isLoading = true;
        //         });

        //         // await Future.delayed(const Duration(seconds: 3));
                
        //         var result = await ExpenseDataGenerator.syncMessages(); // Call the method now
        //         Logger().d('result is=> $result');
                
        //         setState(() {
        //           isLoading = false;
        //         });
        //       }
        //       // Navigator.of(context).pop();
        //     },
        //     child: Icon(Icons.refresh),
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: 
      // isLoading ? 
      //   Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         const Text('Sync in Progress'),
      //         SizedBox(height: 12),
      //         CircularProgressIndicator(),
      //       ],
      //     ),
      //   )
      // :
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              FinPlanDatepickerPanel(
                onDateRangeSelected: handleDateRangeSelection,
              ),
            ]),
          ),
          Expanded(
            child: FutureBuilder(
              future: data,
              builder:(context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                // Case 1 : Async job in progress
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Case 2 : Async job received an error
                else if (snapshot.hasError) {
                  log.e('Error loading data => ${snapshot.error.toString()}');
                  return Center(
                    child: Text('Error loading data => ${snapshot.error.toString()}'),
                  );
                }
                // Case 3 : Async job succeeds but returns no data
                else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Nothing to show now'),
                  );
                }
                // Case 4 : Async job succeeds with data
                else{
                  // return getAllTiles(snapshot.data!);
                  return FinPlanTableWidget(
                    header: const [
                      {'label': 'Paid To', 'type': 'String'},
                      {'label': 'Amount', 'type': 'double'},
                      {'label': 'Date', 'type': 'date'},
                    ],
                    defaultSortcolumnName: 'Date',
                    tableButtonName: 'Approve',
                    noRecordFoundMessage: 'Nothing to approve',
                    columnWidths: const [0.3, 0.2, 0.2],
                    data: snapshot.data!,
                    onLoadComplete: onLoadComplete,
                    showSelectionBoxes: false,
                  );
                }
              },
            )
          ),
        ],
      ),
    );
  }

  // Util methods for this widget
  Icon getIcon(dynamic row) {
    Icon icon;
    String type = row['BeneficiaryType'] ?? '';
    switch (type) {
      case 'Grocery':
        icon = const Icon(Icons.local_grocery_store);
        break;
      case 'Bills':
        icon = const Icon(Icons.receipt);
        break;
      case 'Food and Drinks':
        icon = const Icon(Icons.restaurant);
        break;
      case 'Others':
        icon = const Icon(Icons.miscellaneous_services);
        break;
      default:
        icon = const Icon(Icons.person);
        break;
    }
    return icon;
  }

  // method to get widget data
  Future<List<Map<String, dynamic>>> handleFutureDataForExpense1(DateTime startDate, DateTime endDate) async {
    try {
      var data = await ExpenseDataGenerator.generateDataForExpenseScreen1(startDate: startDate, endDate: endDate);
      return Future.value(data);
      // return data;
    } catch (error, stackTrace) {
      log.e('Error in handleFutureDataForExpense1: $error');
      log.e('Stack trace: $stackTrace');
      return Future.value([]);
    }
  }

  // method to handle date range click
  void handleDateRangeSelection(DateTime startDate, DateTime endDate) async {
    log.d('In callback startDate $startDate, endDate $endDate');
    setState(() {
      selectedStartDate = startDate;
      selectedEndDate = endDate;
      data = handleFutureDataForExpense1(startDate, endDate);
    });
  }
}

getAllTiles(var data) {
  List<Widget> allTiles = [];
    for(int i = 0; i<data.length; i++){
      dynamic each = data[i];
      allTiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple.shade100, width: 1),
              gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.purple.shade200]),
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              selected: true,
              //leading: getIcon(each),
              title: Text(
                each['Paid To'],
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(each['Amount']),
                    style: const TextStyle(fontSize: 18, color: Colors.black)
                  ),
                  Text(
                    DateFormat('dd-MM-yyyy').format(each['Date']),
                    style: const TextStyle(fontSize: 12, color: Colors.black)
                  ),
                ],
              ),
              trailing: GestureDetector(
                child: Icon(Icons.navigate_next),
                onTap: (){
                  // String smsId = each['Id'];
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (_)=>
                  //     Scaffold(
                  //       appBar: AppBar(),
                  //       body: Center(
                  //         child: SizedBox(
                  //           height: 200,
                  //           width: 200,
                  //           child: FinPlanTransactionDetail(
                  //             sms: jsonEncode(each),
                  //             onCallBack: (){}
                  //           ),
                  //         ),
                  //       )
                  //     )
                  //   )
                  // );
                },
              ),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: allTiles,
      )
    );
}

// A confirmation box to show if its ok to proceed with sync and delete operation
Future<dynamic> showConfirmationBox(BuildContext context, String opType) {
  String title = 'Please confirm';
  String choiceYes = 'Yes';
  String choiceNo = 'No';
  String content = (opType == 'Sync')
      ? 'This will delete existing messages and recreate them. Proceed?'
      : 'This will delete all messages and transactions. Proceed?';

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

// TB documented
// json format for data for this widget
// {
//   'Paid To': '',
//   'Amount': '',
//   'Date': '',
//   'Id': '',
//   'BeneficiaryType': '',
//   ... etc
// }