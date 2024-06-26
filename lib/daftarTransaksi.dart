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
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
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

  Future<void> postItem(int index) async {
    final String url =
        'https://barbeqshop.online/api/pesanan/${items![index]['id']}';
    String token = await getToken();

    final Map<String, dynamic> item = items![index];
    final Map<String, dynamic> product = item['produk'] ?? {};

    final Map<String, dynamic> postData = {
      "produk_id": product['id'],
      "alamat": item['alamat'],
      "user_id": item['user_id'],
      "bayar_id": item['bayar_id'],
      "status_id": 3,
      "expedisi_id": item['expedisi_id'],
      "harga": product['harga']
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        setState(() {
          items![index]['status_id'] = '3'; // Update status on the client side
          // Refresh the items list to reflect changes
          items = List.from(items!);
        });
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm receipt')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> confirmReceived(int index) async {
    await postItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 193, 24, 24),
        title: const Text(
          'Daftar Transaksi',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const Profile(),
                transitionDuration: const Duration(milliseconds: 0),
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
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildListView('1'),
                    buildListView('2'),
                    buildListView('3'),
                  ],
                ),
    );
  }

  Widget buildListView(String statusId) {
    final filteredItems = items
            ?.where((item) => item['status_id'].toString() == statusId)
            .toList() ??
        [];
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext context, int index) {
        final item = filteredItems[index];
        final product = item['produk'] ?? {};

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RincianPesanan(item: item),
              ),
            );
          },
          child: TransactionItem(
            product: product,
            isShipped: statusId == '2',
            onConfirm: () => confirmReceived(items!.indexOf(item)),
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isShipped;
  final VoidCallback onConfirm;

  const TransactionItem({
    Key? key,
    required this.product,
    required this.isShipped,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        product['gambar'] ?? 'https://via.placeholder.com/120'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isShipped)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: onConfirm,
                            child: Text('Pesanan Diterima'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  255, 193, 24, 24), // Background color
                              foregroundColor: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
