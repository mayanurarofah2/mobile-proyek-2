class Product {
  final int id;
  final String name;
  final int price;
  final String image;
  final String storeName; // 🔥 toko

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.storeName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: int.parse(json['price'].toString()),
      image: json['image'] ?? '',
      storeName: json['user']?['shop']?['store_name'] ?? 'Toko Tidak Diketahui',
    );
  }

  String get category {
  if (name.toLowerCase().contains("roti")) return "cookies";
  if (name.toLowerCase().contains("cake")) return "cake";
  if (name.toLowerCase().contains("cookies")) return "nastar";
  return "Lainnya";
}
}