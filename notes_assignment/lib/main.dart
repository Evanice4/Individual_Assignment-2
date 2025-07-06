import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  // Initialize Firebase before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        // Set pastel yellow as primary color
        primarySwatch: Colors.yellow,
        primaryColor: Color(0xFFFFF59D), // Pastel yellow
        scaffoldBackgroundColor: Color(0xFFFFFDE7), // Very light yellow
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFF59D), // Pastel yellow
          foregroundColor: Colors.black87,
        ),
      ),
      home: LoginScreen(), // Start with login screen
      debugShowCheckedModeBanner: false,
    );
  }
}