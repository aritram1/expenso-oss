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

    String id = each['id'];
    String name = each['name'];
    String date = each['date'];
    String details = each['details'];
    bool completed = each['completed'] == '1';
    String imp = each['imp'];

    return 
    Padding(
      padding: const EdgeInsets.symmetric(horizontal : 8.0),
      child: Container(
        decoration: BoxDecoration(
          color : getTileColor(imp),
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
          trailing: Text(date),
          // tileColor: getTileColor(imp),
        ),
      ),
    );
  }
  
  Color getTileColor(String imp) {
    Color color = Colors.black;
    switch (imp) {
      case 'h':
        color = Colors.red.shade200;
        break;
      case 'm':
        color = Colors.amber.shade200;
        break;
      case 'l':
        color = Colors.green.shade200;
        break;
      default:
        break;
    }
    return color;
  }
}
