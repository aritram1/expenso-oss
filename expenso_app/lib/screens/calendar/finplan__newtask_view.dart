// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenso_app/db/model/finplan__Task.dart';
import 'package:expenso_app/db/services/finplan__DBInitializer.dart';
import 'package:expenso_app/screens/calendar/finplan__util.dart';
import 'package:expenso_app/widgets/finplan__datepicker_panel.dart';
import 'package:expenso_app/widgets/finplan__listview.dart';
import 'package:expenso_app/widgets/finplan__pill_stateful.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';

class FinPlanCalendarTask extends StatefulWidget {
  final Function onCallBack;
  final DateTime? selectedDay;

  const FinPlanCalendarTask({super.key, required this.onCallBack, required this.selectedDay});

  @override
  State<FinPlanCalendarTask> createState() => _FinPlanCalendarTaskState();
}

class _FinPlanCalendarTaskState extends State<FinPlanCalendarTask> {
  
  late Task task;
  late DateTime selectedDate;  
  bool isRecurring = false;
  List<String> recurringDays = [];
  bool isAllDay = false;
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDay!;
  }

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child : 
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: taskNameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  hintText: 'Enter the Task Name'
                ),
                validator: (value) {
                  if (value == 'Start') {
                    return null;
                  } 
                  else {
                    return ('Enter Start');
                  }             
                },
                onChanged: (value) {
                  Logger().d('Inside onchanged with $value');
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('When is it ?', style: TextStyle(fontSize: 16), selectionColor: Colors.red),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().add(const Duration(days : -365)), // Can select date upto one year back
                        lastDate: DateTime.now().add(const Duration(days : 365)),
                      );
                      if(pickedDate != null){
                        setState(() {
                          selectedDate = pickedDate;  
                        });
                        Logger().d('Date picked as => $pickedDate');
                      }
                    },
                    child: Text(selectedDate.toString().split(' ')[0]),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recurring?', style: TextStyle(fontSize: 16), selectionColor: Colors.red),
                  Checkbox(
                    value: isRecurring, 
                    onChanged: (value){
                      setState(() {
                        isRecurring = value ?? false;
                      });
                    }
                  ),
                ],
              ),
              SizedBox(height: 24),
              Visibility(
                visible : isRecurring,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Every', style: TextStyle(fontSize: 16), selectionColor: Colors.red),
                    Row(
                      children: List.generate(daysOfWeek.length, (index) => 
                        FinPlanStatefulButton(
                          text: daysOfWeek[index], 
                          value: daysOfWeek[index], 
                          onSelectionChanged: (day) {
                            Logger().d('Before Selected Days : $recurringDays');
                            Logger().d('Returned day : $day');
                            if(recurringDays.contains(day)){
                              recurringDays.remove(day);
                            }
                            else{
                              recurringDays.add(day);
                            }
                            Logger().d('After Selected Days : $recurringDays');
                          }
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  Logger().d('seelcted LALA=> $selectedDate');
                  _formKey.currentState!.save();
                  task = Task(
                    name: taskNameController.text, 
                    when: selectedDate,
                    recurring: isRecurring, 
                    detail : taskNameController.text, // To be optimized               
                  );
                  Logger().d('Task in json format => ${task.toMap()}');
                  Logger().d('Save button pressed!');

                  final db = await DatabaseService.instance.database;
                  int taskId = await db.insert('task', task.toMap()); // table name is task
                  Logger().d('New task saved with id $taskId !');

                  Navigator.of(context).pop();
                }, 
                child: Text('Save')
              ),
            ],
        ),
        )
        
      ),
    );
  }
  
}
