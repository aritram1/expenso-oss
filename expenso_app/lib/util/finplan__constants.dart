// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class FinPlanConstant {
  static const String DATABASE_NAME = 'expenso.db';
  static const String APP_NAME = 'Expenso'; // This name is shown in `Recent Items` in android
  static const String IN_DATE_FORMAT = 'yyyy-MM-dd';
  static const String INVALID_SESSION_ID = 'INVALID_SESSION_ID';
  static const bool DEBUG = true; //= bool.parse(dotenv.env['debug'] ?? 'false');
  static const bool DETAILED_DEBUG = true; // bool.parse(dotenv.env['detaildebug'] ?? 'false');
}