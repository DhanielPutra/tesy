import 'package:flutter/material.dart';

class RincianPesanan extends StatefulWidget {
  const RincianPesanan({Key? key}) : super(key: key);

  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  final List<List<String>> items = [
    [
      "assets/ky.png",
      "Logitech G903 HERO",
      "Tidak ada kerusakan",
      "Rp.1.102.000"
    ],
    ["assets/bbq.jpg", "Product 6", "Tidak ada kerusakan", "Rp.100.000"],
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rincian Pesanan'),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.grey[350],
                  thickness: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            Text('Zahra Meidira'),
                            Text('08215683425'),
                            Text('Yongsan Trade Center, Bandung, Jawa Barat'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                  thickness: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      return OrderItem(
                        imageUrl: items[index][0],
                        title: items[index][1],
                        description: items[index][2],
                        price: items[index][3],
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Total Pesanan'), Text('Rp.1.442.000')],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey[350],
                  thickness: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Metode Pembayaran'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('COD (Bayar di Tempat)')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;

  const OrderItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 110.0,
        height: 110.0,
        child: Image.asset(imageUrl),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(price),
    );
  }
}
