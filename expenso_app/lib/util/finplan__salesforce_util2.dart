// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class SalesforceAuthService {
//   static String clientId = dotenv.env['clientId'] ?? '';
//   static String redirectUri = dotenv.env['redirectUri'] ?? '';

//   static const String authUrl = 'https://login.salesforce.com/services/oauth2/authorize';
//   static const String tokenUrl = 'https://login.salesforce.com/services/oauth2/token';

//   final Completer<String> _completer = Completer<String>();
//   late final WebViewController webViewController;

//   Future<String?> authenticate(BuildContext context) async {
//     final verifier = _generateCodeVerifier();
//     final codeChallenge = _generateCodeChallenge(verifier);

//     return Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(),
//           body: WebView(
//             initialUrl: '$authUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&code_challenge=$codeChallenge&code_challenge_method=S256',
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (controller) {
//               webViewController = controller;
//             },
//             navigationDelegate: (NavigationRequest request) async {
              
//               Logger().d('Navigating to: ${request.url}');
//               Logger().d('REdirectURI is $redirectUri');

//               if (request.url.startsWith(redirectUri)) {
//                 final uri = Uri.parse(request.url);
//                 final code = uri.queryParameters['code']?.substring(0, uri.queryParameters['code']!.length -2);
//                 if (code != null) {
//                   // webViewController.clearCache();
//                   // webViewController.clearHistory();
//                   Logger().d('Code is=>>>> $code');
//                   Logger().d('clientId is=>>>> $clientId');
//                   Logger().d('redirect_uri is=>>>> $redirectUri');
//                   Logger().d('verifier is=>>>> $verifier');

//                   final tokenResponse = await http.post(
//                     Uri.parse(tokenUrl),
//                     body: {
//                       'grant_type': 'authorization_code',
//                       'client_id': clientId,
//                       'redirect_uri': redirectUri,
//                       'code': code,
//                       'code_verifier': verifier,
//                     },
//                   );
//                   if (tokenResponse.statusCode == 200) {
//                     final Map<String, dynamic> tokenData = json.decode(tokenResponse.body);
//                     final token = tokenData['access_token'];
//                     await _saveTokenToFile(token);
//                     _completer.complete(token);
//                   } else {
//                     _completer.completeError('Failed to get access token : ${tokenResponse.body}');
//                   }
//                 }
//                 return NavigationDecision.prevent;
//               }
//               return NavigationDecision.navigate;
//             },
//           ),
//         ),
//       ),
//     ).then((_) => _completer.future);
//   }

//   String _generateCodeVerifier() {
//     final random = Random.secure();
//     final List<int> verifierBytes =
//         List.generate(32, (index) => random.nextInt(256));
//     return base64Url.encode(verifierBytes);
//   }

//   String _generateCodeChallenge(String verifier) {
//     return base64Url.encode(sha256.convert(utf8.encode(verifier)).bytes);
//   }

//   Future<void> _saveTokenToFile(String token) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/token.json');
//     await file.writeAsString(json.encode({'token': token}));
//   }

//   Future<String?> getTokenFromFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/token.json');
//     if (await file.exists()) {
//       final contents = await file.readAsString();
//       final Map<String, dynamic> data = json.decode(contents);
//       return data['token'];
//     }
//     return null;
//   }
// }


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
              Logger().d('REdirectURI is $redirectUri');

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
                    final Map<String, dynamic> tokenData = json.decode(tokenResponse.body);
                    final token = tokenData['access_token'];
                    await _saveTokenToFile(token);
                    Logger().d('Token is received as: $token');
                    _completer.complete(token);
                  } else {
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
