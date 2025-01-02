import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Authentication/presentation/Login_Page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('mycurrencies');
  // Open the box before using it

  // Add FirebaseOptions for the web platform.
   Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBTL-HL7V6NP91jAWl7uDb6sWhKqo0tzhM",  // Replace with your API key
      authDomain: "your-auth-domain",
      projectId: "your-project-id",
      storageBucket: "your-storage-bucket",
      messagingSenderId: "your-messaging-sender-id",
      appId: "your-app-id",
    ),
  );

  runApp(
    
      MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.yellow,
      ),
      home: LoginPage(),
    );
  }
}