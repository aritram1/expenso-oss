import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SalesforceAuthService {
  static String clientId = dotenv.env['clientId'] ?? '';
  static String redirectUri = dotenv.env['redirectUri'] ?? '';
  static const String authUrl = 'https://login.salesforce.com/services/oauth2/authorize';
  static const String tokenUrl = 'https://login.salesforce.com/services/oauth2/token';

  Future<String?> authenticate(BuildContext context) async {
    final Completer<String> completer = Completer();

    final webView = WebView(
      initialUrl: '$authUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri',
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (String url) async {
        if (url.startsWith(redirectUri)) {
          final uri = Uri.parse(url);
          final code = uri.queryParameters['code'];

          if (code != null) {
            final tokenResponse = await http.post(Uri.parse(tokenUrl), body: {
              'grant_type': 'authorization_code',
              'client_id': clientId,
              'redirect_uri': redirectUri,
              'code': code,
              // Add any additional parameters required by Salesforce
            });

            if (tokenResponse.statusCode == 200) {
              final Map<String, dynamic> tokenData =
                  json.decode(tokenResponse.body);
              final token = tokenData['access_token'];
              await _saveTokenToFile(token);
              completer.complete(token);
            } else {
              completer.completeError('Failed to get access token');
            }
          }
        }
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scaffold(body: webView)),
    );

    return completer.future;
  }

  Future<void> _saveTokenToFile(String token) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/token.json');
    await file.writeAsString(json.encode({'token': token}));
  }

  Future<String?> getTokenFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/token.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final Map<String, dynamic> data = json.decode(contents);
      return data['token'];
    }
    return null;
  }
}
