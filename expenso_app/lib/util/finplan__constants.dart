// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class FinPlanConstant {
  static const String DATABASE_NAME = 'expenso.db';
  static const String APP_NAME = 'Expenso'; // This name is shown in `Recent Items` in android
  static const String IN_DATE_FORMAT = 'yyyy-MM-dd';
  static const String INVALID_SESSION_ID = 'INVALID_SESSION_ID';
  static const String INSERT = 'insert';
  static const String UPDATE = 'update';
  static const String DELETE = 'delete';
  static const String LOGIN = 'login';
  static const String SYNC = 'sync';
  static const String DELETE_MESSAGES = 'delete_messages';
  static const String DELETE_TRANSACTIONS = 'delete_transactions';
  static const String APPROVE_MESSAGES = 'syapprove_messagesnc';

  static const Map<String, List<dynamic>> ICON_LABEL_DATA = {
    'Aquarium' : ['Aquarium', Icons.water],
    'Bills' : ['Bills', Icons.receipt],
    'ATM Withdrawal' : ['ATM Withdrawal', Icons.auto_awesome_sharp],
    'Broker' : ['Broker', Icons.inventory_sharp],
    'Dress' : ['Dress', Icons.rotate_90_degrees_cw_sharp],
    'Entertainment' : ['Entertainment', Icons.movie_creation_outlined],
    'Food and Drinks' : ['Food and Drinks', Icons.restaurant],
    'Fuel' : ['Fuel', Icons.oil_barrel_outlined],
    'Grocery' : ['Grocery', Icons.local_grocery_store],
    'Investment' : ['Investment', Icons.inventory_2_outlined],
    'Medicine' : ['Medicine', Icons.medication_liquid],
    'Other' : ['Other', Icons.devices_other],
    'OTT' : ['OTT', Icons.tv],
    'Salary' : ['Salary', Icons.attach_money],
    'Shopping' : ['Shopping', Icons.shopping_bag_outlined],
    'Transfer' : ['Transfer', Icons.bookmark_rounded],
    'Travel' : ['Travel', Icons.travel_explore],
    'Credit' : ['Credit', Icons.arrow_downward_sharp],
    'Debit' : ['Debit', Icons.arrow_outward_outlined],
    'All' : ['All', Icons.done_all_sharp]
  };
}