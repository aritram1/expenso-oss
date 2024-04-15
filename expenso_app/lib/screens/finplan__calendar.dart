// ignore_for_file: prefer_const_constructors

import 'package:expenso_app/util/finplan__calendar_util.dart';
import 'package:expenso_app/widgets/finplan__Tile.dart';
import 'package:expenso_app/widgets/finplan__listview.dart';
import 'package:expenso_app/widgets/finplan__listview_future.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';

class FinPlanCalendar extends StatefulWidget {
  final Function onCallBack;

  const FinPlanCalendar({super.key, required this.onCallBack});

  @override
  State<FinPlanCalendar> createState() => _FinPlanCalendarState();
}

class _FinPlanCalendarState extends State<FinPlanCalendar> {
  late Map<String, dynamic> data;
  static final Logger log = Logger();
  Set<String> selectedIds = {};

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    data = {}; // Initialize data map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar and Tasks'),
        actions: [
          GestureDetector(
            onTap: () {
              // Logic for notification icon tap
            },
            child: const Icon(Icons.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          getCalendar(),
          Divider(indent: 12, endIndent: 20,),
          getTasks(_selectedDay.toString()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Add logic for FAB
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Future<Map<String, dynamic>> getCurrentTaskRecords() async{
    Map<String, dynamic> data = await FinPlanCalendarUtil().getFutureData(day : _selectedDay.toString());
    return data;
  }
  
  getCalendar() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TableCalendar(
        calendarFormat: _calendarFormat,
        focusedDay: _focusedDay,
        firstDay: DateTime(2010),
        lastDay: DateTime(2050),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          Logger().d('selectedDay is $selectedDay');
          Logger().d('focused day is $focusedDay');
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
  
  getTasks(String? taskDateTime) {
    return Expanded(
      child: FutureBuilder(
        future: FinPlanCalendarUtil().getFutureData(day: taskDateTime), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: const CircularProgressIndicator(),
            ); // Show loading indicator while waiting for data
          }
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}"); // Show error if any
          }
          else if (snapshot.hasData) {
            var tasks = snapshot.data!['data'];
            Logger().d('Task size=> ${tasks.length}');
            Logger().d('Tasks=> $tasks');
            return FinPlanListView(
              records: snapshot.data ?? {'data' : []}, 
              onRecordSelected: (input){
                
              }
            );
          } 
          else {
            return const Text('No Events for the day'); // Handle case where no data is returned
          }
        },
      ),
    );
  }

  // return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           const Text('Current Tasks', style: TextStyle(color: Colors.red)),
  //           const SizedBox(height: 16),
            
  //           FinPlanListViewFuture(
  //             records: getCurrentTaskRecords(), 
  //             onRecordSelected: (input) {
    
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  

  // Widget createListView() {
  //   return Expanded(  // Wrap ListView with Expanded to ensure it takes up available space
  //     child: FutureBuilder<Map<String, dynamic>>(
  //       future: getTasksAsync(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: const CircularProgressIndicator(),
  //           )
  //           ; // Show loading indicator while waiting for data
  //         } else if (snapshot.hasError) {
  //           return Text("Error: ${snapshot.error}"); // Show error if any
  //         } else if (snapshot.hasData) {
  //           var tasks = snapshot.data!['data'] as List<dynamic>;
  //           Logger().d('Task size=> ${tasks.length}');
  //           Logger().d('Tasks=> $tasks');
            
  //           return ListView.builder(
  //             itemCount: tasks.length,
  //             itemBuilder: (context, index) {
  //               var task = tasks[index];
  //               Logger().d('$index => ${task['id']}');
  //               return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 // child: FinPlanTile(
  //                 //   onCallBack: (){},
  //                 //   topLeft: Text(task['id']),
  //                 //   center: Text(task['details'] ?? 'O lala'),
  //                 // ),
  //                 child: Container(
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
  //                   child: ListTile(
  //                     leading: Checkbox(
  //                       value: selectedIds.contains(task['id']),
  //                       onChanged: (bool? value) {
  //                         setState(() {
  //                           Logger().d('value=> $value');
  //                           if(selectedIds.contains(task['id'])){
  //                             selectedIds.remove(task['id']);
  //                           }
  //                           else{
  //                             selectedIds.add(task['id']);
  //                           }
  //                           Logger().d('selectedIds=> $selectedIds');
  //                         });
  //                       },
  //                     ),
  //                     title: Text(task['name']),
  //                     subtitle: Text(task['details']),
  //                     trailing: Text(task['date']),
  //                     tileColor: selectedIds.contains(task['id']) ? Colors.red.shade200 : Colors.green.shade100,
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         } else {
  //           return const Text("No data available"); // Handle case where no data is returned
  //         }
  //       },
  //     ),
  //   );
  // }

}
