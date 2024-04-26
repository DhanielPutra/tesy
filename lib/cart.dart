import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final Map<String, dynamic> postData;

  const Cart({Key? key, this.postData = const {}}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _selectedIndex = 1;
  List<dynamic> cartItems = [];

  Future<void> fetchCartData() async {
    final String url = 'https://barbeqshop.online/api/cart';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            cartItems = responseData['data'];
          });
          print('Cart items: $cartItems');
        } else {
          print('Failed to fetch cart data: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch cart data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart data: $e');
    }
  }

  Future<void> deleteItem(String itemId) async {
    final String url = 'https://barbeqshop.online/api/cart/$itemId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Item deleted successfully.');
        // Refresh cart data after deletion
        fetchCartData();
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCartData();
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
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return buildProductCard(item, index);
                },
              ),
            ),
            Positioned(
              bottom: 0,
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
                              'Total Harga',
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
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.all(15),
                                      height: 250.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close_sharp),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Detail pembayaran',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total harga (${cartItems.length} produk)',
                                              ),
                                              Text(
                                                'Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Divider(),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Pembayaran',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.keyboard_arrow_up),
                            ),
                          ],
                        ),
                        Text(
                          'Rp. ${NumberFormat('#,##0').format(getTotalPrice())}',
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle checkout button pressed
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
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product, int index) {
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
                child: Image.network(
                  product['gambar'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['nama_produk'],
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
                      'Rp. ${NumberFormat('#,##0').format(double.parse(product['harga']))}',
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
                  deleteItem(product['id'].toString()); // Delete item by id
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
    for (Map<String, dynamic> product in cartItems) {
      total += double.parse(product['harga']);
    }
    return total;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on index
    });
  }
}
