// ignore_for_file: constant_identifier_names
import 'package:expenso_app/util/finplan__salesforce_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class FinPlanAccountsUtil {

  static Logger log = Logger();
  static bool debug = bool.parse(dotenv.env['debug'] ?? 'false');
  static bool detaildebug = bool.parse(dotenv.env['detaildebug'] ?? 'false');
  static String customEndpointForDeleteAllMessagesAndTransactions = dotenv.env['customEndpointForDeleteAllMessagesAndTransactions'] ?? '/services/apexrest/FinPlan/api/delete/*';
  
  // A function to get the list of tasks
  static Future<List<Map<String, dynamic>>> getAllAccountsData() async {
    List<Map<String, dynamic>> allAccounts = [];

    Map<String, dynamic> response = await SalesforceUtil.queryFromSalesforce(
      objAPIName: 'FinPlan__Bank_Account__c',
      fieldList: ['Id', 'FinPlan__CC_Last_Paid_Amount__c', 'FinPlan__Account_Code__c', 'Name', 'FinPlan__CC_Billing_Cycle_Date__c', 'FinPlan__CC_Last_Bill_Paid_Date__c', 'FinPlan__Last_Balance__c', 'FinPlan__CC_Available_Limit__c', 'FinPlan__CC_Max_Limit__c','FinPlan__Bill_Due_Date__c', 'LastModifiedDate'], 
      whereClause: 'FinPlan__Active__c = true',
      orderByClause: 'LastModifiedDate desc',
      //count : 120
      );
    dynamic error = response['error'];
    dynamic data = response['data'];

    if(debug) log.d('Error inside generatedDataForExpenseScreen2v2 : ${error.toString()}');
    if(debug) log.d('Datainside generatedDataForExpenseScreen2v2: ${data.toString()}');
    
    if(error != null && error.isNotEmpty){
      if(debug) log.d('Error occurred while querying inside generatedDataForExpenseScreen2v2 : ${response['error']}');
      //return null;
    }
    else if (data != null && data.isNotEmpty) {
      try{
        dynamic records = data['data'];
        if(detaildebug) log.d('Inside generatedDataForExpenseScreen2v2 Records=> $records');
        if(records != null && records.isNotEmpty){
          for (var record in records) {
            Map<String, dynamic> recordMap = Map.castFrom(record);
            allAccounts.add(recordMap);
          }
        }
      }
      catch(error){
        if(debug) log.e('Error Inside generatedDataForExpenseScreen2v2 : $error');
      }
    }
    if(debug) log.d('Inside generatedDataForExpenseScreen2v2=>$allAccounts');
    return allAccounts;
  }

  // static Future<List<Map<String, dynamic>>> generateDataForExpenseScreen2() async {
  //   List<Map<String, dynamic>> generatedDataForExpenseScreen2 = [];

  //   Map<String, dynamic> response = await SalesforceUtil.queryFromSalesforce(
  //     objAPIName: 'FinPlan__Bank_Account__c',
  //     fieldList: ['Id', 'FinPlan__Account_Code__c', 'Name', 'FinPlan__Last_Balance__c', 'FinPlan__CC_Available_Limit__c', 'FinPlan__CC_Max_Limit__c', 'LastModifiedDate'], 
  //     // whereClause: 'FinPlan__Last_Balance__c > 0',
  //     orderByClause: 'LastModifiedDate desc',
  //     //count : 120
  //     );
  //   dynamic error = response['error'];
  //   dynamic data = response['data'];

  //   if(debug) log.d('Error inside generateDataForExpenseScreen2 : ${error.toString()}');
  //   if(debug) log.d('Datainside generateDataForExpenseScreen2: ${data.toString()}');
    
  //   if(error != null && error.isNotEmpty){
  //     if(debug) log.d('Error occurred while querying inside generateDataForExpenseScreen2 : ${response['error']}');
  //     //return null;
  //   }
  //   else if (data != null && data.isNotEmpty) {
  //     try{
  //       dynamic records = data['data'];
  //       if(detaildebug) log.d('Inside generateDataForExpenseScreen2 Records=> $records');
  //       if(records != null && records.isNotEmpty){
  //         for (var record in records) {
  //           Map<String, dynamic> recordMap = Map.castFrom(record);
            
  //           String accountCode = recordMap['FinPlan__Account_Code__c'] ?? 'N/Av';  
  //           double balance = accountCode.contains('-CC') 
  //             ? recordMap['FinPlan__CC_Available_Limit__c'] ?? 0
  //             : recordMap['FinPlan__Last_Balance__c'] ?? 0
  //           ;
  //           DateTime lastmodifiedDate = DateTime.parse(recordMap['LastModifiedDate'] ?? DateTime.now().toString()); // example 2023-12-12T19:56:13.000+0000
  //           String id = recordMap['Id'] ?? 'Default Id';          
            
  //           generatedDataForExpenseScreen2.add({
  //             'Name': accountCode,
  //             'Balance': balance,
  //             'Last Updated': lastmodifiedDate,
  //             'Id': id ,
  //           });
  //         }
  //       }
  //     }
  //     catch(error){
  //       if(debug) log.e('Error Inside generateDataForExpenseScreen2 : $error');
  //     }
  //   }
  //   if(debug) log.d('Inside generateDataForExpenseScreen2=>$generatedDataForExpenseScreen2');
  //   return generatedDataForExpenseScreen2;
  // }

}