import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const AppMozo());
}

class AppMozo extends StatelessWidget {
  const AppMozo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Mozo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      
    );
  }
}