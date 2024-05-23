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
  final bool isFromCart; // Indicator to check if the data is from the cart or product details
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
  double _hargaPengiriman = 0.0; // To store the delivery price

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

    // Calculate the total price including the selected pengiriman option
    String totalPrice = (widget.totalPayment + _hargaPengiriman).toStringAsFixed(2);

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
                      position: const RelativeRect.fromLTRB(5, 350, 0, 0),
                      items: _pengirimanOptions
                          .asMap()
                          .entries
                          .map<PopupMenuEntry<String>>((entry) {
                        int index = entry.key;
                        var option = entry.value;

                        // Color backgroundColor;
                        // if (index % 2 == 0) {
                        //   backgroundColor = Colors.blue[100]!;
                        // } else {
                        //   backgroundColor = Colors.green[100]!;
                        // }

                        return PopupMenuItem<String>(
                          value: option['id'].toString(),
                          height: 50,
                          child: Container(
                            // color: backgroundColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option['expedisi'],
                                    style: TextStyle(
                                      color: _selectedPengiriman ==
                                              option['id'].toString()
                                          ? Color(0xFFB50B0B)
                                          : null,
                                      fontWeight: _selectedPengiriman ==
                                              option['id'].toString()
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rp. ${option['harga']}',
                                  style: TextStyle(
                                    color: _selectedPengiriman ==
                                            option['id'].toString()
                                        ? Color(0xFFB50B0B)
                                        : null,
                                    fontWeight: _selectedPengiriman ==
                                            option['id'].toString()
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );

                    if (selectedPengiriman != null) {
                      final selectedOption = _pengirimanOptions.firstWhere(
                        (option) => option['id'].toString() == selectedPengiriman,
                        orElse: () => null,
                      );

                      if (selectedOption != null) {
                        setState(() {
                          _selectedPengiriman = selectedPengiriman;
                          _hargaPengiriman =
                              double.parse(selectedOption['harga'].toString());
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFB50B0B),
                    minimumSize: Size(200, 50),
                  ),
                  child: const Text(
                    'Pilih Metode Pengiriman',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                if (_selectedPengiriman.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pengiriman Terpilih:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _pengirimanOptions.firstWhere(
                          (option) =>
                              option['id'].toString() == _selectedPengiriman,
                          orElse: () => {'expedisi': 'Unknown'},
                        )['expedisi'],
                      ),
                      Text(
                        'Harga Pengiriman: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(_hargaPengiriman)}',
                      ),
                    ],
                  ),
                SizedBox(height: 25),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                ListTile(
                  title: Text('Cash on Delivery'),
                  leading: Radio<String>(
                    value: '1',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                        _selectedBank = ''; // Reset the selected bank if COD is selected
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Bank Transfer'),
                  leading: Radio<String>(
                    value: '2',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
                if (_selectedPaymentMethod == '2')
                  Column(
                    children: [
                      ListTile(
                        title: Text('Bank BNI'),
                        leading: Radio<String>(
                          value: 'Bank BNI',
                          groupValue: _selectedBank,
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Bank BCA'),
                        leading: Radio<String>(
                          value: 'Bank BCA',
                          groupValue: _selectedBank,
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Bank Mandiri'),
                        leading: Radio<String>(
                          value: 'Bank Mandiri',
                          groupValue: _selectedBank,
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 1.0,
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp. ')
                      .format(widget.totalPayment + _hargaPengiriman),
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: handlePayment,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFB50B0B),
                      minimumSize: Size(200, 50),
                    ),
                    child: const Text(
                      'Lanjutkan Pembayaran',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
