// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinPlanSavingsAccountCard extends StatelessWidget {
  const FinPlanSavingsAccountCard({
    super.key,
    required this.data,
    required this.onCardSelected,
  });

  final Map<String, dynamic> data;
  final Function onCardSelected;

  @override
  Widget build(BuildContext context) {

    String code = data['FinPlan__Account_Code__c'];
    String name = data['Name'];
    double lastBalance = data['FinPlan__Last_Balance__c'] ?? 0;
    String lastUpdatedOn = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['LastModifiedDate']));

    int daysDiff = DateTime.now().difference(DateTime.parse(data['LastModifiedDate'])).inDays;
    String daysDiffStr;
    switch(daysDiff){
      case 0:
        daysDiffStr = 'Today';
        break;
      case 1:
        daysDiffStr = 'Yesterday';
        break;
      default:
        daysDiffStr = '$daysDiff days ago';
        break;
    }

    return Card(
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: const Icon(Icons.savings),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Updated $daysDiffStr', style: const TextStyle(fontSize: 10)),
            // Text('Update Date/Time: $lastUpdatedOn', style: const TextStyle(fontSize: 10)),
          ],
        ),
        // trailing: FinPlanTile(
        //   center: const Text('Hello'),
        //   onCallBack: (){}
        // ),
        trailing: Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(lastBalance))
      )
    );  
  }

}