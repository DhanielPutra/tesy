class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String detail; // Add detail field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.detail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['nama_product'] ?? '',
      imageUrl: json['gambar'] ?? '',
      price: json['harga'].toString() ?? '',
      detail: json['detail'] ?? '', // Assign detail field
    );
  }

  static void removeWhere(bool Function(dynamic product) param0) {}
}