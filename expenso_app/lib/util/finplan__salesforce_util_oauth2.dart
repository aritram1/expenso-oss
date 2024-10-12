import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expenso_app/util/finplan__exception.dart';
import 'package:expenso_app/util/finplan__filemanager.dart';
import 'package:expenso_app/util/finplan__salesforce_util.dart';
import 'package:expenso_app/util/finplan__secure_filemanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
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
                      Logger().d('Status Code, 200, OK detected! Response text : ${tokenResponse.body}');
                      Map<String, dynamic> parsedResponse = jsonDecode(tokenResponse.body);
                      
                      if(parsedResponse['access_token'] != null || parsedResponse['instance_url'] != null){
                        await SecureFileManager.setAccessToken(parsedResponse['access_token']);
                        await SecureFileManager.setInstanceURL(parsedResponse['instance_url']);
                      }
                      else{
                        throw FinPlanException('Failed to get Access Token : ${tokenResponse.body}');
                      }
                      _completer.complete(jsonEncode(parsedResponse)); // Complete the completer with the parsed response
                    
                    }
                    else {
                      // throw FinPlanException('Failed to get Access Token : ${tokenResponse.body}');
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

  // The method for logout from the app
  static Future<void> logout() async {
    String? accessToken = await SecureFileManager.getAccessToken();
    Logger().d('access_token before logout is => $accessToken');
    if(accessToken != null && !accessToken.toUpperCase().startsWith('ERROR')) {
      await revokeAccessToken(accessToken);
    }
    Logger().d('access_token after logout is => ${await SecureFileManager.getAccessToken()}');
  }

  static dynamic revokeAccessToken(String? accessToken) async{
    final response = await http.post(
      Uri.parse(revokeUrlEndpoint),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': accessToken,
      },
    );
    
    // Handle the Status 200 (Status: OK)
    // Logout successful, ensure to remove the access token
    if (response.statusCode == 200) {
      await SecureFileManager.clearAccessToken();
    }
    
    // Handle the status 302, (STATUS: Redirection)
    else if (response.statusCode == 302) {

      Logger().d('Redirection Happened during logout from the app!');
      
      final String? redirectedUrl = response.headers['location'];
      Logger().d('redirectedUrl=>${response.headers['location']}');
      
      if (redirectedUrl != null) {
        
        final redirectedResponse = await http.get(Uri.parse(redirectedUrl));
        Logger().d('After redirection status code: ${redirectedResponse.statusCode}');
                
        // await FileManager.deleteKeyFromFile(tokenFileName, key : 'access_token');  
        await SecureFileManager.clearAccessToken(); // Logout successful, ensure to remove the access token from the token file
        
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

  // static Future<bool> checkIfAlreadyLoggedIn() async {
  //   // Get the existing token
  //   String? existingToken = await SecureFileManager.getAccessToken();
  //   return existingToken == null;
  // }

  // static Future<String?> anothermethod(){
  //   // do a query callout check if u
  //   if(existingToken != '' && existingToken != null){
  //     Map<String, dynamic> response = await SalesforceUtil
  //                                       .queryFromSalesforce(
  //                                         objAPIName: 'FinPlan__SMS_Message__c', 
  //                                         fieldList: ['Id'], 
  //                                         count : 1
  //                                       );
  //     dynamic error = response['error'];

  //     if(error != null && error.isNotEmpty && error.toString().contains('expired')){
  //       SecureFileManager.clearAccessToken();
  //       SecureFileManager.clearInstanceURL();
  //       existingToken = '';
  //     }
  //   }
  //   return existingToken;
  // }
  
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
