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

    // Mengubah cara_bayar ke format yang lebih mudah dipahami
    String getCaraBayar(String caraBayar) {
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
        elevation: 5,
        backgroundColor: Color.fromARGB(255, 193, 24, 24),
        title: Text(
          'Rincian Pesanan',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.fromLTRB(33, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama penerima
                        Text(
                          'Nama Penerima: ${widget.item['pembeli']['name']}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        // Nomor penerima
                        Text(
                          'Nomor Penerima: ${widget.item['pembeli']['no_tlp']}',
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
              SizedBox(height: 16),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
              ),
              SizedBox(height: 16),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(product['gambar']),
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
                            product['nama_produk'],
                            style: const TextStyle(
                              fontSize: 24,
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
              SizedBox(height: 16),
              Container(
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
                      getCaraBayar(widget.item['cara_bayar']),
                      style: TextStyle(fontSize: 18),
                    ),
                    // Menampilkan bukti transfer jika metode pembayaran adalah Transfer
                    if (widget.item['cara_bayar'] == '2' &&
                        widget.item['bukti_transfer'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Bukti Transfer:',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 193, 24, 24),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Image.network(
                            widget.item['bukti_transfer'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey[200],
                thickness: 5,
              ),
              SizedBox(height: 16),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Pengiriman',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 193, 24, 24),
                          fontWeight: FontWeight.bold),
                    ),
                    Text('ap?'),
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
