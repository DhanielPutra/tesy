import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/homepage.dart';
import 'package:marketplace/profile.dart';
import 'dart:convert';

import 'cart.dart';
import 'detail.dart'; // Import the Detail widget

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String detail; // Add detail field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.detail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['nama_product'] ?? '',
      imageUrl: json['gambar'] ?? '',
      price: json['harga'].toString() ?? '',
      detail: json['detail'] ?? '', // Assign detail field
    );
  }
}

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int _selectedIndex = 2;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://barbeqshop.online/api/wishlist'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          List<dynamic> productList = responseData['data'];
          setState(() {
            products =
                productList.map((data) => Product.fromJson(data)).toList();
          });
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
        // Wishlist page, do nothing as we are already on this page
      } else if (index == 3) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow button
        elevation: 5,
        backgroundColor: Color.fromARGB(255, 206, 22, 22),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      Detail(item: product))); // Pass product to Detail widget
            },
            child: Container(
              height: 200,
              width: double.infinity,
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.5),
                      width: 150,
                      height: double.infinity,
                      child: Image.network(
                        product.imageUrl,
                        width: 150,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 40),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Remove from wishlist functionality here
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              product.price,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 7, 0, 5),
                            child: SizedBox(
                              width: 200,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add functionality to order the product
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 208, 9, 9),
                                ),
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 193, 24, 24),
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
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(207, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
