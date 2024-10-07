import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expenso_app/util/finplan__exception.dart';
import 'package:expenso_app/util/finplan__salesforce_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FileManagerUtil{
  static String clientId = dotenv.env['clientId'] ?? '';
  static String redirectUri = dotenv.env['redirectUri'] ?? '';
  static String tokenUrl = dotenv.env['tokenEndpoint'] ?? '';
  static String authUrl = dotenv.env['authUrlEndpoint'] ?? '';
  static String revokeUrlEndpoint = dotenv.env['revokeUrlEndpoint'] ?? '';
  
  static Future<void> saveToFile(String tokenFileName, String responseBody) async {
    Logger().d('Token is getting saved as $responseBody');
    final directory = await getApplicationDocumentsDirectory();
    Logger().d('Path: ${directory.path}');
    Logger().d('Filename is=> ${directory.path}/$tokenFileName');
    final file = File('${directory.path}/$tokenFileName');
    await file.writeAsString(responseBody);
    Logger().d('After login file is => ${await getFromFile(tokenFileName)}');
  }

  // Get a value given key
  static Future<String?> getFromFile(String fileName, { String? key }) async {
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    
    if(!await file.exists()) return 'File "$fileName" not found!';
    
    final encodedContent = await file.readAsString();
    final Map<String, dynamic> fileContent = json.decode(encodedContent);
    
    // If a key is specified return its value, else return the whole file content
    if(key != null) {
      return fileContent[key];
    } else {
      return json.encode(fileContent);
    }
  }

  // static Future<void> clearStoredToken(String key, String tokenFileName) async {
  //   deleteKeyFromFile(tokenFileName);
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/$tokenFileName');

  //   if (await file.exists()) {
  //     try {
  //       final contents = await file.readAsString();
  //       final Map<String, dynamic> data = json.decode(contents);
  //       if (data.containsKey('access_token')) {
  //         data.remove('access_token');
  //         await file.writeAsString(json.encode(data));
  //         Logger().d('Stored token cleared successfully.');
  //       } else {
  //         Logger().d('No token found in the file.');
  //       }
  //     } catch (error) {
  //       Logger().e('Failed to clear stored token: $error');
  //     }
  //   } else {
  //     Logger().d('Token file does not exist.');
  //   }
  // }

  static Future<void> deleteKeyFromFile(String tokenFileName, {required String key}) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$tokenFileName');

    if (await file.exists()) {
      try {
        final contents = await file.readAsString();
        final Map<String, dynamic> data = json.decode(contents);
        if (data.containsKey('access_token')) {
          data.remove('access_token');
          await file.writeAsString(json.encode(data));
          Logger().d('Stored token cleared successfully.');
        } else {
          Logger().d('No token found in the file.');
        }
      } catch (error) {
        Logger().e('Failed to clear stored token: $error');
      }
    } else {
      Logger().d('Token file does not exist.');
    }
  }
}