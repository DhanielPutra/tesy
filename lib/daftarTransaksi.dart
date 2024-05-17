import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/profile.dart';
import 'dart:convert';
import 'package:marketplace/user_services.dart';

class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({Key? key}) : super(key: key);

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  List<dynamic>? items;
  int _selectedStatusIndex = 0; // Index for selected status type

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
          'Authorization': 'Bearer $token' // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        // Sort the data based on status_id
        data.sort((a, b) {
          int statusIdA = int.tryParse(a['status_id'].toString()) ?? 0;
          int statusIdB = int.tryParse(b['status_id'].toString()) ?? 0;
          return statusIdA.compareTo(statusIdB);
        });
        setState(() {
          items = data;
          print(data);
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
    return Scaffold(
       appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Profile(),
          transitionDuration: Duration(milliseconds: 0),
        ),
        (route) => false,
      );
          },
        ),
      ),
      body: Column(
        children: [
          // Segment control for selecting status type
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedStatusIndex = 0;
                      });
                    },
                    child: const Text('Diproses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStatusIndex == 0 ? Colors.blue : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedStatusIndex = 1;
                      });
                    },
                    child: const Text('Dikirim'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStatusIndex == 1 ? Colors.blue : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedStatusIndex = 2;
                      });
                    },
                    child: const Text('Selesai'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStatusIndex == 2 ? Colors.blue : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final item = items![index];
                final product = item['produk'];

                // Check if the item matches the selected status type
                if (_selectedStatusIndex == 0) {
                  // Show items with status ID '1' or null
                  if (item['status_id'] != '1' && item['status_id'] != null) {
                    return Container(); // Return empty container if not 'Diproses'
                  }
                } else if (_selectedStatusIndex == 1 && item['status_id'] != '2') {
                  return Container(); // Return empty container if not 'Dikirim'
                } else if (_selectedStatusIndex == 2 && item['status_id'] != '3') {
                  return Container(); // Return empty container if not 'Selesai'
                }

                return GestureDetector(
                  onTap: () {
                    // Navigate to transaction detail page here
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(product['gambar']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['nama_produk'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: Rp. ${product['harga']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Detail: ${product['detail']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
