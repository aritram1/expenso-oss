// ignore_for_file: must_be_immutable

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

      // if type is blank or null then set it to `Others`
      String type = (each['BeneficiaryType'] == null || each['BeneficiaryType'] == '') ? 'Others' : each['BeneficiaryType'];
      List<Map<String, dynamic>> existing = fMap[type] ?? [];
      existing.add(each);
      fMap[type] = existing;

    }
    Logger().d('Currently the map in fMap => $fMap');
    return fMap;
  }
  
  String generatePillLabel(String eachType) {
    int count = dataMapByTypes[eachType]?.length ?? 0;
    String type = eachType;
    String label = '$type ($count)';
    return label;
  }

  Icon getPillIcon(String type) {
    Icon icon = const Icon(Icons.miscellaneous_services);
    switch (type) {
      case 'Aquarium':
        icon = const Icon(Icons.water);
        break;
      case 'Bills':
        icon = const Icon(Icons.receipt);
        break;
      case 'Broker':
        icon = const Icon(Icons.my_library_books_outlined);
        break;
      case 'Dress':
        icon = const Icon(Icons.accessibility_rounded);
        break;
      case 'Entertainment':
        icon = const Icon(Icons.movie_creation_outlined);
        break;
      case 'Food and Drinks':
        icon = const Icon(Icons.restaurant);
        break;
      case 'Fuel':
        icon = const Icon(Icons.oil_barrel_outlined);
        break;
      case 'Grocery':
        icon = const Icon(Icons.local_grocery_store);
        break;
      case 'Investment':
        icon = const Icon(Icons.inventory_2_outlined);
        break;
      case 'Medicine':
        icon = const Icon(Icons.medication_liquid);
        break;
      case 'OTT':
        icon = const Icon(Icons.tv);
        break;
      case 'Salary':
        icon = const Icon(Icons.attach_money);
        break;
      case 'Shopping':
        icon = const Icon(Icons.shopping_bag_outlined);
        break;
      case 'Transfer':
        icon = const Icon(Icons.bookmark_rounded);
        break;
      case 'Travel':
        icon = const Icon(Icons.travel_explore_rounded);
        break;
      default:
        break;
    }
    return icon;
  }

  String getPillLabel(String eachType) {
    int count = dataMapByTypes[eachType]?.length ?? 0;
    return count.toString();
  }
  
  List<Widget> generatePills(List<String> allTypes) {
    List<Widget> allPills = [];
    allPills.add(Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.done_all_sharp), // Icon inside the button
        label: const Text('All'), // Text inside the button
        onPressed: () {
          onPillSelected('All');
        },
      ),
    ),
    );
    for (String eachType in allTypes){
      Widget each = Padding(
        padding: const EdgeInsets.all(4.0),
        child : 
        // ----------------------------------------------------
        ElevatedButton.icon(
          icon: getPillIcon(eachType), // Icon inside the button
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