// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:expenso_app/screens/message/finplan__util.dart';
import 'package:expenso_app/util/finplan__exception.dart';
import 'package:expenso_app/widgets/finplan__datepicker_panel.dart';
import 'package:expenso_app/widgets/finplan__pill.dart';
import 'package:expenso_app/widgets/finplan__table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanAllMessages extends StatefulWidget {
  const FinPlanAllMessages({super.key});

  @override
  FinPlanAllMessagesState createState() => FinPlanAllMessagesState();
}

class FinPlanAllMessagesState extends State<FinPlanAllMessages> {
  // Declare the required state variables for this page

  static final Logger log = Logger();
  static DateTime selectedStartDate =DateTime.now().add(const Duration(days: -7));
  static DateTime selectedEndDate = DateTime.now();
  static bool showDatePickerPanel = false;
  List<Map<String, dynamic>> tableData = [];
  static List<Map<String, dynamic>> allData = [];
  static Set<String> availableTypes = {};
  Map<String, List<Map<String, dynamic>>> filteredDataMap = {};

  static bool isLoading = false;

  dynamic Function(String) onLoadComplete = (result) {
    if (result == 'SUCCESS') {
      log.d('Table loaded Result from FinPlanAllMessages => $result');
    } else {
      log.d('Table load failed with result => $result');
    }
  };

  @override
  void initState() {
    super.initState();
    // allData = getAllTransactionMessages(selectedStartDate,selectedEndDate); // generate the data for the first time
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    return getAllTransactionMessages(selectedStartDate, selectedEndDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          GestureDetector(
            onTap: () async {
              if (isLoading) {
                return; // early return in case the page is already loading
              }

              BuildContext currentContext = context;
              // Get an alert dialog as confirmation box
              bool shouldProceed = await showConfirmationBox(currentContext, 'Sync');
              if (shouldProceed) {
                setState(() {
                  isLoading = true;
                });

                // await Future.delayed(const Duration(seconds: 1)); // delay for 1 sec

                var result = await FinPlanMessagesUtil.syncMessages(); // Call the method now
                Logger().d('result is=> $result');

                setState(() {
                  isLoading = false;
                });
              }
              // Navigator.of(context).pop();
            },
            child: Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sync in Progress'),
                  SizedBox(height: 12),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Column(
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
                    future: getAllMessages(),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                        // Assign the variables after the data is received from callout
                        allData = snapshot.data!;
                        tableData = snapshot.data!;
                        filteredDataMap = generateDataMap(snapshot.data!);                       
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child : FinPlanPill(
                                  types: getAvailableTypes(), 
                                  onPillSelected: (String pillName) {
                                    Logger().d('Pill name is $pillName');
                                    // tableData = filteredDataMap[pillName] ?? []; // new
                                    setState(() {
                                      // new tbc
                                      // tableData = filterData(allData, pillName);
                                      tableData = filterData(snapshot.data!, pillName);
                                      Logger().d('Inside setstate tableData is => $tableData');
                                      Logger().d('Within setstate method of Pill, the table data is $tableData');
                                    });
                                  }
                                )
                              ),
                            ),
                            Expanded(
                              child: FinPlanTableWidget(
                                header: const [
                                  {'label': 'Paid To', 'type': 'String'},
                                  {'label': 'Amount', 'type': 'double'},
                                  {'label': 'Date', 'type': 'date'},
                                ],
                                defaultSortcolumnName: 'Date',
                                tableButtonName: 'Approve',
                                noRecordFoundMessage: 'Nothing to approve',
                                columnWidths: const [0.3, 0.2, 0.2],
                                data: tableData,
                                onLoadComplete: onLoadComplete,
                              ),
                            ),
                          ],
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
  Future<List<Map<String, dynamic>>> getAllTransactionMessages(DateTime startDate, DateTime endDate) async {
    try {
      
      allData = await FinPlanMessagesUtil.getAllTransactionMessages(startDate: startDate, endDate: endDate);
      Logger().d('LOL allData is: $allData');
      filteredDataMap = generateDataMap(allData);
      Logger().d('filteredDataMap is: $filteredDataMap');

      return Future.value(allData);
      // return data;
    } catch (error, stackTrace) {
      log.e('Error in getAllTransactionMessages: $error');
      log.e('Stack trace: $stackTrace');
      return Future.value([]);
    }
  }

  // This method converts the data to a map of records based on beneficiary type.
  Map<String, List<Map<String, dynamic>>> generateDataMap(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> fMap = {};
    for (Map<String, dynamic> each in data) {
      // if type is blank or null then set it to `Others`
      String type = (each['BeneficiaryType'] == null || each['BeneficiaryType'] == '') ? 'Others' : each['BeneficiaryType'];
      List<Map<String, dynamic>> existing = filteredDataMap[type] ?? [];
      existing.add(each);
      fMap[type] = existing;
    }
    Logger().d('Filtered map => $filteredDataMap');
    return fMap;
  }

  // method to handle date range click
  void handleDateRangeSelection(DateTime startDate, DateTime endDate) async {
    log.d('In callback startDate $startDate, endDate $endDate');
    setState(() {
      selectedStartDate = startDate;
      selectedEndDate = endDate;
      getAllTransactionMessages(startDate, endDate);
    });
  }
  
  Set<String> getAvailableTypes() {
    if(filteredDataMap.isEmpty) throw FinPlanException('Filtered Map is empty! But why!');
    return filteredDataMap.keys.toSet();
  }
  
  // Filtered data
  List<Map<String, dynamic>> filterData(List<Map<String, dynamic>> data, String pillName) {
    List<Map<String, dynamic>> temp = [];
    for(Map<String, dynamic> each in data){
      if(each['beneficiaryType'] == pillName){
        temp.add(each);
      }
    }
    Logger().d('Inside Filter dat amethod, return is=> $temp');
    return temp;
  }
}

getAllTiles(var data) {
  List<Widget> allTiles = [];
  for (int i = 0; i < data.length; i++) {
    dynamic each = data[i];
    allTiles.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.purple.shade100, width: 1),
              gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.purple.shade200]),
              borderRadius: BorderRadius.circular(10)),
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
                    NumberFormat.currency(locale: 'en_IN', symbol: '₹')
                        .format(each['Amount']),
                    style: const TextStyle(fontSize: 18, color: Colors.black)),
                Text(DateFormat('dd-MM-yyyy').format(each['Date']),
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.navigate_next),
              onTap: () {
                // String smsId = each['Id'];
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (_)=>
                //     Scaffold(
                //       appBar: AppBar(),
                //       body: Center(
                //         child: SizedBox(
                //           height: 200,
                //           width: 200,
                //           child: FinPlanMessageDetail(
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
              // setState(() {
              //   isLoading = true;
              // });
            },
            child: Text(choiceYes),
          ),
        ],
      );
    },
  );
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
