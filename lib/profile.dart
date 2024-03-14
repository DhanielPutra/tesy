import 'package:flutter/material.dart';
import 'package:marketplace/cart.dart';
import 'package:marketplace/daftarTransaksi.dart';
import 'package:marketplace/editProfile.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/pembayaran.dart';
import 'package:marketplace/view/Register/login.dart';
import 'package:marketplace/view/Register/register.dart';
import 'package:marketplace/wishlist.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;

  // Fungsi untuk menangani perubahan indeks BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const homepage()));
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Cart()));
      } else if (index == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Wishlist()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Set type to fixed
          backgroundColor: const Color.fromARGB(
              255, 193, 24, 24), // Set the background color here
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
              icon: Icon(Icons.person_rounded), // Add your new icon here
              label: 'Profile', // Add the label for the new icon
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
                          child: Image.asset(
                            'assets/bbq.jpg', // Ganti dengan nama file gambar Anda
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit
                                .cover, // Atur sesuai kebutuhan tata letak gambar
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zahra Meidira',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '083839310156',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile()));
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ))
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
                        // Navigasi atau tindakan yang diinginkan saat bagian ini dipencet
                        print('Account Information pressed');
                        // Tambahkan navigasi atau tindakan sesuai kebutuhan Anda
                        // Navigator.of(context)
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          MaterialPageRoute(builder: (context) => DaftarTransaksi()),
                        );
                        // Navigasi atau tindakan yang diinginkan saat bagian ini dipencet
                        print('Daftar Transaksi pressed');
                        // Tambahkan navigasi atau tindakan sesuai kebutuhan Anda
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        // Navigasi atau tindakan yang diinginkan saat bagian ini dipencet
                        print('Pembayaran pressed');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Pembayaran()));
                        // Tambahkan navigasi atau tindakan sesuai kebutuhan Anda
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                  // Tindakan logout, misalnya membersihkan data sesi atau menghapus token
                  print('Logout pressed');
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => login()));

                  // Navigasi kembali ke halaman login
                },
                child: Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logout'),
                      Icon(Icons.logout),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
