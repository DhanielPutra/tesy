 import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
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
        body: Container(
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
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(400, 60),
                    // Properti gaya tombol
                    backgroundColor:
                        Colors.white, // Warna latar belakang tombol
                    foregroundColor: Colors.red,
                    // Padding tombol
                    side: BorderSide(color: Colors.red, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      // Bentuk tepi tombol
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cash on Delivery'),
                      Icon(Icons.attach_money)
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(400, 60),
                    // Properti gaya tombol
                    backgroundColor:
                        Colors.white, // Warna latar belakang tombol
                    foregroundColor: Colors.red,
                    // Padding tombol
                    side: BorderSide(color: Colors.red, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      // Bentuk tepi tombol
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transfer Bank'),
                      Icon(Icons.account_balance_outlined)
                    ],
                  )),
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
    );
  }
}
