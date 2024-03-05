import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _selectedIndex = 0;

  List<Product> products = [
    Product(
      name: 'Logitech Gaming Mouse',
      imageUrl: 'assets/mouse.png',
      price: 'Rp. 1.300.000',
    ),
    Product(
      name: 'Wireless Keyboard',
      imageUrl: 'assets/ky.png',
      price: 'Rp. 800.000',
    ),
    Product(
      name: 'Gaming Headset',
      imageUrl: 'assets/hd.png',
      price: 'Rp. 1.500.000',
    ),
    Product(
      name: 'Gaming Headset',
      imageUrl: 'assets/hd.png',
      price: 'Rp. 1.500.000',
    ),

    // Tambahkan produk lainnya sesuai kebutuhan...
  ];

  // Fungsi untuk menangani perubahan indeks BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
            size: 30.0,
          ),
          title: Text(
            'My Total',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            Product product = products[index];
            return buildProductCard(product);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFB50B0B),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Total',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: Container(
          height: 55,
          width: 260,
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  // Konten Bottom Sheet
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan Pembelian',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        // Tambahkan informasi ringkasan pembelian atau formulir pembayaran di sini
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Logika yang akan dijalankan ketika tombol pembayaran ditekan
                            Navigator.pop(context); // Menutup Bottom Sheet
                          },
                          child: Text('Pilih Metode Pembayaran'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(
              'Checkout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB50B0B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      height: 140,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset(
                product.imageUrl,
                width: 95,
                height: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      product.price,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFFB50B0B),
                ),
                onPressed: () {
                  print('Delete Pressed!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final String price;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}
