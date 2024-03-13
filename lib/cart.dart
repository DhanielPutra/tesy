import 'package:flutter/material.dart';
import 'package:marketplace/checkout.dart';
import 'package:marketplace/homepage.dart';

import 'package:marketplace/profile.dart';

import 'package:marketplace/wishlist.dart';
import 'package:intl/intl.dart';

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
      price: 1300000,
    ),
    Product(
      name: 'Wireless Keyboard',
      imageUrl: 'assets/ky.png',
      price: 800000,
    ),
    Product(
      name: 'Gaming Headset',
      imageUrl: 'assets/hd.png',
      price: 1500000,
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
                            Text(
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
                                    shape: RoundedRectangleBorder(
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
                                                Text(
                                                    'Total harga (${products.length} produk)'),
                                                Text('Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',),
                                              ],
                                            ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment
                                            //           .spaceBetween,
                                            //   children: [
                                            //     Text('Biaya Platform'),
                                            //     Text('Rp. 1.000'),
                                            //   ],
                                            // ),
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
                                                Text(
                                                    'Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',),
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
                        Text('Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',)
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
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFB50B0B),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: 'Profil',
            ),
          ],
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
                      'Rp. ${NumberFormat('#,##0').format(product.price)}',
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

  double getTotalPrice() {
    double total = 0.0;
    for (Product product in products) {
      total += product.price;
    }
    return total;
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}
