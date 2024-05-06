 import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController alamatController = TextEditingController();
  String _selectedPaymentMethod = ''; // To store the selected payment method
  String _selectedBank = ''; // To store the selected bank

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
                  // onChanged: (newValue) {
                  //   setState(() {
                  //     textValue =
                  //         newValue; // Update nilai teks saat ada perubahan
                  //   });
                  // },
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
                          _selectedPaymentMethod =
                              '1'; // Menetapkan ID 1 untuk Cash on Delivery
                          _selectedBank =
                              ''; // Reset selected bank when cash on delivery is chosen
                        });
                        print(
                            'Selected Payment Method ID: $_selectedPaymentMethod');
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: _selectedPaymentMethod ==
                                '1' // Memeriksa apakah ID adalah 1
                            ? Color(
                                0xFFB50B0B) // Jika ID adalah 1, warna latar belakang menjadi merah
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod ==
                                '1' // Memeriksa apakah ID adalah 1
                            ? Colors
                                .white // Jika ID adalah 1, warna teks menjadi putih
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
                              value:
                                  'Bank BNI', // Menetapkan ID 2 untuk Bank BNI
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
                                      color: _selectedPaymentMethod ==
                                              'Bank BNI' // Memeriksa apakah ID adalah 2
                                          ? Color(
                                              0xFFB50B0B) // Jika ID adalah 2, warna teks menjadi merah
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value:
                                  'Bank BCA', // Menetapkan ID 2 untuk Bank BCA
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
                                      color: _selectedPaymentMethod ==
                                              'Bank BCA' // Memeriksa apakah ID adalah 2
                                          ? Color.fromARGB(255, 19, 65,
                                              204) // Jika ID adalah 2, warna teks sesuai dengan kebutuhan
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value:
                                  'Bank Mandiri', // Menetapkan ID 2 untuk Bank Mandiri
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
                                      color: _selectedPaymentMethod ==
                                              'Bank Mandiri' // Memeriksa apakah ID adalah 2
                                          ? const Color.fromARGB(255, 15, 3,
                                              255) // Jika ID adalah 2, warna teks sesuai dengan kebutuhan
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                        if (selectedMethod != null &&
                            selectedMethod.contains('Bank')) {
                          setState(() {
                            _selectedPaymentMethod = '2'; // Menetapkan ID 2 untuk metode pembayaran transfer bank
                            _selectedBank =
                                selectedMethod; // Menetapkan nama bank yang dipilih
                          });
                          print('Selected Payment Method ID: $_selectedPaymentMethod');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: _selectedPaymentMethod !=
                                '1' // Memeriksa apakah ID bukan 1
                            ? Color(
                                0xFFB50B0B) // Jika bukan 1, warna latar belakang menjadi merah
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod !=
                                '1' // Memeriksa apakah ID bukan 1
                            ? Colors
                                .white // Jika bukan 1, warna teks menjadi putih
                            : Color(0xFFB50B0B),
                        side: const BorderSide(
                            color: Color(0xFFB50B0B), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedBank.isNotEmpty
                              ? _selectedBank
                              : 'Transfer Bank'), // Menampilkan nama bank yang dipilih atau teks default
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(400, 60),
                        // Properti gaya tombol
                        backgroundColor:
                            Color(0xFFB50B0B), // Warna latar belakang tombol
                        foregroundColor: Color(0xFFB50B0B),
                        // Padding tombol

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          // Bentuk tepi tombol
                        ),
                      ),
                      child: Text(
                        'Buat Pesanan',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
