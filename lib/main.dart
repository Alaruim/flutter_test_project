import 'package:flutter/material.dart';
import 'services/token_storage.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color(0xAFFF6B35),
          selectionHandleColor: Color(0xFFFF6B35),
          cursorColor: Color(0xFFFF6B35),
        ),
      ),
      home: FutureBuilder(
        future: TokenStorage.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data == true ? HomeScreen() : LoginScreen();
          }
        },
      ),
    );
  }
}