class Shop {
  final int id;
  final int userId; // 🔥 tambah
  final String name;
  final String address;
  final String email;
  final String ownerName;
  final String? photo; 

  Shop({
    required this.id,
    required this.userId, // 🔥 tambah
    required this.name,
    required this.address,
    required this.email,
    required this.ownerName,
    this.photo,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      userId: json['user_id'], // 🔥 tambah
      name: json['store_name'],
      address: json['address'],
      email: json['user']?['email'] ?? '-',
      ownerName: json['user']?['name'] ?? '-',
      photo: json['photo'],
    );
  }
}