// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FinPlanEnhancedPill extends StatelessWidget {
  FinPlanEnhancedPill({
    super.key,
    required this.data,    
    required this.onPillSelected,
  });

  final List<Map<String, dynamic>> data;
  final Function onPillSelected;
  late Map<String, List<Map<String, dynamic>>> dataMapByTypes;

  @override
  Widget build(BuildContext context) {

    dataMapByTypes = generateTypesFromData();
    List<String> allTypes = dataMapByTypes.keys.toList();
    allTypes.sort();
    
    return Container(
      decoration: BoxDecoration(
        //color: Colors.blue.shade50, // Set your desired background color
        borderRadius: BorderRadius.circular(5), // Make borders circular
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: generatePills(allTypes)
      ),
    );
  }


  // This method converts the input `data` to a `dataMap` - grouped by beneficiary / expense types
  Map<String, List<Map<String, dynamic>>> generateTypesFromData() {
    Map<String, List<Map<String, dynamic>>> fMap = {};
    
    for (Map<String, dynamic> each in data) { // The `data` is the record list that has been passed to this widget

      // if beneficiary-type is blank or null then set it to `Others` and classify the `data` by beneficiary types
      String beneficiaryType = (each['BeneficiaryType']?.isEmpty) ? 'Others' : each['BeneficiaryType'];
      List<Map<String, dynamic>> existing = fMap[beneficiaryType] ?? [];
      existing.add(each);
      fMap[beneficiaryType] = existing;

      // along with beneficiary types, we will also be setting the transaction types
      // i.e. Credit or Debit and classify the `data` by trasnaction types
      String type = each['Type'];
      List<Map<String, dynamic>> existingRecords = fMap[type] ?? [];
      existing.add(each);
      fMap[type] = existingRecords;

    }
    Logger().d('Currently the map in fMap => $fMap');
    return fMap;
  }
  
  String generatePillLabel(String eachType) {
    
    String type = eachType;
    String label;
    int count = 0;
    
    // for all the types
    if(eachType == 'All'){
      count = data.length;
    }
    // only for credit type
    else if(eachType == 'Credit'){
      for(var each in data){
        if(each['Type'] == 'Credit') {
          count++;
        }
      }
    }
    // only for debit type
    else if(eachType == 'Debit'){
      for(var each in data){
        if(each['Type'] == 'Debit') {
          count++;
        }
      }
    }
    // For all other types
    else{
      count = dataMapByTypes[eachType]?.length ?? 0;
    }

    label = '$type ($count)';
    return label;
  }

  IconData getPillIcon(String type) {
    IconData iconData = Icons.miscellaneous_services;
    switch (type) {
      case 'Aquarium':
        iconData = Icons.water;
        break;
      case 'Bills':
        iconData = Icons.receipt;
        break;
      case 'Broker':
        iconData = Icons.my_library_books_outlined;
        break;
      case 'Dress':
        iconData = Icons.accessibility_rounded;
        break;
      case 'Entertainment':
        iconData = Icons.movie_creation_outlined;
        break;
      case 'Food and Drinks':
        iconData = Icons.restaurant;
        break;
      case 'Fuel':
        iconData = Icons.oil_barrel_outlined;
        break;
      case 'Grocery':
        iconData = Icons.local_grocery_store;
        break;
      case 'Investment':
        iconData = Icons.inventory_2_outlined;
        break;
      case 'Medicine':
        iconData = Icons.medication_liquid;
        break;
      case 'OTT':
        iconData = Icons.tv;
        break;
      case 'Salary':
        iconData = Icons.attach_money;
        break;
      case 'Shopping':
        iconData = Icons.shopping_bag_outlined;
        break;
      case 'Transfer':
        iconData = Icons.bookmark_rounded;
        break;
      case 'Travel':
        iconData = Icons.travel_explore_rounded;
        break;
      case 'All':
        iconData = Icons.done_all_sharp;
        break;
      case 'Credit':
        iconData = Icons.arrow_downward_sharp;
        break;
      case 'Debit':
        iconData = Icons.arrow_outward_outlined;
        break;
      default:
        break;
    }
    return iconData;
  }

  String getPillLabel(String eachType) {

    int count = dataMapByTypes[eachType]?.length ?? 0;
    
    // for all the types
    if(eachType == 'All'){
      count = data.length;
    }
    // only for credit type
    else if(eachType == 'Credit'){
      for(var each in data){
        if(each['Type'].toUpperCase() == 'CREDIT') {
          count++;
        }
      }
    }
    // only for debit type
    else if(eachType == 'Debit'){
      for(var each in data){
        if(each['Type'].toUpperCase() == 'DEBIT') {
          count++;
        }
      }
    }
    // For all other types
    else{
      count = dataMapByTypes[eachType]?.length ?? 0;
    }

    return count.toString();
  }
  
  List<Widget> generatePills(List<String> availableTypes) {
    
    List<String> _allTypes = ['All', 'Credit', 'Debit', ...availableTypes]; // Add these three hardcoded values as well
    
    List<Widget> allPills = [];

    // // Add the `All` button
    // allPills.add(
    //   Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child: ElevatedButton.icon(
    //       icon: getPillIcon('All'), // Icon inside the button
    //       label: const Text('All'), // Text inside the button
    //       onPressed: () {
    //         onPillSelected('All');
    //       },
    //     ),
    //   ),
    // );

    // Add the `Debit` button
    // allPills.add(
    //   Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child: ElevatedButton.icon(
    //       icon: getPillIcon('Credit'), // Icon inside the button
    //       label: Text(getPillLabel('Credit')), // Text inside the button
    //       onPressed: () {
    //         onPillSelected('Credit');
    //       },
    //     ),
    //   ),
    // );

    // Add the `Credit` pill
    // allPills.add(
    //   Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child: ElevatedButton.icon(
    //       icon: getPillIcon('Debit'), // Icon inside the button
    //       label: Text(getPillLabel('Debit')), // Text inside the button
    //       onPressed: () {
    //         onPillSelected('Debit');
    //       },
    //     ),
    //   ),
    // );

    for (String eachType in _allTypes){
      Widget each = Padding(
        padding: const EdgeInsets.all(4.0),
        child : 
        // ----------------------------------------------------
        ElevatedButton.icon(
          icon: Icon(getPillIcon(eachType)), // Icon inside the button
          label: Text(getPillLabel(eachType)), // Text inside the button
          onPressed: () {
            onPillSelected(eachType);
          },
        ),
        
        // For debug purposes
        // ElevatedButton(
        //   onPressed: () {
        //     onPillSelected(eachType);
        //   },
        //   child: Text(
        //     generatePillLabel(eachType),
        //     style: const TextStyle(fontSize: 12),
        //   ),
        // )
        // ----------------------------------------------------
      );

      allPills.add(each);
      allPills.add(const SizedBox(width: 4));
    }     
    return allPills;
  }

}