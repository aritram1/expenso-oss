// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FinPlanListView extends StatefulWidget {
  FinPlanListView({
    Key? key,
    required this.records,
    required this.onRecordSelected,
  }) : super(key: key);

  final Map<String, dynamic> records;
  final Function(dynamic) onRecordSelected;

  @override
  _FinPlanListViewState createState() => _FinPlanListViewState();
}

class _FinPlanListViewState extends State<FinPlanListView> {
  Set<String> selectedIds = {};

  @override
  Widget build(BuildContext context) {
    var taskList = widget.records['data'];
    return ListView.separated(
      itemBuilder: (context, index) {
        Map<String, dynamic> each = taskList[index];
        return getEachListTile(context, each); 
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 4); // Divider();
      },
      itemCount: taskList.length,
    );
  }
  
  Widget getEachListTile(BuildContext context, Map<String, dynamic> each) {

    String id = each['id'].toString();
    String name = each['name'].toString();
    String when = each['when'].toString();
    String details = each['details'].toString();
    bool completed = each['completed'] ?? false;
    bool allDay = each['allDay'] ?? false;
    bool recurring = each['recurring'] ?? false;
    int priority = each['priority'].toInt();

    return 
    Padding(
      padding: const EdgeInsets.symmetric(horizontal : 8.0),
      child: Container(
        decoration: BoxDecoration(
          color : getTileColor(priority),
          borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          leading: Checkbox(
            value: selectedIds.contains(id),
            onChanged: (value) {
              setState(() {
                if (value != null && value) {
                  selectedIds.add(id);
                } else {
                  selectedIds.remove(id);
                }
              });
              widget.onRecordSelected(each);
            },
          ),
          title: completed ? Text(name, style: TextStyle(decoration: TextDecoration.lineThrough),) : Text(name),
          subtitle: Text(details),
          trailing: Text(when),
          // tileColor: getTileColor(imp),
        ),
      ),
    );
  }
  
  Color getTileColor(int priority) {
    Color color = Colors.black;
    switch (priority) {
      case 1:
        color = Colors.red.shade200;
        break;
      case 2:
        color = Colors.amber.shade200;
        break;
      case 3:
        color = Colors.green.shade200;
        break;
      default:
        break;
    }
    return color;
  }
}
