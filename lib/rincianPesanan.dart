import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RincianPesanan extends StatefulWidget {
  final dynamic item;
  const RincianPesanan({Key? key, required this.item}) : super(key: key);

  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  @override
  Widget build(BuildContext context) {
    final product = widget.item['produk'] ?? {};
    final alamat = widget.item['alamat'] ?? '';
    final pembeli = widget.item['pembeli'] ?? {};

    // Mengubah cara_bayar ke format yang lebih mudah dipahami
    String getCaraBayar(String? caraBayar) {
      switch (caraBayar) {
        case '1':
          return 'Cash on Delivery';
        case '2':
          return 'Transfer';
        default:
          return 'Metode Pembayaran Tidak Dikenal';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rincian Pesanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 193, 24, 24),
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color.fromARGB(255, 193, 24, 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Alamat Pengiriman',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 193, 24, 24),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Penerima: ${pembeli['name'] ?? 'Tidak ada data'}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Nomor Penerima: ${pembeli['no_tlp'] ?? 'Tidak ada data'}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Alamat Pengiriman: $alamat',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
              ),
              const SizedBox(height: 16),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(product['gambar'] ??
                              'https://via.placeholder.com/100'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['nama_produk'] ?? 'Tidak ada data',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: Rp. ${product['harga'] ?? 'Tidak ada data'}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Detail: ${product['detail'] ?? 'Tidak ada data'}',
                            style: const TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          // Text(
                          //   'Status: ${widget.item['status_id'] ?? 'Tidak ada data'}',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 193, 24, 24),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      getCaraBayar(widget.item['bayar_id']?.toString()),
                      style: TextStyle(fontSize: 18),
                    ),
                    // Menampilkan bukti transfer jika metode pembayaran adalah Transfer
                    if (widget.item['bayar_id']?.toString() == '2' &&
                        widget.item['gambar'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Bukti Transfer:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Image.network(
                            widget.item['gambar'] ?? '',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran :',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 193, 24, 24),
                      ),
                    ),
                    Text(
                      widget.item['harga'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
