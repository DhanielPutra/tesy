import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:marketplace/detail.dart';
import 'package:marketplace/product.dart';


class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({super.key});

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  List<List<String>> filteredItems =
      List.from(items); // Variabel untuk menyimpan daftar item yang difilter
  int _selectedIndex = 0; // Variabel untuk menyimpan indeks yang dipilih

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Transaksi'),
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back)), // Tombol kembali di AppBar
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bagian atas: tombol navigasi
            Indexed(
              index: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      ['Dalam Proses', 'Selesai'].asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String label = entry.value;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex =
                              index; // Mengatur indeks yang dipilih saat tombol diklik
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Container(
                              width: 100, // Lebar garis bawah
                              height: 2,
                              color: _selectedIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Bagian tengah: konten sesuai dengan indeks yang dipilih
            Indexed(
                index: 0,
                child: _selectedIndex == 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product =
                                filteredItems[index]; // Mengambil data item
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the detail page when the card is tapped
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Detail(item: [],))); // Navigasi ke halaman detail
                              },
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: const Color.fromARGB(
                                                255, 255, 255, 255)
                                            .withOpacity(0.5),
                                        width: 150,
                                        height: double.infinity,
                                        child: Image.asset(
                                          product[0], // Mengambil URL gambar
                                          width: 150,
                                          height: double.infinity,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, right: 40),
                                                    child: Text(
                                                      product[1], // Mengambil nama produk
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                product[
                                                    3], // Mengambil deskripsi produk
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
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                product[
                                                    2], // Mengambil harga produk
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(height: 15,),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 7, 0, 5),
                                              child: SizedBox(
                                                width: 200,
                                                height: 35,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Add functionality to order the product
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    backgroundColor:
                                                        Color.fromARGB(255, 208, 9, 9),
                                                  ),
                                                  child: const Text(
                                                    'Pesanan Diproses',
                                                    style: TextStyle(
                                                        color: Colors.white),
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
                      )
                    : Text('lagi')
                // Container(
                //     color: Colors.green,
                //     height: 200,
                //     child: Center(
                //       child: Text('Daftar Barang Selesai'),
                //     ),
                //   ),
                ),
          ],
        ),
      ),
    );
  }
}
