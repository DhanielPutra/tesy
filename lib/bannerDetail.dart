import 'package:flutter/material.dart';

class BannerDetail extends StatelessWidget {
  final Map<String, dynamic> banner;

  const BannerDetail({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          banner['title'] ?? 'Banner Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 163, 6, 6),
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            banner['gambar'] != null
                ? Image.network(
                    banner['gambar'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                banner['detail'] ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
