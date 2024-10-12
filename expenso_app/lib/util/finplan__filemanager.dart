import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileManager{
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
    
    String fileNotFoundErrorMessage = 'Error : File "$fileName" not found!';
    if(!await file.exists()) return fileNotFoundErrorMessage; // similar to `throw FinPlanException(fileNotFoundErrorMessage)`;
    
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