import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/profile.dart';
import 'package:marketplace/rincianPesanan.dart';
import 'dart:convert';
import 'package:marketplace/user_services.dart';

class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({Key? key}) : super(key: key);

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi>
    with SingleTickerProviderStateMixin {
  List<dynamic>? items;
  late TabController _tabController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchItems();
  }

  Future<void> fetchItems() async {
    final String url = 'https://barbeqshop.online/api/pesanan';
    String token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token', // Include the token in the request headers
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
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load items';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching cart data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Color.fromARGB(255, 193, 24, 24),
        title: const Text(
          'Daftar Transaksi',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'Diproses'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildListView(0),
                    buildListView(1),
                    buildListView(2),
                  ],
                ),
    );
  }

  Widget buildListView(int statusIndex) {
    return ListView.builder(
      itemCount: items?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final item = items![index];
        final product = item['produk'] ?? {};

        // Check if the item matches the selected status type
        if (statusIndex == 0) {
          if (item['status_id'] != '1' && item['status_id'] != null) {
            return Container(); // Return empty container if not 'Diproses'
          }
        } else if (statusIndex == 1 && item['status_id'] != '2') {
          return Container(); // Return empty container if not 'Dikirim'
        } else if (statusIndex == 2 && item['status_id'] != '3') {
          return Container(); // Return empty container if not 'Selesai'
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RincianPesanan(item: item),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
                    //borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(product['gambar'] ??
                          'https://via.placeholder.com/120'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        product['nama_produk'] ?? 'Tidak ada data',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Price: Rp. ${product['harga'] ?? 'Tidak ada data'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                    
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
