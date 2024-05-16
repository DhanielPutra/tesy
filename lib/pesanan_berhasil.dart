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
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Navigasi kembali ke halaman beranda
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
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
