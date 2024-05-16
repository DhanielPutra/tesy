import 'package:flutter/material.dart';

class PesananBerhasil extends StatefulWidget {
  const PesananBerhasil({super.key});

  @override
  State<PesananBerhasil> createState() => _PesananBerhasilState();
}

class _PesananBerhasilState extends State<PesananBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Berhasil'),
      ),
      body: Center(
        child: Text(
          'Pesanan Anda telah berhasil!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
