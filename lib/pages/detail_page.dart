import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

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

                  SizedBox(height: 6),

                  Text(
                    "Toko: ${product.storeName}",
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 10),

                  Text("⭐ 4.8 (120 reviews)",
                      style: TextStyle(color: Colors.grey)),

                  SizedBox(height: 20),

                  Text("Deskripsi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  Text(
                      "Produk ini dibuat dengan bahan premium dan kualitas terbaik."),

                  Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 14),
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

                            Navigator.pop(context, true); // 🔥 PENTING
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