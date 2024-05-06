import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';
import 'checkout.dart';

class Detail extends StatefulWidget {
  final dynamic item;

  const Detail({Key? key, required this.item}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _selectedIndex = 0;
  bool isLiked = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> checkWishlist() async {
    try {
      var response = await http.get(
        Uri.parse('https://barbeqshop.online/api/wishlist'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Ensure data is a Map
        if (data is Map) {
          // Check if the product ID exists in the wishlist
          if (data.containsKey(widget.item['id'])) {
            return true; // Product is in the wishlist
          }
        } else {
          print('Invalid data format: $data');
        }
      } else {
        print('Failed to fetch wishlist data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking wishlist: $e');
    }
    return false; // Return false if there's an error or the product is not in the wishlist
  }

Future<void> toggleWishlist() async {
  try {
    // Check if the product is already in the wishlist
    bool isInWishlist = await checkWishlist();
    if (isInWishlist) {
      // If the product is already in the wishlist, remove it
      var response = await http.post(
        Uri.parse('https://barbeqshop.online/api/wishlist/${widget.item['id'].toString()}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLiked = false;
        });
        print('Produk berhasil dihapus dari wishlist');
      } else {
        print('Gagal menghapus produk dari wishlist');
      }
    } else {
      // If the product is not in the wishlist, add it
      var productData = {
       "id_produk" : widget.item['id'].toString(),
        "nama_product": widget.item['nama_produk'],
        "harga": widget.item['harga'],
        "gambar": widget.item['gambar'],
        "detail": widget.item['detail'],
      };

      var response = await http.post(
        Uri.parse('https://barbeqshop.online/api/wishlist'),
        body: productData,
      );

      if (response.statusCode == 200) {
        setState(() {
          isLiked = true;
        });
        print('Produk berhasil ditambahkan ke wishlist');
      } else {
        print('Gagal menambahkan produk ke wishlist');
        
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}



  @override
  void initState() {
    super.initState();
    // Check the wishlist status when the widget is initialized
    checkWishlist().then((isInWishlist) {
      setState(() {
        isLiked = isInWishlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE9EAEC),
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
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9EAEC),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              border: Border.all(
                                color: const Color(0xFFE9EAEC).withOpacity(0.5),
                                width: 2.0,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                              
                              child: Image.network(
                                widget.item['gambar'],
                                height: 250.0,
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
                                isLiked = !isLiked;
                              });
                              toggleWishlist();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.item['harga'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi Barang',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.item['detail'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Checkout()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB50B0B),
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
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
    );
  }
}
