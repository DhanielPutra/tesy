import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketplace/checkout.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/profile.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/wishlist.dart';

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
    String token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token'
        }, // Pass the token in the headers
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(response.statusCode);
        if (responseData['status'] == true) {
          setState(() {
            cartItems = responseData['data'];
            // Initialize the isChecked field for each item
            for (var item in cartItems) {
              item['isChecked'] = false;
            }
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

  Future<int> fetchProductStock(int productId) async {
    final String url = 'https://barbeqshop.online/api/produk/$productId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody != null && responseBody['data'] != null && responseBody['data']['stock'] != null) {
          // Ensure the stock value is parsed as an integer
          return int.parse(responseBody['data']['stock'].toString());
        } else {
          print('Stock data is missing in the response.');
          return 0; // Default to 0 if stock data is missing
        }
      } else {
        print('Failed to fetch product stock. Status code: ${response.statusCode}');
        return 0; // Default to 0 if there is an error
      }
    } catch (e) {
      print('Error fetching product stock: $e');
      return 0;
    }
  }

  Future<void> deleteItem(String itemId) async {
    final String url = 'https://barbeqshop.online/api/cart/$itemId';

    try {
      final response = await http.delete(Uri.parse(url));

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
          backgroundColor: const Color.fromARGB(255, 163, 6, 6),
          title: const Text(
            'My Cart',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
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
                                      padding: const EdgeInsets.all(15),
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
                                            icon: const Icon(Icons.close_sharp),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Detail pembayaran',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total harga (${getSelectedItemsCount()} produk)',
                                              ),
                                              Text(
                                                'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(getTotalPrice())},00',
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Divider(),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total Pembayaran',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(getTotalPrice())},00',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.keyboard_arrow_up),
                            ),
                          ],
                        ),
                        Text(
                          'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(getTotalPrice())},00',
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: getTotalPrice() > 0
                          ? () {
                              _sendDataToCheckout(
                                  context); // Mengirim data ke halaman checkout
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getTotalPrice() > 0
                            ? const Color(0xFFB50B0B)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white,
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
          unselectedItemColor: const Color.fromARGB(207, 0, 0, 0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product, int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                  product['produk']['gambar'],
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                    Text(
                      product['produk']['nama_produk'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(double.parse(product['produk']['harga']))},00',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Checkbox(
                    value: product['isChecked'],
                    onChanged: (bool? value) {
                      setState(() {
                        // Uncheck all other items
                        for (var item in cartItems) {
                          item['isChecked'] = false;
                        }
                        // Check the selected item
                        product['isChecked'] = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFFB50B0B),
                    ),
                    onPressed: () {
                      deleteItem(product['id'].toString()); // Delete item by id
                    },
                  ),
                ],
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
      if (product['isChecked']) {
        total += double.parse(product['produk']['harga']);
      }
    }
    return total;
  }

  int getSelectedItemsCount() {
    int count = 0;
    for (Map<String, dynamic> product in cartItems) {
      if (product['isChecked']) {
        count++;
      }
    }
    return count;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Homepage(),
            transitionDuration: const Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      } else if (index == 1) {
        //////
      } else if (index == 2) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Wishlist(),
            transitionDuration: const Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      } else if (index == 3) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Profile(),
            transitionDuration: const Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      }
    });
  }

  void _sendDataToCheckout(BuildContext context) async {
    for (var item in cartItems.where((item) => item['isChecked'] == true)) {
      int productId = int.parse(item['produk_id']); // Parse the product ID as an integer
      int productStock = await fetchProductStock(productId); // Fetch product stock

      if (productStock > 0) {
        // If product stock exists, proceed to checkout
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Checkout(
            CartItems: cartItems.where((item) => item['isChecked'] == true).toList(),
            totalPayment: getTotalPrice(),
            isFromCart: true,
            isFromWIsh: false,
          ),
        ));
      } else {
        // If product stock does not exist, show a dialog or message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Out of Stock'),
              content: const Text('The selected item is out of stock.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        break; // Exit the loop
      }
    }
  }
}
