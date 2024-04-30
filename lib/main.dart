import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:marketplace/homepage.dart';
import 'package:marketplace/splashscreen.dart';
// ignore: unused_import
import 'package:marketplace/view/Register/login.dart';
// ignore: unused_import
import 'package:marketplace/view/Register/register.dart';
// ignore: unused_import
import 'package:marketplace/wishlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const Login(),
    );
  }
}
