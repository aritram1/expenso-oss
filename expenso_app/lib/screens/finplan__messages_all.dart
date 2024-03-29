// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:expenso_app/screens/finplan__app_bar.dart';
import 'package:expenso_app/screens/finplan__message_detail.dart';
import 'package:expenso_app/util/expense_data_generator.dart';
import 'package:expenso_app/widgets/finplan__datepicker_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanAllMessages extends StatefulWidget {

  const FinPlanAllMessages({super.key});

  @override
  FinPlanAllMessagesState createState() => FinPlanAllMessagesState();
}

class FinPlanAllMessagesState extends State<FinPlanAllMessages>{

  // Declare the required state variables for this page

  static final Logger log = Logger();
  DateTime selectedStartDate = DateTime.now().add(const Duration(days: -7));
  DateTime selectedEndDate = DateTime.now();
  static bool showDatePickerPanel = false;
  static late Future<List<Map<String, dynamic>>> data;
  // static final Future<List<Map<String, dynamic>>> immutableData = DataGenerator.generateDataForFinPlanAllMessages(startDate : selectedStartDate, endDate : selectedEndDate);

  dynamic Function(String) onLoadComplete = (result) {
    log.d('Table loaded Result from FinPlanAllMessages => $result');
  };

  @override
  void initState(){
    super.initState();
    data = handleFutureDataForExpense0(selectedStartDate, selectedEndDate); // generate the data for the first time
  }

  @override
  Widget build(BuildContext context) {
    return 
      // The table panel
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : 8.0), 
              child: Column(
                children: [
                  FinPlanDatepickerPanel(
                    onDateRangeSelected: handleDateRangeSelection,
                  ),
                ]
              ),
            ),
            Expanded(
              // padding: EdgeInsets.all(8),
              child: FutureBuilder(
                future: data,
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                      child: Text('Nothing to approve now'),
                    );
                  }
                  // Case 4 : Async job succeeds with data  
                  else {
                    List<Widget> allTiles = [];
                    for(int i = 0; i<snapshot.data!.length; i++){
                      dynamic each = snapshot.data![i];
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
                              leading: getIcon(each),
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
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (_)=> 
                                      Scaffold(
                                        appBar: AppBar(), 
                                        body: Center(
                                          child: SizedBox(
                                            height: 200,
                                            width: 200,
                                            child: FinPlanMessageDetail(
                                              sms: jsonEncode(each), 
                                              onCallBack: (){}
                                            ),
                                          ),
                                        )
                                      )
                                    )
                                  );
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
                    
                    // return FinPlanTableWidget(
                    //   key: widget.key,
                    //   headerNames: const ['Paid To', 'Amount', 'Date'],
                    //   noRecordFoundMessage: 'Nothing to approve',
                    //   caller: 'FinPlanAllMessages',
                    //   columnWidths: const [0.3, 0.2, 0.2],
                    //   data: snapshot.data!,
                    //   onLoadComplete: onLoadComplete,
                    //   defaultSortcolumnName: 'Date',
                    // );
                  }
                },
              )
            ),
          ],
        );
      
  }

  // Util methods for this widget
  Icon getIcon(dynamic row){
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
  Future<List<Map<String, dynamic>>> handleFutureDataForExpense0(DateTime startDate, DateTime endDate) async {
    try {
      return Future.value(await ExpenseDataGenerator.generateDataForExpenseScreen0(startDate: startDate, endDate: endDate));
      // return data;
    } 
    catch (error, stackTrace) {
      log.e('Error in handleFutureDataForExpense0: $error');
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
      data = handleFutureDataForExpense0(startDate, endDate);
    });
  }

}

// Archive
// json format for data for this widget
// {
//   'Paid To': '',
//   'Amount': '',
//   'Date': '',
//   'Id': '',
//   'BeneficiaryType': '',
// }