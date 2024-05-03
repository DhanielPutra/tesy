 import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
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
                          _selectedPaymentMethod = 'Cash on Delivery';
                          _selectedBank =
                              ''; // Reset selected bank when cash on delivery is chosen
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor:
                            _selectedPaymentMethod == 'Cash on Delivery'
                                ? Color(0xFFB50B0B)
                                : Colors.white,
                        foregroundColor:
                            _selectedPaymentMethod == 'Cash on Delivery'
                                ? Colors.white
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
                              value: 'Bank BNI',
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
                                      color:
                                          _selectedPaymentMethod == 'Bank BNI'
                                              ? Color(0xFFB50B0B)
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Bank BCA',
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
                                      color:
                                          _selectedPaymentMethod == 'Bank BCA'
                                              ? Color.fromARGB(255, 19, 65, 204)
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Bank Mandiri',
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
                                              'Bank Mandiri'
                                          ? const Color.fromARGB(
                                              255, 15, 3, 255)
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                        if (selectedMethod != null &&
                            selectedMethod.startsWith('Bank')) {
                          setState(() {
                            _selectedPaymentMethod = selectedMethod;
                            _selectedBank =
                                selectedMethod; // Set selected bank to the chosen bank name
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor:
                            _selectedPaymentMethod != 'Cash on Delivery'
                                ? Color(0xFFB50B0B)
                                : Colors.white,
                        foregroundColor:
                            _selectedPaymentMethod != 'Cash on Delivery'
                                ? Colors.white
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
                              : 'Transfer Bank'), // Display selected bank name or default text
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 50,
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
