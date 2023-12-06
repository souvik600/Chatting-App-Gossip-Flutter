import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:u_chat_me/Screens/auth/login_screen.dart';
import 'package:u_chat_me/Screens/splash_screen.dart';

import 'firebase_options.dart';

// Global object for access screen size
late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gossip',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            elevation: 4,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19),
            backgroundColor: Colors.white),
      ),
      home: const SplashScreen(

      ),
    );
  }
}
