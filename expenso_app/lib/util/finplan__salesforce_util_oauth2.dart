import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SalesforceAuthService {
  static String clientId = dotenv.env['clientId'] ?? '';
  static String redirectUri = dotenv.env['redirectUri'] ?? '';

  static const String authUrl = 'https://login.salesforce.com/services/oauth2/authorize';
  static const String tokenUrl = 'https://login.salesforce.com/services/oauth2/token';

  final Completer<String> _completer = Completer<String>();
  late final WebViewController webViewController;

  Future<String?> authenticate(BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: WebView(
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
                    // final Map<String, dynamic> tokenData = json.decode(tokenResponse.body);
                    // final token = tokenData['access_token'];
                    // await _saveTokenToFile(token);
                    
                    Logger().d('Token is received as: ${tokenResponse.body}');
                    await _saveToFile(tokenResponse.body);
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
    ).then((_) => _completer.future);
  }

  // Future<void> _saveTokenToFile(String token) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   Logger().d('Path: ${directory.path}');
  //   final file = File('${directory.path}/token.json');
  //   await file.writeAsString(json.encode({'token': token}));
  // }

  Future<void> _saveToFile(String responseBody) async {
    final directory = await getApplicationDocumentsDirectory();
    Logger().d('Path: ${directory.path}');
    final file = File('${directory.path}/token.json');
    await file.writeAsString(responseBody);
  }

  // Get a value given key
  Future<String?> getFromFile() async {
    Logger().d('value is hi hi=>');

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/token.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      // final Map<String, dynamic> data = json.decode(contents);
      // String value = ((key != null) ? data[key] : json.encode(data)) ?? 'pyak pyak'; // an example key is access_token, for all keys refer below
      // Logger().d('value is=> $value');
      return contents;
    }
    return null;
  }
}

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
