// ignore_for_file: library_private_types_in_public_api

import 'package:expenso_app/util/finplan__salesforce_util2.dart';
import 'package:flutter/material.dart';
// import 'package:expenso_app/screens/finplan__app_login.dart';
// import 'package:expenso_app/widgets/finplan__tile.dart';

class FinPlanSplashPage extends StatefulWidget {
  const FinPlanSplashPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FinPlanSplashPageState createState() => _FinPlanSplashPageState();
}

class _FinPlanSplashPageState extends State<FinPlanSplashPage> {
  late SalesforceAuthService _authService;
  String? _token;

  @override
  void initState() {
    super.initState();
    _authService = SalesforceAuthService();
    _getToken();
  }

  void _getToken() async {
    final token = await _authService.getTokenFromFile();
    if (token != null) {
      setState(() {
        _token = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            if (_token == null) {
              final token = await _authService.authenticate(context);
              setState(() {
                _token = token;
              });
            }
            // Handle navigation after authentication
          },
          icon: const Icon(Icons.cloud),
          label: const Text("Login With Salesforce"),
        ),
      ),
    );
  }
}
