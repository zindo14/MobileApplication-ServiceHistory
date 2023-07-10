// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import, avoid_web_libraries_in_flutter
import 'package:firebase_core/firebase_core.dart';
import 'package:seminarski_projekat/welcome_page.dart';
import 'package:flutter/material.dart';
import 'glavna_stranica.dart';
import 'auth_controller.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}