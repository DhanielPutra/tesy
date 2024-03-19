// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marketplace/cart.dart';
import 'package:marketplace/detail.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/product.dart';
import 'package:marketplace/profile.dart';
// Import your product data

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int _selectedIndex = 2; // Default index for Wishlist
  // ignore: unused_field
  String _selectedText = 'All'; // Initially set to 'All'
  List<List<String>> filteredItems = List.from(items);
 

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
      } else if (index == 3) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }
   // Function to remove an item from the wishlist
  void _removeFromWishlist(int index) {
    setState(() {
      filteredItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 10, 0, 5),
                  child: SizedBox(
                    width: 100, // Set the width of the button
                    height: 30, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust border radius as needed
                        ),
                        backgroundColor: const Color.fromARGB(
                            255, 0, 0, 0), // Change the button color
                      ),
                      child: const Text(
                        'All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                  child: SizedBox(
                    width: 110, // Set the width of the button
                    height: 30, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust border radius as needed
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 212, 212, 212), // Change the button color
                      ),
                      child: const Text(
                        'Discount',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                  child: SizedBox(
                    width: 100, // Set the width of the button
                    height: 30, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust border radius as needed
                        ),
                        backgroundColor:const Color.fromARGB(
                            255, 132, 132, 132), // Change the button color
                      ),
                      child: const Text(
                        'Sold',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                final product = filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the detail page when the card is tapped
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Detail(item: product)));
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
                            child: Image.asset(
                              product[0],
                              width: 150,
                              height: double.infinity,
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
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 40),
                                        child: Text(
                                          product[1],
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
                                       _removeFromWishlist(index);
                                        // Add functionality to remove the item from the wishlist
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    product[2],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    product[3],
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 5),
                                  child: SizedBox(
                                    width: 200,
                                    height: 35,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add functionality to order the product
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
            // label

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
    );
  }
}
