import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureFileManager{

  static String clientId = dotenv.env['clientId'] ?? '';
  static String redirectUri = dotenv.env['redirectUri'] ?? '';
  static String tokenUrl = dotenv.env['tokenEndpoint'] ?? '';
  static String authUrl = dotenv.env['authUrlEndpoint'] ?? '';
  static String revokeUrlEndpoint = dotenv.env['revokeUrlEndpoint'] ?? '';

  static const storage = FlutterSecureStorage();
  
  // Access Token Methods
  
  static Future<String?> getAccessToken() async {
    String? accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  static Future<void> setAccessToken(String accesstoken) async {
    await storage.write(key: 'access_token', value: accesstoken);
  }

  static Future<void> clearAccessToken() async {
    await storage.delete(key: 'access_token');
  }

  // Instance URL methods

  static Future<String?> getInstanceURL() async {
    String? instanceUrl = await storage.read(key: 'instance_url');
    return instanceUrl;
  }

  static Future<void> setInstanceURL(String instanceUrl) async {
    await storage.write(key: 'instance_url', value: instanceUrl);
  }

  static Future<void> clearInstanceURL() async {
    await storage.delete(key: 'instance_url');
  }

  // Timeout methods
  
  // static Future<void> getTBD() async {
  //   await storage.read(key: 'TBD');
  // }

  // static Future<void> setTBD(String TBD) async {
  //   await storage.write(key: 'TBD', value: TBD);
  // }

  // static Future<void> clearTBD() async {
  //   await storage.delete(key: 'TBD');
  // }

}