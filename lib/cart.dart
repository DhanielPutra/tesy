import 'package:flutter/material.dart';
import 'package:marketplace/checkout.dart';
import 'package:marketplace/homepage.dart';

import 'package:marketplace/profile.dart';

import 'package:marketplace/wishlist.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _selectedIndex = 1;
  List<Product> products = [
    Product(
      name: 'Logitech Gaming Mouse',
      imageUrl: 'assets/mouse.png',
      price: 'Rp. 1.300.000',
    ),
    Product(
      name: 'Wireless Keyboard',
      imageUrl: 'assets/ky.png',
      price: 'Rp. 800.000',
    ),
    Product(
      name: 'Gaming Headset',
      imageUrl: 'assets/hd.png',
      price: 'Rp. 1.500.000',
    ),
    Product(
      name: 'Gaming Headset',
      imageUrl: 'assets/hd.png',
      price: 'Rp. 1.500.000',
    ),
    // Tambahkan produk lainnya sesuai kebutuhan...
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => homepage()));
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Cart()));
      } else if (index == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Wishlist()));
      } else if (index == 3) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }

  void _removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'My Cart',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 100),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return buildProductCard(product, index);
                },
              ),
            ),
            Positioned(
              bottom: 0, // Sesuaikan posisi sesuai kebutuhan Anda
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                           const Text(
                              'Total Harga', // Gantilah dengan total harga yang sesuai
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                            20.0), // Atur radius top sesuai keinginan
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.all(15),
                                        height: 250.0,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width, // Atur tinggi modal bottom sheet sesuai keinginan
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close_sharp)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Detail pembayaran',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Total harga (3 produk)'),
                                                Text('Rp. 2.100.000'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Biaya Platform'),
                                                Text('Rp. 1.000'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Total Pembayaran',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('Rp. 2.101.000'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.keyboard_arrow_up))
                          ],
                        ),
                        Text('Rp. 2.100.000')
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Checkout()));
                      },
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB50B0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Set type to fixed

          backgroundColor: const Color.fromARGB(
              255, 193, 24, 24), // Set the background color here

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), // Add your new icon here

              label: 'Profile', // Add the label for the new icon
            ),
          ],

          currentIndex: _selectedIndex,

          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),

          unselectedItemColor: Color.fromARGB(207, 0, 0, 0),

          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget buildProductCard(Product product, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      height: 140,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit
                      .contain, // Mengatur agar gambar terlihat sepenuhnya
                ),
              ),
              SizedBox(width: 16.0), // Jarak antara gambar dan teks

              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      product.price,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFFB50B0B),
                ),
                onPressed: () {
                  _removeProduct(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final String price;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}
