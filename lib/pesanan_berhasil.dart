import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marketplace/daftarTransaksi.dart';
import 'package:lottie/lottie.dart';

class PesananBerhasil extends StatefulWidget {
  const PesananBerhasil({Key? key}) : super(key: key);

  @override
  State<PesananBerhasil> createState() => _PesananBerhasilState();
}

class _PesananBerhasilState extends State<PesananBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the Lottie.asset widget and set the duration
            Lottie.asset(
              'assets/success.json', // Replace 'success_animation.json' with your animation file name
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              repeat: false, // Set repeat to false to play the animation only once
              onLoaded: (composition) {
                // Set a timer to navigate back after animation completes
                Timer(Duration(seconds: composition.duration.inSeconds), () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DaftarTransaksi()));
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Pesanan Anda telah berhasil!',
              style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
