import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expenso_app/util/finplan__exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SalesforceAuthService {

  static String clientId = dotenv.env['clientId'] ?? '';
  static String redirectUri = dotenv.env['redirectUri'] ?? '';
  static String tokenUrl = dotenv.env['tokenEndpoint'] ?? '';
  static String authUrl = dotenv.env['authUrlEndpoint'] ?? '';
  static String revokeUrlEndpoint = dotenv.env['revokeUrlEndpoint'] ?? '';
  static String tokenFileName = dotenv.env['tokenFileName'] ?? '';

  static final Completer<String> _completer = Completer<String>();
  static late final WebViewController webViewController;

  static Future<String?> authenticate(BuildContext context) async {
    BuildContext currentContext = context;

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          // appBar: AppBar(),
          body: SafeArea(
            child: WebView(
              initialUrl: '$authUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              navigationDelegate: (NavigationRequest request) async {
                
                Logger().d('Navigating to: ${request.url}');
                Logger().d('RedirectURI is $redirectUri');
            
                if (request.url.startsWith(redirectUri)) {
                  final uri = Uri.parse(request.url);
                  final code = uri.queryParameters['code'];
                  Logger().d('Code is $code');
                  if (code != null) {
                    final tokenResponse = await http.post(
                      Uri.parse(tokenUrl),
                      headers: {
                        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
                      },
                      body: {
                        'grant_type': 'authorization_code',
                        'client_id': clientId,
                        'redirect_uri': redirectUri,
                        'code': code,
                      },
                    );
                    if (tokenResponse.statusCode == 200) {
                      Logger().d('Token is received as: ${tokenResponse.body}');
                      await _saveToFile(tokenResponse.body);
                      Navigator.pop(context);
                      _completer.complete(tokenResponse.body);
                    } 
                    else {
                      _completer.completeError('Failed to get access token : ${tokenResponse.body}');
                    }
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      ),
    ).then((_) => _completer.future);
  }

  static Future<void> _saveToFile(String responseBody) async {
    Logger().d('Token is getting saved as $responseBody');
    final directory = await getApplicationDocumentsDirectory();
    Logger().d('Path: ${directory.path}');
    Logger().d('Filename is=> ${directory.path}/$tokenFileName');
    final file = File('${directory.path}/$tokenFileName');
    await file.writeAsString(responseBody);
    Logger().d('After login file is => ${await getFromFile()}');
  }

  // Get a value given key
  static Future<String?> getFromFile({ String key = ''}) async {
    Logger().d('Inside get from file method=>');
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$tokenFileName');
    String? value = '';
    if (await file.exists()) {
      final contents = await file.readAsString();
      final Map<String, dynamic> data = json.decode(contents);
      if(key == ''){
        value = json.encode(data);
      }
      else{
        value = data[key];
      }
    }
    Logger().d('key returned is=> $key');
    Logger().d('so value returned is=> $value');
    return value;
  }


  static Future<void> logout() async {
    String? accessToken = await getFromFile(key : 'access_token');
    Logger().d('access_token in logout is => $accessToken');
    Logger().d('before logout file is => ${await getFromFile()}');
    final response = await http.post(
      Uri.parse(revokeUrlEndpoint),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': accessToken,
      },
    );
    await handleResponse(response);

    Logger().d('after logout file is => ${getFromFile()}');
  }

  static handleResponse(dynamic response) async{
    // Handle the normal 200 status code 
    if (response.statusCode == 200) {
      await _clearStoredToken();  // Logout successful, ensure to remove the access token from the token file
    }
    // If its redirection, status 302, handle redirection
    else if (response.statusCode == 302) {
      
      final String? redirectedUrl = response.headers['location'];
      Logger().d('redirectedUrl=>${response.headers['location']}');
      
      if (redirectedUrl != null) {
        
        final redirectedResponse = await http.get(Uri.parse(redirectedUrl));
        Logger().d('After redirection status code: ${redirectedResponse.statusCode}');
        
        await _clearStoredToken();  // Logout successful, ensure to remove the access token from the token file
      } 
      else {
        Logger().e('Error : StatusCode 302 : RedirectionUrl is empty!');
        throw FinPlanException('Error : StatusCode 302 : RedirectionUrl is empty');
      }
    }
    else {
      // Failed to logout for some strange thing :-]
      throw FinPlanException('Failed to logout: ${response.body}, response status code is ${response.statusCode}');
    }
  }

  static Future<void> _clearStoredToken() async {
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

  // Class ends

}

// Example response structure
// {
//     "access_token": "00D5i00000CIhxb...",
//     "refresh_token": "psdfdd....",
//     "signature": "n2WIUfT8o...",
//     "scope": "cdp_ingest_api custom_permissions cdp_segment_api content cdp_api interaction_api chatbot_api cdp_identityresolution_api wave_api cdp_calculated_insight_api einstein_gpt_api web api id eclair_api pardot_api lightning visualforce cdp_query_api sfap_api openid cdp_profile_api refresh_token pwdless_login_api user_registration_api chatter_api forgot_password full",
//     "id_token": "eyJraW...",
//     "instance_url": "https://home406-dev-ed.develop.my.salesforce.com",
//     "id": "https://login.salesforce.com/id/00D5i00000CIhxbEAD/0055i000007pIKjAAM",
//     "token_type": "Bearer",
//     "issued_at": "171070976...",
//     "api_instance_url": "https://api.salesforce.com..."
// }
