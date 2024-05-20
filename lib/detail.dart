import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marketplace/checkout.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/user_services.dart'; // Import the method to get user ID and token

class Detail extends StatefulWidget {
  final dynamic item;
  final dynamic wishlistItem;

  const Detail({Key? key, required this.item, required this.wishlistItem})
      : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _selectedIndex = 0;
  bool isLiked = false;
  List<Product> products = [];
  List<Product> cartItems = [];
  

  @override
  void initState() {
    super.initState();
    checkWishlist(widget.item['id']); // Assuming 'id' is the product ID
  }

  Future<void> addToCart() async {
    final String url = 'https://barbeqshop.online/api/cart';

    int userId = await getUserId();
    String token = await getToken();

    final Map<String, dynamic> bodyData = {
      'user_id': userId.toString(), // Include the user ID in the request
      'gambar': widget.item['gambar'],
      'nama_produk': widget.item['nama_produk'],
      'harga': widget.item['harga'],
      'penjual_id': widget.item['user_id'],
      'produk_id': widget.item['id'].toString()
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: bodyData,
        headers: {
          'Authorization': 'Bearer $token'
        }, // Pass the token in the headers
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "item added to cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 23, 65, 162),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (response.statusCode == 409) {
        final responseBody = json.decode(response.body);
        final String message = responseBody['message'];
      } else {
        print(
            'Failed to add item to cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> addToWishlist() async {
    final String url = 'https://barbeqshop.online/api/wishlist';

    // Get the user ID and token from SharedPreferences
    int userId = await getUserId();
    String token = await getToken();

    final Map<String, dynamic> bodyData = {
      'id_wish': widget.item['id'].toString(),
      'user_id': userId.toString(), // Include the user ID in the request
      'gambar': widget.item['gambar'],
      'nama_product': widget.item['nama_produk'],
      'harga': widget.item['harga'],
      'penjual_id' : widget.item['user_id']
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: bodyData,
        headers: {
          'Authorization': 'Bearer $token'
        }, // Pass the token in the headers
      );

      if (response.statusCode == 200) {
        print('Item added to wishlist successfully.');
        setState(() {
          isLiked = true;
        });
      } else if (response.statusCode == 409) {
        final responseBody = json.decode(response.body);
        final String message = responseBody['message'];
        if (message == 'Item already exists in wishlist') {
          print('Item already exists in the wishlist.');
          // Optionally, you can handle this case differently
        } else {
          print(
              'Failed to add item to wishlist. Status code: ${response.statusCode}');
        }
      } else {
        print(
            'Failed to add item to wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      List<dynamic> wishlistItems = await fetchWishlistItems(productId);

      print('Wishlist items in removeFromWishlist: $wishlistItems');

      // Check if the wishlist item exists for the current product
      if (wishlistItems.isNotEmpty) {
        // Assuming the first item in the wishlist is the desired product
        int wishlistItemId = wishlistItems[0]['id'];
        await deleteFromWishlist(wishlistItemId);
      } else {
        print('Item not found in wishlist.');
      }
    } catch (e) {
      print('Error removing item from wishlist: $e');
    }
  }

  Future<void> deleteFromWishlist(int wishlistItemId) async {
    final String url = 'https://barbeqshop.online/api/wishlist/$wishlistItemId';

    try {
      final response = await http.delete(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLiked = false;
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

  // Update the fetchWishlistItems method to accept a product ID
  Future<List<dynamic>> fetchWishlistItems(int productId) async {
    try {
      String url =
          'https://barbeqshop.online/api/wishlist?product_id=$productId'; // Pass the product ID in the URL
      String token = await getToken();

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        dynamic responseData = json.decode(response.body);
        List<dynamic> wishlistItems = [];

        if (responseData is List<dynamic>) {
          // If the response data is already a list, use it directly
          wishlistItems = responseData;
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          // If the response data is an object containing a list, extract the list
          wishlistItems = responseData['data'];
        }

        print('Wishlist items: $wishlistItems');

        return wishlistItems;
      } else {
        print('Failed to fetch wishlist. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      return [];
    }
  }

// Update the checkWishlist method to use the fetched wishlist items
  Future<void> checkWishlist(int productId) async {
    try {
      List<dynamic> wishlistItems = await fetchWishlistItems(productId);

      print('Wishlist items in checkWishlist: $wishlistItems');

      // Check if the wishlist item exists for the current product
      if (wishlistItems.isNotEmpty) {
        // Assuming the first item in the wishlist is the desired product
        int wishlistItemId = wishlistItems[0]['id'];
        print('Wishlist item ID: $wishlistItemId');
        setState(() {
          isLiked = true;
        });
      } else {
        print('Wishlist is empty.');
        setState(() {
          isLiked = false;
        });
      }
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 206, 22, 22),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //gambar
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9EAEC),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              border: Border.all(
                                color: const Color(0xFFE9EAEC).withOpacity(
                                    1.0), // Warna border yang tersamarkan
                                width: 1.0, // Lebar border
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Image.network(
                                widget.item['gambar'],
                                // height: 350.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 30, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                widget.item['nama_produk'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isLiked) {
                                  removeFromWishlist(widget.item['id']);
                                } else {
                                  addToWishlist();
                                }
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 22,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '4.6',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                            ],
                          ),
                          Text(
                            'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(double.parse(widget.item['harga']))}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //warna produk
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Color',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //deskripsi barang
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi Barang',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.item['detail'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(
              color: Colors.black, // Warna border yang tersamarkan
              width: 1.5, // Lebar border
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //IB MESSAGE
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),

              //IB CART
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    addToCart();
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) => Cart()));
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  double itemPrice = double.parse(widget.item['harga']);
                  _sendDataTotalToCheckout(context, itemPrice);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB50B0B),
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Atur sesuai kebutuhan
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendDataTotalToCheckout(BuildContext context, double itemPrice) {
    double totalPayment = itemPrice;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Checkout(totalPayment: totalPayment, CartItems: widget.item,isFromCart: false,isFromWIsh: false,),
    ));
  }
}


