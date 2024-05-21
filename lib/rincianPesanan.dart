import 'package:flutter/material.dart';

class RincianPesanan extends StatefulWidget {
  final dynamic item;
  const RincianPesanan({Key? key, required this.item}) : super(key: key);

  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  @override
  Widget build(BuildContext context) {
    final product = widget.item['produk'];
    final alamat = widget.item['alamat'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Rincian Pesanan'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 8),
                    Text('Alamat Pengiriman'),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.fromLTRB(33, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama penerima
                      Text('Nama Penerima: ${widget.item['pembeli']['name']}'),
                      // Nomor penerima
                      Text(
                          'Nomor Penerima: ${widget.item['pembeli']['no_tlp']}'),

                      Text('Alamat Pengiriman: $alamat'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(
              color: Colors.grey[350],
              thickness: 10,
            ),
            SizedBox(height: 16),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(product['gambar']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['nama_produk'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: Rp. ${product['harga']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Detail: ${product['detail']}',
                        style: const TextStyle(fontSize: 16),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Status: ${widget.item['status_id']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
