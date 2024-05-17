import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:marketplace/user_services.dart';
import 'package:indexed/indexed.dart';
import 'package:marketplace/product.dart';
import 'package:marketplace/profile.dart';
import 'package:marketplace/rincianPesanan.dart';

class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({super.key});

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  List<dynamic>? items;
  List<dynamic>? inProcessItems;
  List<dynamic>? completedItems;
  List<dynamic>? canceledItems;
  int _selectedIndex = 0; // Variabel untuk menyimpan indeks yang dipilih

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final String url = 'https://barbeqshop.online/api/pesanan';
    String token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token'
        }, // Pass the token in the headers
      );
      ;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          items = data;
          inProcessItems =
              items!.where((item) => item['status_id'] == '1').toList();
          completedItems =
              items!.where((item) => item['status_id'] == '2').toList();
          canceledItems =
              items!.where((item) => item['status_id'] == '3').toList();
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching cart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Transaksi'),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Icon(Icons.arrow_back)), // Tombol kembali di AppBar
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bagian atas: tombol navigasi
            Indexed(
              index: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      ['Dalam Proses', 'Selesai'].asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String label = entry.value;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex =
                              index; // Mengatur indeks yang dipilih saat tombol diklik
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Container(
                              width: 100, // Lebar garis bawah
                              height: 2,
                              color: _selectedIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Bagian tengah: konten sesuai dengan indeks yang dipilih
            Expanded(
              child: ListView.builder(
                itemCount: _getItemsForSelectedIndex().length,
                itemBuilder: (BuildContext context, int index) {
                  final product = _getItemsForSelectedIndex()[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Column(
                          children: [
                            product['gambar'] != null
                                ? Image.network(
                                    product['gambar'],
                                    width: 150,
                                    height: double.infinity,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  );
                  // return ListTile(
                  //   title: Text(product['alamat'] ?? ''),
                  //   subtitle: Text(product['cara_bayar'] ?? ''),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getItemsForSelectedIndex() {
    switch (_selectedIndex) {
      case 0:
        return inProcessItems ?? [];
      case 1:
        return completedItems ?? [];
      case 2:
        return canceledItems ?? [];
      default:
        return [];
    }
  }
}
