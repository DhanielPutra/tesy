import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:marketplace/cart.dart';
import 'package:marketplace/daftarTransaksi.dart';
import 'package:marketplace/editProfile.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/pembayaran.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/view/Register/login.dart';
import 'package:marketplace/wishlist.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _userData;
  int _selectedIndex = 3;
  bool _isLoading = true; // Add this line

  @override
void initState() {
  super.initState();
  fetchUserProfile().then((userData) {
    setState(() {
      _userData = userData;
      _isLoading = false; // Update the loading state
    });
  }).catchError((error) {
    print('Error fetching user profile: $error');
    setState(() {
      _isLoading = false; // Update the loading state
    });
  });
}

// Fetch user profile data
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


  // Handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const homepage()));
      } else if (index == 1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Cart()));
      } else if (index == 2) {
        // Handle wishlist navigation
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Wishlist()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[200],
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
            body: Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: const Color(0xFFB50B0B),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: _userData != null && _userData!['gambar'] != null
                                  ? Image.network(
                                      _userData!['gambar'],
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.white,
                                      width: 50.0,
                                      height: 50.0,
                                    ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userData != null ? _userData!['name'] : 'Loading...',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  _userData != null ? _userData!['no_tlp'] : 'Loading...',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfile()));
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle Account Information onTap
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Account Information'),
                              Icon(Icons.settings_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DaftarTransaksi()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Daftar Transaksi'),
                              Icon(Icons.compare_arrows_rounded),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Pembayaran()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Pembayaran'),
                              Icon(Icons.payment_rounded),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle Logout onTap
                    },
                    child: Container(
                      height: 60,
                      color: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Logout'),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
