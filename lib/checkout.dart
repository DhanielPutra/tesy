import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:marketplace/pesanan_berhasil.dart';
import 'package:marketplace/transfer.dart';

class Checkout extends StatefulWidget {
  final double totalPayment;
  final dynamic CartItems;
  final bool isFromCart; // Indicator to check if the data is from the cart or product details

  const Checkout({
    Key? key,
    required this.totalPayment,
    required this.CartItems,
    required this.isFromCart, // Add this parameter to indicate the data source
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController alamatController = TextEditingController();
  String _selectedPaymentMethod = ''; // To store the selected payment method
  String _selectedBank = ''; // To store the selected bank

  @override
  void initState() {
    super.initState();
    print('Received cart items: ${widget.CartItems}');
    print('Total Payment: ${widget.totalPayment}');
  }

  Future<int> getUserId() async {
    // Implement your logic to get user ID
    return 1;
  }

  Future<String> getToken() async {
    // Implement your logic to get token
    return 'your_token';
  }

  Future<void> addToPesanan() async {
    final String url = 'https://barbeqshop.online/api/pesanan';

    int userId = await getUserId();
    String token = await getToken();

    String caraBayar = '1'; // Default to Cash on Delivery
    if (_selectedPaymentMethod == '1') {
      caraBayar = '1'; // ID for Cash on Delivery
    } else if (_selectedPaymentMethod == '2') {
      if (_selectedBank == 'Bank BNI') {
        caraBayar = '2'; // ID for Bank BNI
      } else if (_selectedBank == 'Bank BCA') {
        caraBayar = '3'; // ID for Bank BCA
      } else if (_selectedBank == 'Bank Mandiri') {
        caraBayar = 'Bank Mandiri'; // ID for Bank Mandiri
      }
    }

    String produkId;
    String penjualId;
    if (widget.isFromCart) {
      // If the data is from the cart
      produkId = widget.CartItems[0]['produk_id'].toString();
      penjualId = widget.CartItems[0]['penjual_id'].toString();
    } else {
      // If the data is from product details
      produkId = widget.CartItems['id'].toString();
      penjualId = widget.CartItems['author']['id'].toString();
    }

    final Map<String, dynamic> bodyData = {
      'pembeli_id': userId.toString(),
      'alamat': alamatController.text,
      'produk_id': produkId.toString(),
      'user_id': penjualId, // Access the first item in the list and get the penjual_id
      'cara_bayar': caraBayar,
    };

    // Print the data before making the request
    print('Posting data: $bodyData');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: bodyData,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print('Order created successfully.');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PesananBerhasil()),
        );
      } else {
        print('Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  void handlePayment() {
    if (_selectedPaymentMethod == '1') {
      // Cash on Delivery, post the data
      addToPesanan();
    } else if (_selectedPaymentMethod == '2' && _selectedBank.isNotEmpty) {
      // Bank Transfer, navigate to the Transfer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Transfer(
            bankName: _selectedBank,
            alamatPengiriman: alamatController.text,
            cartItems: widget.CartItems,
            isFromCart: widget.isFromCart,
          ),
        ),
      );
    } else {
      // Show a message if no payment method is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih metode pembayaran terlebih dahulu.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: alamatController,
                  cursorColor: Colors.black,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 16.0,
                    ),
                  ),
                ),
                SizedBox(
 height: 25,
                ),
                Text(
                  'Total Pembayaran: Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(widget.totalPayment)},00',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPaymentMethod = '1'; // Menetapkan ID 1 untuk Cash on Delivery
                          _selectedBank = ''; // Reset selected bank when cash on delivery is chosen
                        });
                        print('Selected Payment Method ID: $_selectedPaymentMethod');
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: _selectedPaymentMethod == '1' // Memeriksa apakah ID adalah 1
                            ? Color(0xFFB50B0B) // Jika ID adalah 1, warna latar belakang menjadi merah
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod == '1' // Memeriksa apakah ID adalah 1
                            ? Colors.white // Jika ID adalah 1, warna teks menjadi putih
                            : Color(0xFFB50B0B),
                        side: const BorderSide(color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cash on Delivery'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedMethod = await showMenu<String>(
                          context: context,
                          position: const RelativeRect.fromLTRB(5, 200, 0, 0),
                          items: <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Bank BNI', // Menetapkan ID 2 untuk Bank BNI
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.none,
                                    width: 15,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Transfer Bank BNI',
                                    style: TextStyle(
                                      color: _selectedPaymentMethod == 'Bank BNI' // Memeriksa apakah ID adalah 2
                                          ? Color(0xFFB50B0B) // Jika ID adalah 2, warna teks menjadi merah
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Bank BCA', // Menetapkan ID 2 untuk Bank BCA
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.none,
                                    width: 15,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Transfer Bank BCA',
                                    style: TextStyle(
                                      color: _selectedPaymentMethod == 'Bank BCA' // Memeriksa apakah ID adalah 2
                                          ? Color.fromARGB(255, 19, 65, 204) // Jika ID adalah 2, warna teks sesuai dengan kebutuhan
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Bank Mandiri', // Menetapkan ID 2 untuk Bank Mandiri
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.none,
                                    width: 15,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Transfer Bank Mandiri',
                                    style: TextStyle(
                                      color: _selectedPaymentMethod == 'Bank Mandiri' // Memeriksa apakah ID adalah 2
                                          ? const Color.fromARGB(255, 15, 3, 255) // Jika ID adalah 2, warna teks sesuai dengan kebutuhan
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                        if (selectedMethod != null && selectedMethod.contains('Bank')) {
                          setState(() {
                            _selectedPaymentMethod = '2'; // Menetapkan ID 2 untuk metode pembayaran transfer bank
                            _selectedBank = selectedMethod; // Menetapkan nama bank yang dipilih
                          });
                          print('Selected Payment Method ID: $_selectedPaymentMethod');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: _selectedPaymentMethod != '1' // Memeriksa apakah ID bukan 1
                            ? Color(0xFFB50B0B) // Jika bukan 1, warna latar belakang menjadi merah
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod != '1' // Memeriksa apakah ID bukan 1
                            ? Colors.white // Jika bukan 1, warna teks menjadi putih
                            : Color(0xFFB50B0B),
                        side: const BorderSide(color: Color(0xFFB50B0B), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedBank.isNotEmpty ? _selectedBank : 'Transfer Bank'), // Menampilkan nama bank yang dipilih atau teks default
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      handlePayment();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(400, 60),
                      backgroundColor: Color(0xFFB50B0B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      'Buat Pesanan',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}