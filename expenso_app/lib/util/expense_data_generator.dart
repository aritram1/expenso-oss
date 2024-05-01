// data_generator.dart
// ignore_for_file: constant_identifier_names

import 'package:device_info/device_info.dart';
import 'package:expenso_app/util/finplan__constants.dart';
import 'package:expenso_app/util/finplan__inbox_message_util.dart';
import 'package:expenso_app/util/finplan__salesforce_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ExpenseDataGenerator {

  
  static Logger log = Logger();
  static bool debug = bool.parse(dotenv.env['debug'] ?? 'false');
  static bool detaildebug = bool.parse(dotenv.env['detaildebug'] ?? 'false');
  static String customEndpointForDeleteAllMessagesAndTransactions = dotenv.env['customEndpointForDeleteAllMessagesAndTransactions'] ?? '/services/apexrest/FinPlan/api/delete/*';

  static const String DATE_FORMAT_IN = FinPlanConstant.IN_DATE_FORMAT; // Format to denote yyyy-mm-dd format

  
  
  static Future<List<Map<String, dynamic>>> generateDataForExpenseScreen1({required DateTime startDate, required DateTime endDate}) async {
   
    if(debug) log.d('generateDataForExpenseScreen1 : StartDate is $startDate, endDate is $endDate');
    
    // Format the dateTime to date accordingly
    String formattedStartDate = DateFormat(DATE_FORMAT_IN).format(startDate);
    String formattedEndDate = DateFormat(DATE_FORMAT_IN).format(endDate);
    
    // Create the date clause to use in query later
    String dateClause =  'FinPlan__Transaction_Date__c >= $formattedStartDate AND FinPlan__Transaction_Date__c <= $formattedEndDate';
    if(debug) log.d('StartDate is $startDate, endDate is $endDate and dateClause is=> $dateClause');

    List<Map<String, dynamic>> generatedDataForExpenseScreen1 = [];
    Map<String, dynamic> response = await SalesforceUtil.queryFromSalesforce(
      objAPIName: 'FinPlan__Bank_Transaction__c', 
      fieldList: ['Id', 'FinPlan__Beneficiary_Name__c','FinPlan__Transaction_Date__c', 'FinPlan__Amount__c','FinPlan__Type__c'],
      whereClause: dateClause,
      orderByClause: 'FinPlan__Transaction_Date__c desc',
      //count : 120
    );
    dynamic error = response['error'];
    dynamic data = response['data'];

    if(detaildebug) log.d('Error: ${error.toString()}');
    if(detaildebug) log.d('Data inside : ${data.toString()}');

    if(error != null && error.isNotEmpty){
      if(debug) log.d('Error occurred while querying inside generateDataForExpenseScreen1 : ${response['error']}');
      //return null;
    }
    else if (data != null && data.isNotEmpty) {
      try{
        dynamic records = data['data'];
        if (records != null && records.isNotEmpty) {
          for (var record in records) {
            Map<String, dynamic> recordMap = Map.castFrom(record);
            generatedDataForExpenseScreen1.add({
              'Paid To': recordMap['FinPlan__Beneficiary_Name__c'] ?? 'Default Beneficiary',
              'Amount': recordMap['FinPlan__Amount__c'] ?? 0,
              'Date': DateTime.parse(recordMap['FinPlan__Transaction_Date__c'] ?? DateTime.now().toString()),
              'Id': recordMap['Id'] ?? 'Default Id',
              'BeneficiaryType': recordMap['FinPlan__Beneficiary_Type__c'] ?? '',
            });
          }
        }
      }
      catch(error){
        if(debug) log.e('Error inside generateDataForExpenseScreen1 : $error');
      }
    }
    if(detaildebug) log.d('Inside generateDataForExpenseScreen1=>$generatedDataForExpenseScreen1');
    return generatedDataForExpenseScreen1;
  }

}