import 'dart:math';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:marketplace/homepage.dart';
import 'package:marketplace/user_services.dart';
import 'dart:async';

import 'package:marketplace/view/Register/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen duration
    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Color.fromARGB(255, 163, 6, 6),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your splash screen content her
            Image.asset('assets/bbq.jpg', width: 300, height: 300),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}