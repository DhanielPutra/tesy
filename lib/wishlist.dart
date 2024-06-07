import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marketplace/cart.dart';
import 'package:marketplace/checkout.dart';
import 'package:marketplace/detail.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/product.dart';
import 'package:marketplace/profile.dart';
import 'package:marketplace/user_services.dart';

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
    fetchWishlistData();
  }

  Future<void> fetchWishlistData() async {
  final String url = 'https://barbeqshop.online/api/wishlist';

  // Get the user ID and token from SharedPreferences
  String token = await getToken(); // Assuming getToken() retrieves token from SharedPreferences

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // Parse response body
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        // Data retrieved successfully
        print(responseData);
        List<dynamic> wishlistData = responseData['data'];
        setState(() {
          // Update products list with fetched data
          products = wishlistData.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        print('Failed to fetch wishlist data: ${responseData['message']}');
      }
    } else {
      print('Failed to fetch wishlist data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching wishlist data: $e');
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


  
  Future<void> deleteFromWishlist(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://barbeqshop.online/api/wishlist/$productId'),
      );

      if (response.statusCode == 200) {
        // Item deleted successfully, update the UI
        setState(() {
          products.removeWhere((product) => product.id == productId);
        });
        print('Item deleted from wishlist successfully.');
      } else {
        print(
            'Failed to delete item from wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item from wishlist: $e');
    }
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
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Cart(),
            transitionDuration: const Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      } else if (index == 2) {
        // Wishlist page, do nothing as we are already on this page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow button
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 163, 6, 6),
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
                                    products[index].name,
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
                                  deleteFromWishlist(product.id);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              product.detail,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              'Rp.${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(double.parse(product.price))},00',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 7, 0, 5),
                            child: SizedBox(
                              width: 200,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  _sendDataTotalToCheckout(context, product);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 174, 5, 5),
                                ),
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 15),
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
        unselectedItemColor: const Color.fromARGB(207, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }

 void _sendDataTotalToCheckout(BuildContext context, Product selectedProduct) async {
  try {
    // Fetch product stock
    int productStock = await fetchProductStock(int.parse(selectedProduct.id_wish));

    if (productStock > 0) {
      // If product stock exists, proceed to checkout

      // Calculate total payment
      double totalPayment = double.parse(selectedProduct.price);

      // Convert selected product into a map
      Map<String, dynamic> selectedProductMap = {
        'id': selectedProduct.id,
        'id_wish': selectedProduct.id_wish,
        'nama_product': selectedProduct.name,
        'detail': selectedProduct.detail,
        'harga': selectedProduct.price,
        'gambar': selectedProduct.imageUrl,
        'id_penjual': selectedProduct.id_penjual,
        "user_id": selectedProduct.id_user
      };

      // Pass the selected product map as a list
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Checkout(
          totalPayment: totalPayment,
          CartItems: [
            selectedProductMap
          ], // Pass the selected product map as a list
          isFromCart: false,
          isFromWIsh: true,
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
    }
  } catch (e) {
    print('Error fetching product stock: $e');
  }
}

}
