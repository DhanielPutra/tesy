import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/cart.dart';
import 'package:marketplace/checkout.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final dynamic item;

  const Detail({Key? key, required this.item}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _selectedIndex = 0;
  bool isLiked = false;

  // Function to handle BottomNavigationBar index changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> addToCart() async {
    final String url = 'https://barbeqshop.online/api/cart';

    final Map<String, dynamic> bodyData = {
      'gambar': widget.item['gambar'],
      'nama_produk': widget.item['nama_produk'],
      'harga': widget.item['harga'],
    };

    try {
      final response = await http.post(Uri.parse(url), body: bodyData);

      if (response.statusCode == 200) {
        print('Item added to cart successfully.');
        // Optionally, you can navigate to the cart screen here
      } else {
        print(
            'Failed to add item to cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
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
                                    0.5), // Warna border yang tersamarkan
                                width: 2.0, // Lebar border
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
                            widget.item['harga'],
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

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Cart()));
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Checkout()));
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
}
