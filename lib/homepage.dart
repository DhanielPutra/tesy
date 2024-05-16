import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marketplace/profile.dart';
import 'package:marketplace/search.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/wishlist.dart';
import 'cart.dart';
import 'detail.dart'; // Import the detail page

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Color _cardColor = Colors.white;
  String _selectedCategoryId = 'All';
  List<dynamic> filteredItems = [];
  List<dynamic> products = [];
  Map<String, dynamic>? _userData;

  Future<List<dynamic>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://barbeqshop.online/api/produk'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('https://barbeqshop.online/api/kategori'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchDataByCategory(String categoryId) async {
    try {
      final response = await http.get(
          Uri.parse('https://barbeqshop.online/api/produkkat?kategori_id=$categoryId'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  void filterItemsByCategory(String categoryId) {
    print('Selected category ID: $categoryId');
    setState(() {
      _selectedCategoryId = categoryId;
      if (categoryId == 'All') {
        // Show all products when 'All' is selected
        filteredItems = List.from(products);
      } else {
        // Fetch products by category ID
        fetchDataByCategory(categoryId).then((categoryProducts) {
          setState(() {
            filteredItems = categoryProducts;
          });
        }).catchError((error) {
          print('Error fetching category products: $error');
        });
      }
      print(filteredItems);
    });
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    String token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('https://barbeqshop.online/api/profile'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          return data['data']['user'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching user profile: $error');
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Do nothing, we're already on the homepage
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Cart()));
      } else if (index == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Wishlist()));
      } else if (index == 3) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Profile()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile().then((userData) {
      setState(() {
        _userData = userData;
      });
    }).catchError((error) {
      print('Error fetching user profile: $error');
    });
    fetchData().then((data) {
      setState(() {
        products = data;
        filteredItems = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>  SearchForm()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 235, 226, 226),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
              child: ClipOval(
                child: _userData != null && _userData!['gambar'] != null
                    ? Image.network(
                        _userData!['gambar'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : _userData != null
                        ? Image(image: AssetImage('assets/bbq.jpg'))
                        : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // Handle the tap event for the image button
                print('ImageButton tapped');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                child: Image.asset(
                  'assets/disc.jpg',
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 10, 5, 10),
              child: FutureBuilder<List<dynamic>>(
                future: fetchCategories(), // Fetch the categories
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Text('No categories found');
                    }
                    List<dynamic> categories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ClickableText(
                            text: 'All',
                            isSelected: _selectedCategoryId == 'All',
                            onTap: () => filterItemsByCategory('All'),
                          ),
                          ...categories.map<Widget>((category) {
                            return ClickableText(
                              text: category['nama_kategori'], // Display category name
                              isSelected: _selectedCategoryId == category['id'].toString(),
                              onTap: () => filterItemsByCategory(category['id'].toString()),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 8,
                children: filteredItems.map<Widget>((product) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Detail(
                          item: product, // Pass the product item data
                          wishlistItem: const Wishlist(), // Pass the wishlist item data
                        ),
                      ));
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: Card(
                        color: _cardColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                product['gambar'],
                                height: 150,
                                width: double.infinity,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  product['nama_produk'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(double.parse(product['harga']))}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 193, 24, 24),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
}

class ClickableText extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ClickableText({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _ClickableTextState createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(ClickableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        _isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isSelected
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 149, 149, 149),
            fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
