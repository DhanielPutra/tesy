import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/pesanan_berhasil.dart';
import 'package:marketplace/user_services.dart';

class Transfer extends StatefulWidget {
  final String bankName;
  final String alamatPengiriman;
  final dynamic cartItems;
  final dynamic isFromCart;
  final dynamic isFromWish;
  final String totalPayment;
  final String idKurir;

  const Transfer({
    Key? key,
    required this.bankName,
    required this.alamatPengiriman,
    required this.cartItems,
    required this.isFromCart,
    required this.isFromWish,
    required this.totalPayment,
    required this.idKurir,
  }) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Received data on Transfer page:');
    print('Bank Name: ${widget.bankName}');
    print('Alamat Pengiriman: ${widget.alamatPengiriman}');
    print('Cart Items: ${widget.cartItems}');
    print('Is From Cart: ${widget.isFromCart}');
    print('Is From Cart: ${widget.totalPayment}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Bank'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No Rekening Transfer'),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              shadowColor: Colors.black,
              color: Colors.red[600],
              child: SizedBox(
                width: 500,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.bankName,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ' : ${getBankAccount(widget.bankName)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Upload Bukti Transfer'),
            SizedBox(height: 10),
            _buildImagePicker(),
            SizedBox(height: 20),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      color: Colors.red[600],
      child: SizedBox(
        width: 500,
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.white),
                  )
                : Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick Image from Gallery"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _createOrder();
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(200, 50),
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          'Selesai',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> _createOrder() async {
    final String url = 'https://barbeqshop.online/api/pesanan';

    int userId = await getUserId();
    String token = await getToken();

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    String produkId;
    String penjualId;
    if (widget.isFromCart) {
      // If the data is from the cart
      produkId = widget.cartItems[0]['produk_id'].toString();
      penjualId = widget.cartItems[0]['penjual_id'].toString();
    } else if(widget.isFromWish){
    // If the data is from product details
    produkId = widget.cartItems[0]['id_wish'].toString();
    penjualId = widget.cartItems[0]['id_penjual'].toString();
    }else {
      // If the data is from product details
      produkId = widget.cartItems['id'].toString();
      penjualId = widget.cartItems['author']['id'].toString();
    }
    // Add other data fields
    request.fields['pembeli_id'] = userId.toString();
    request.fields['alamat'] = widget.alamatPengiriman;
    request.fields['produk_id'] = produkId.toString();
    request.fields['user_id'] = penjualId.toString(); // Access the first item in the list and get the penjual_id
    request.fields['cara_bayar'] = '2'; // ID for Bank Transfer
    request.fields['status_id'] = '1';
    request.fields['harga'] = widget.totalPayment;
    request.fields['id_kurir'] = widget.idKurir;

    // Add the image file
    if (_image != null) {
      var pic =
          await http.MultipartFile.fromPath("bukti_transfer", _image!.path);
      request.files.add(pic);
    }

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Check the response status
      if (streamedResponse.statusCode == 200) {
        print('Order created successfully.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PesananBerhasil()),
        );
      } else {
        print(
            'Failed to create order. Status code: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  String getBankAccount(String bankName) {
    final Map<String, String> bankAccounts = {
      'Bank BNI': '217-04057-68',
      'Bank BCA': '123-45678-90',
      'Bank Mandiri': '098-76543-21'
    };
    return bankAccounts[bankName] ?? 'No Account';
  }
}
