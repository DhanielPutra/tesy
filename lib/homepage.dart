import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:marketplace/bannerDetail.dart';
import 'package:marketplace/profile.dart';
import 'package:marketplace/search.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/wishlist.dart';
import 'cart.dart';
import 'detail.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Color _cardColor = Colors.white;
  String _selectedCategoryId = 'All';
  List<dynamic> filteredItems = [];
  List<dynamic> products = [];
  Map<String, dynamic>? _userData;
  List<dynamic> banners = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
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
    getBanners().then((data) {
      setState(() {
        banners = data;
      });
    }).catchError((error) {
      print('Error fetching banners: $error');
    });
  }

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

  Future<List<dynamic>> getBanners() async {
    try {
      final response =
          await http.get(Uri.parse('https://barbeqshop.online/api/banner'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
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
      final response = await http.get(Uri.parse(
          'https://barbeqshop.online/api/produkkat?kategori_id=$categoryId'));

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
        filteredItems = List.from(products);
      } else {
        fetchDataByCategory(categoryId).then((categoryProducts) {
          setState(() {
            filteredItems = categoryProducts;
          });
        }).catchError((error) {
          print('Error fetching category products: $error');
        });
      }
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

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(response.body);
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
      } else if (index == 1) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Cart(),
            transitionDuration: Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      } else if (index == 2) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Wishlist(),
            transitionDuration: Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      } else if (index == 3) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Profile(),
            transitionDuration: Duration(milliseconds: 0),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                      MaterialPageRoute(builder: (context) => SearchForm()));
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
                        ? const Image(image: AssetImage('assets/bbq.jpg'))
                        :  Lottie.asset ('assets/load.json', width: 40, height: 40),
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
            SizedBox(
              height: 180,
              child: banners.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BannerDetail(banner: banners[index])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                            child: Image.network(
                              banners[index]['gambar'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 10, 5, 10),
              child: FutureBuilder<List<dynamic>>(
                future: fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 50, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: Lottie.asset('assets/loading.json'),
                    );
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
                              text: category['nama_kategori'],
                              isSelected: _selectedCategoryId ==
                                  category['id'].toString(),
                              onTap: () => filterItemsByCategory(
                                  category['id'].toString()),
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
                          item: product,
                          wishlistItem: const Wishlist(),
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
