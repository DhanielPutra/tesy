class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String detail; // Add detail field
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
      name: json['nama_product'] ?? '',
      imageUrl: json['gambar'] ?? '',
      price: json['harga'].toString() ?? '',
      detail: json['detail'] ?? '', // Assign detail field
      id_wish: json['id_wish'].toString() ?? '',
      id_penjual: json['penjual_id'].toString() ?? '',
      id_user: json['user_id'].toString() ?? '',
    );
  }




  

  static void removeWhere(bool Function(dynamic product) param0) {}
}