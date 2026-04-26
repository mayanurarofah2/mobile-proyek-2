import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../models/shop.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          Stack(
            children: [
              Image.network(
                "${ApiService.imageUrl}/${product.image}",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              )
            ],
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 NAMA + HARGA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(product.name,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text("Rp ${product.price}",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),

                  SizedBox(height: 8),

                  /// 🔥 TOKO
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.store, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product.storeName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  /// ⭐ RATING
                  Text("⭐ 4.8 (120 reviews)",
                      style: TextStyle(color: Colors.grey)),

                  SizedBox(height: 20),

                  /// 🔥 DESKRIPSI
                  Text("Deskripsi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  Text(
                      "Produk ini dibuat dengan bahan premium dan kualitas terbaik."),

                  SizedBox(height: 20),

                  /// ✅ 🔥 INFO PENJUAL (FIX TOTAL)
                  FutureBuilder<List<Product>>(
                    future: ApiService.getProducts(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox();

                      final products = snapshot.data!;

                      final current = products.firstWhere(
                        (p) => p.id == product.id,
                        orElse: () => product,
                      );

                      return FutureBuilder<List<Shop>>(
                        future: ApiService.getShops(),
                        builder: (context, shopSnap) {
                          if (!shopSnap.hasData) return SizedBox();

                          final shops = shopSnap.data!;

                          final shop = shops.firstWhere(
                            (s) => s.name == current.storeName,
                            orElse: () => Shop(
                              id: 0,
                              userId: 0,
                              name: "-",
                              address: "-",
                              email: "-",
                              ownerName: "-",
                            ),
                          );

                          return Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🏪 Info Penjual",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),

                                SizedBox(height: 8),

                                Text("Nama: ${shop.ownerName}"),
                                Text("Email: ${shop.email}"),
                                Text("Alamat: ${shop.address}"),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  Spacer(),

                  /// 🔥 BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            List<Product> cart =
                                await ApiService.getCart();

                            cart.add(product);

                            await ApiService.saveCart(cart);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${product.name} ditambahkan ke keranjang"),
                              ),
                            );

                            Navigator.pop(context, true);
                          },
                          child: Text("Tambah ke Keranjang"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}