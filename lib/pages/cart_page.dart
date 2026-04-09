import 'package:flutter/material.dart';
import '../models/product.dart';
import 'checkout_page.dart';
import '../services/api_service.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<int> qty = [];

  @override
  void initState() {
    super.initState();
    qty = List.generate(widget.cart.length, (index) => 1);
  }

  @override
  Widget build(BuildContext context) {

    int total = 0;
    for (int i = 0; i < widget.cart.length; i++) {
      total += widget.cart[i].price * qty[i];
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      appBar: AppBar(
        title: Text("Keranjang Saya"),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiService.clearCart();
              setState(() {
                widget.cart.clear();
                qty.clear();
              });
            },
            child: Text("Hapus Semua",
                style: TextStyle(color: Colors.orange)),
          )
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final p = widget.cart[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "${ApiService.imageUrl}/${p.image}",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Fresh Baked Daily",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Rp ${p.price}",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔥 QTY + DELETE
                      Row(
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (qty[index] > 1) {
                                      setState(() {
                                        qty[index]--;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.remove, size: 16),
                                ),

                                Text("${qty[index]}"),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      qty[index]++;
                                    });
                                  },
                                  icon: Icon(Icons.add, size: 16),
                                ),
                              ],
                            ),
                          ),

                          // 🔥 DELETE (INI YANG DITAMBAH)
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                widget.cart.removeAt(index);
                                qty.removeAt(index);
                              });

                              await ApiService.saveCart(widget.cart);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      )

                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Total Pembayaran",
                    style: TextStyle(color: Colors.grey)),

                SizedBox(height: 5),

                Text(
                  "Rp $total",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),

                SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {

                    await ApiService.clearCart();

                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckoutPage(cart: widget.cart, total: total),
                      ),
                    );
                  },
                  child: Text(
                    "Checkout (${widget.cart.length} Item) →",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}