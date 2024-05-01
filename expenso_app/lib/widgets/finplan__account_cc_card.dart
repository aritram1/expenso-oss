// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FinPlanCreditAccountCard extends StatelessWidget {
  const FinPlanCreditAccountCard({
    super.key,
    required this.data,
    required this.onCardSelected,
  });

  final Map<String, dynamic> data;
  final Function onCardSelected;

  @override
  Widget build(BuildContext context) {
    // String code = data['FinPlan__Account_Code__c'];
    String name = data['Name'];
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
    
    double ccMaxLimit = data['FinPlan__CC_Max_Limit__c'] ?? 0;
    double ccAvlLimit = data['FinPlan__CC_Available_Limit__c'] ?? 0;
    double ccSpentAmount = ccMaxLimit - ccAvlLimit;
    int ccBillingCycleDate = int.parse(data['FinPlan__CC_Billing_Cycle_Date__c'] ?? '0');
    Logger().d('hello!=> ${data['FinPlan__CC_Last_Bill_Paid_Date__c']}');
    
    String ccBillDueDate = '';
    if(data['FinPlan__Bill_Due_Date__c'] != null){
      ccBillDueDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['FinPlan__Bill_Due_Date__c']));
    }
    String ccLastBillPaidDateStr = data['FinPlan__CC_Last_Bill_Paid_Date__c'];
    double ccLastPaidAmount = data['FinPlan__CC_Last_Paid_Amount__c'] ?? 0;
    DateTime ccLastBillingDate = DateTime(DateTime.now().year, DateTime.now().month, ccBillingCycleDate);
    
    return Column(
      children: [
        Card(
          color: Colors.pink.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text(name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Last Bill Date'),
                Text(DateFormat('dd-MM-yyyy').format(ccLastBillingDate), style: const TextStyle(fontSize: 24)),
                const Text('Last Payment'),
                Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(ccLastPaidAmount), style: const TextStyle(fontSize: 24)),
                const Text('On'),
                Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(ccLastBillPaidDateStr)), style: const TextStyle(fontSize: 24)),
                Visibility(
                  visible: ccLastBillingDate.isBefore(DateTime.parse('${ccLastBillPaidDateStr}T00:00:00')), 
                  child: const Text('Your bill is due.', style: TextStyle(fontSize: 8, color: Colors.red)),),
                const Text('Bill Due Date'),
                Text(ccBillDueDate, style: const TextStyle(fontSize: 24)),
                Text('Last Updated $daysDiffStr', style: const TextStyle(fontSize: 10)),
                // Text('Update Date/Time: $lastUpdatedOn', style: const TextStyle(fontSize: 10)),

              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(ccSpentAmount)),
                const Text('Of'),
                Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(ccMaxLimit))
              ],
            )
          )
        ),
      ],
    );
    }

}