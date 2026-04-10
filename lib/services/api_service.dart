import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
static const String ip = "192.168.0.33";
static const String baseUrl = "http://$ip:8000/api";
static const String imageUrl = "http://$ip:8000/products";
static const String uploadUrl = "http://$ip:8000/uploads";

  // 🔥 GET PRODUCTS
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load produk");
    }
  }

  // 🔥 GET SHOPS
  static Future<List<Shop>> getShops() async {
    final response = await http.get(Uri.parse("$baseUrl/shops"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Shop.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load toko");
    }
  }

  // 🔥 GET PRODUCTS BY SHOP
  static Future<List<Product>> getProductsByShop(int userId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/products/shop/$userId"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load produk toko");
    }
  }

  // 🔥 LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(res.body);
  }

  // 🔥 REGISTER
  static Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String phone,
      String address) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
      },
    );

    return jsonDecode(res.body);
  }

 // 🔥 SIMPAN USER (MULTI USER)
static Future<void> saveUser(Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();

  final data = prefs.getString("users");
  List users = [];

  if (data != null) {
    users = jsonDecode(data);
  }

  // 🔥 cek kalau email sudah ada → update
  users.removeWhere((u) => u['email'] == user['email']);

  users.add(user);

  print("ALL USERS: $users");

  await prefs.setString("users", jsonEncode(users));

  // 🔥 set user login sekarang
  await prefs.setString("currentUser", jsonEncode(user));
  await prefs.setBool("isLogin", true);
}

// 🔥 AMBIL USER LOGIN
static Future<Map<String, dynamic>?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString("currentUser");

  if (data != null) {
    return jsonDecode(data);
  }
  return null;
}

// 🔥 AMBIL SEMUA USER
static Future<List> getUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString("users");

  if (data != null) {
    return jsonDecode(data);
  }
  return [];
}

// 🔥 LOGIN MULTI USER
static Future<Map<String, dynamic>?> loginLocal(
    String email, String password) async {

  final users = await getUsers();

  // 🔥 DEBUG DI SINI
  print("LOGIN USERS: $users");

  for (var user in users) {
    if (user['email'] == email && user['password'] == password) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("currentUser", jsonEncode(user));
      await prefs.setBool("isLogin", true);

      return user;
    }
  }

  return null;
}

// 🔥 LOGOUT
static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove("currentUser");
  await prefs.setBool("isLogin", false);
}

  // 🔥 CART
  static Future<void> saveCart(List<Product> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getUser();

    final key = "cart_${user?['id']}";
    final data = cart.map((e) => {
          "id": e.id,
          "name": e.name,
          "price": e.price,
          "image": e.image,
          "store_name": e.storeName,
        }).toList();

    await prefs.setString(key, jsonEncode(data));
  }

  static Future<List<Product>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getUser();

    final key = "cart_${user?['id']}";
    final data = prefs.getString(key);

    if (data != null) {
      final List list = jsonDecode(data);

      return list.map((e) => Product(
        id: e['id'],
        name: e['name'],
        price: e['price'],
        image: e['image'],
        storeName: e['store_name'],
      )).toList();
    }

    return [];
  }

static Future<void> clearCart() async {
  final prefs = await SharedPreferences.getInstance();
  final user = await getUser();

  final key = "cart_${user?['id']}";
  await prefs.remove(key);
}

static Future<int> getCartCount() async {
  final cart = await getCart();
  return cart.length;
}

  // 🔥 CREATE PAYMENT (MIDTRANS)
static Future<String> createPayment(int total, List<Product> cart) async {
  final user = await getUser();

  final response = await http.post(
    Uri.parse("$baseUrl/payment"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "user_id": user?['id'],
      "name": user?['name'],
      "email": user?['email'],
      "phone": user?['phone'],
      "address": user?['address'],
      "total": total,
      "items": cart.map((e) => {
        "product_id": e.id,
        "price": e.price,
        "quantity": 1
      }).toList()
    }),
  );

  final data = jsonDecode(response.body);

    print("RESPONSE PAYMENT: $data");
  print("SNAP TOKEN: ${data['snap_token']}");

  if (data['snap_token'] == null) {
    throw Exception(data['error'] ?? "Snap token null");
  }

  return data['snap_token'];
}

static Future<Map<String, double>?> getLatLng(String address) async {
  try {
    final encodedAddress = Uri.encodeComponent(address);

    final url =
        "https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "Mozilla/5.0 (Flutter App)"
      },
    );

    print("URL: $url");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    if (data == null || data.isEmpty) return null;

    return {
      "lat": double.parse(data[0]['lat']),
      "lng": double.parse(data[0]['lon']),
    };
  } catch (e) {
    print("ERROR LATLNG: $e");
    return null;
  }
}


static Future<double> getDistance(
    double lat1, double lon1, double lat2, double lon2) async {

  final url =
      "http://router.project-osrm.org/route/v1/driving/$lon1,$lat1;$lon2,$lat2?overview=false";

  final response = await http.get(Uri.parse(url));

  final data = jsonDecode(response.body);

  double distance = data['routes'][0]['distance']; // meter

  return distance / 1000; // km
}

static Future<List<dynamic>> getOrders() async {
  final user = await getUser();

  final response = await http.get(
    Uri.parse("$baseUrl/orders/${user?['id']}"),
  );

  return jsonDecode(response.body);
}


}
