import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/pesanan_berhasil.dart';
import 'package:marketplace/transfer.dart';
import 'package:marketplace/user_services.dart';

class Checkout extends StatefulWidget {
  final double totalPayment;
  final dynamic CartItems;
  final bool
      isFromCart; // Indicator to check if the data is from the cart or product details
  final bool isFromWIsh;

  const Checkout({
    Key? key,
    required this.totalPayment,
    required this.CartItems,
    required this.isFromCart,
    required this.isFromWIsh, // Add this parameter to indicate the data source
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController alamatController = TextEditingController();
  String _selectedPaymentMethod = ''; // To store the selected payment method
  String _selectedBank = ''; // To store the selected bank
  String _selectedPengiriman = ''; // To store the selected delivery option
  List<dynamic> _pengirimanOptions = []; // To store delivery options

  @override
  void initState() {
    super.initState();
    print('Received cart items: ${widget.CartItems}');
    print('Total Payment: ${widget.totalPayment}');
    _fetchPengirimanOptions();
  }

  Future<void> _fetchPengirimanOptions() async {
    final String url = 'https://barbeqshop.online/api/kurir';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            _pengirimanOptions = responseData['data'];
          });
        } else {
          print('Failed to retrieve data: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> addToPesanan() async {
    final String url = 'https://barbeqshop.online/api/pesanan';

    int userId = await getUserId();
    if (userId == null) {
      print('Error: User ID is null.');
      return;
    }

    String token = await getToken();
    if (token == null) {
      print('Error: Token is null.');
      return;
    }

    String caraBayar = '1'; // Default to Cash on Delivery
    if (_selectedPaymentMethod == '1') {
      caraBayar = '1'; // ID for Cash on Delivery
    } else if (_selectedPaymentMethod == '2') {
      if (_selectedBank == 'Bank BNI') {
        caraBayar = '2'; // ID for Bank BNI
      } else if (_selectedBank == 'Bank BCA') {
        caraBayar = '3'; // ID for Bank BCA
      } else if (_selectedBank == 'Bank Mandiri') {
        caraBayar = '4'; // ID for Bank Mandiri (assuming 4 for Mandiri)
      }
    }

  String produkId;
  String penjualId;
  if (widget.isFromCart) {
    // If the data is from the cart
    produkId = widget.CartItems[0]['produk_id'].toString();
    penjualId = widget.CartItems[0]['penjual_id'].toString();
  } else if (widget.isFromWIsh) {
    // If the data is from product details
    produkId = widget.CartItems[0]['id_wish'].toString();
    penjualId = widget.CartItems[0]['id_penjual'].toString();
  } else {
    produkId = widget.CartItems['id'].toString();
    penjualId = widget.CartItems['author']['id'].toString();
  }

    // Get the selected pengiriman option
    var selectedPengiriman = _pengirimanOptions.firstWhere(
      (option) => option['id'].toString() == _selectedPengiriman,
      orElse: () => null,
    );

    // Calculate the total price including the selected pengiriman option
    double hargaPengiriman = 0.0;
    String totalPrice = '0.00';
    if (selectedPengiriman != null) {
      hargaPengiriman = double.parse(selectedPengiriman['harga'].toString());
      totalPrice = (widget.totalPayment + hargaPengiriman).toStringAsFixed(2);
    }

  final Map<String, dynamic> bodyData = {
  'pembeli_id': userId.toString(),
  'alamat': alamatController.text,
  'produk_id': produkId,
  'user_id': penjualId,
  'bayar_id': caraBayar,
  'status_id': '1',
  'expedisi_id': _selectedPengiriman, // Include selected delivery option
  'harga': totalPrice // Calculate total price and format as string
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
        print('Response body: ${response.body}'); // Debugging the response body
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
      if (_selectedPengiriman.isNotEmpty) {
        var selectedPengiriman = _pengirimanOptions.firstWhere(
          (option) => option['id'].toString() == _selectedPengiriman,
          orElse: () => null,
        );

        if (selectedPengiriman != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Transfer(
                bankName: _selectedBank,
                alamatPengiriman: alamatController.text,
                cartItems: widget.CartItems,
                isFromCart: widget.isFromCart,
                isFromWish: widget.isFromWIsh,
                totalPayment: (widget.totalPayment +
                        double.parse(selectedPengiriman['harga'].toString()))
                    .toStringAsFixed(2),
                idKurir: selectedPengiriman['id'].toString(),
              ),
            ),
          );
        }
      } else {
        // Show a message if no delivery option is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Silakan pilih metode pengiriman terlebih dahulu.'),
          ),
        );
      }
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
                  'Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedPengiriman = await showMenu<String>(
                      context: context,
                      position: const RelativeRect.fromLTRB(5, 200, 0, 0),
                      items: _pengirimanOptions
                          .map<PopupMenuEntry<String>>((option) {
                        return PopupMenuItem<String>(
                          value: option['id'].toString(),
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
                                option['nama_kurir'],
                                style: TextStyle(
                                  color: _selectedPengiriman ==
                                          option['id'].toString()
                                      ? Color(0xFFB50B0B)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                    if (selectedPengiriman != null) {
                      setState(() {
                        _selectedPengiriman = selectedPengiriman;
                      });
                      print('Selected Pengiriman ID: $_selectedPengiriman');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 60),
                    backgroundColor: _selectedPengiriman.isNotEmpty
                        ? Color(0xFFB50B0B)
                        : Colors.white,
                    foregroundColor: _selectedPengiriman.isNotEmpty
                        ? Colors.white
                        : Color(0xFFB50B0B),
                    side: const BorderSide(color: Color(0xFFB50B0B), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedPengiriman.isNotEmpty
                          ? 'Pengiriman: ${_pengirimanOptions.firstWhere((option) => option['id'].toString() == _selectedPengiriman)['nama_kurir']}'
                          : 'Pilih Pengiriman'),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
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
                        backgroundColor: _selectedPaymentMethod == '1'
                            ? Color(0xFFB50B0B)
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod == '1'
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
                            selectedMethod.contains('Bank')) {
                          setState(() {
                            _selectedPaymentMethod =
                                '2'; // Menetapkan ID 2 untuk metode pembayaran transfer bank
                            _selectedBank =
                                selectedMethod; // Menetapkan nama bank yang dipilih
                          });
                          print(
                              'Selected Payment Method ID: $_selectedPaymentMethod');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: _selectedPaymentMethod != '1'
                            ? Color(0xFFB50B0B)
                            : Colors.white,
                        foregroundColor: _selectedPaymentMethod != '1'
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
                              : 'Transfer Bank'),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedPengiriman = await showMenu<String>(
                      context: context,
                      position: const RelativeRect.fromLTRB(5, 200, 0, 0),
                      items: _pengirimanOptions
                          .map<PopupMenuEntry<String>>((option) {
                        return PopupMenuItem<String>(
                          value: option['id'].toString(),
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
                                option['expedisi'],
                                style: TextStyle(
                                  color: _selectedPengiriman ==
                                          option['id'].toString()
                                      ? Color(0xFFB50B0B)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                    if (selectedPengiriman != null) {
                      setState(() {
                        _selectedPengiriman = selectedPengiriman;
                      });
                      print('Selected Pengiriman ID: $_selectedPengiriman');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 60),
                    backgroundColor: _selectedPengiriman.isNotEmpty
                        ? Color(0xFFB50B0B)
                        : Colors.white,
                    foregroundColor: _selectedPengiriman.isNotEmpty
                        ? Colors.white
                        : Color(0xFFB50B0B),
                    side: const BorderSide(color: Color(0xFFB50B0B), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedPengiriman.isNotEmpty
                          ? 'Pengiriman: ${_pengirimanOptions.firstWhere((option) => option['id'].toString() == _selectedPengiriman)['nama_kurir']}'
                          : 'Pilih Pengiriman'),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
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
