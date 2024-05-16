import 'package:flutter/material.dart';
import 'package:marketplace/daftarTransaksi.dart';

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
            Navigator.of(context)..push(MaterialPageRoute(builder: (context) => const DaftarTransaksi()));
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
