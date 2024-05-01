// ignore_for_file: must_be_immutable
// import 'package:ExpenseManager/widgets/finplan_table_widget.dart';
import 'package:expenso_app/screens/account/finplan__accounts_util.dart';
import 'package:expenso_app/widgets/finplan__account_cc_card.dart';
import 'package:expenso_app/widgets/finplan__account_sa_card.dart';
import 'package:expenso_app/widgets/finplan__account_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FinPlanAllAccounts extends StatefulWidget {
  
  const FinPlanAllAccounts({super.key});
  
  static final Logger log = Logger();

  @override
  State<FinPlanAllAccounts> createState() => _FinPlanAllAccountsState();
}

class _FinPlanAllAccountsState extends State<FinPlanAllAccounts> {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FinPlanAccountsUtil.getAllAccountsData(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } 
        else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data in All Accounts view ! ${snapshot.error.toString()}'),
          );
        } 
        else {
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: List.generate(snapshot.data!.length,(index) {
                var each = snapshot.data![index];
                if (each['FinPlan__Account_Code__c'].contains('-SA')) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FinPlanSavingsAccountCard(data: each, onCardSelected: () {}),
                  );
                } 
                else if (each['FinPlan__Account_Code__c'].contains('-CC')) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FinPlanCreditAccountCard(data: each, onCardSelected: () {}),
                  );
                } 
                else if (each['FinPlan__Account_Code__c'].contains('-WA')) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FinPlanWalletCard(data: each, onCardSelected: () {}),
                  );
                } 
                else {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.device_unknown),
                        title: Text(each['N/A'] ?? ''),
                        subtitle: const Text('N/A'),
                        trailing: Text(each['N/A'] ?? ''),
                      ),
                    ),
                  );
                }
              }),
            ),
          );

          // return FinPlanTableWidget(
          //   key: key,
          //   headerNames: const ['Name', 'Balance', 'Last Updated'],
          //   noRecordFoundMessage: 'Nothing to approve',
          //   caller: 'ExpenseScreen2',
          //   columnWidths: const [0.2, 0.25, 0.35],
          //   data: snapshot.data!,
          //   onLoadComplete: onLoadComplete,
          //   defaultSortcolumnName: 'Last Updated', // 2 meaning the Date column
          //   showSelectionBoxes : false
          // );
        }
      },
    );
  }
}
