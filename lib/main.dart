import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/result_page.dart';
import 'pages/contact_page.dart';

void main() {
  runApp(StudentResultPortalApp());
}

class StudentResultPortalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      title: 'Student Result Portal',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: Colors.indigo.shade700,
          secondary: Colors.teal.shade400,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 60,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            elevation: 4,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => HomePage(),
        '/result': (_) => ResultPage(),
        '/contact': (_) => ContactPage(),
      },
    );
  }
}
