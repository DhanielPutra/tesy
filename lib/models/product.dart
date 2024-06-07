class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String detail;
  final String id_wish;
  final String id_penjual;
  final String id_user;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.detail,
    required this.id_wish,
    required this.id_penjual,
    required this.id_user,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['produk']?['nama_produk'] ?? '',
      imageUrl: json['produk']?['gambar'] ?? '',
      price: json['produk']?['harga'].toString() ?? '',
      detail: json['produk']?['detail'] ?? '',
      id_wish: json['id_wish'].toString(),
      id_penjual: json['produk']?['author']?['id'].toString() ?? '',
      id_user: json['pembeli']?['user_id'].toString() ?? '',
    );
  }
}
