import 'dart:async'; // 🔥 TAMBAHAN
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'payment_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product> cart;
  final int total;

  const CheckoutPage({super.key, required this.cart, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int ongkir = 15000;

  Map<String, dynamic>? user;
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();

  Timer? debounce; // 🔥 TAMBAHAN

@override
void initState() {
  super.initState();
  loadUser();

  addressC.addListener(() {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(Duration(seconds: 1), () {
      hitungOngkirReal();
    });
  });
}

void loadUser() async {
  final u = await ApiService.getUser();

  setState(() {
    user = u;
    nameC.text = u?['name'] ?? "";
    phoneC.text = u?['phone'] ?? "";
    addressC.text = u?['address'] ?? "";
  });

  // 🔥 WAJIB biar langsung hitung
  hitungOngkirReal();
}
Future<void> hitungOngkirReal() async {
  try {
    if (addressC.text.isEmpty) return;

    // 🔥 TARUH DI SINI
    await Future.delayed(Duration(seconds: 1));

    final userLoc =
        await ApiService.getLatLng(addressC.text + ", Indonesia");

    if (userLoc == null) {
      print("LOKASI TIDAK DITEMUKAN");
      return;
    }

    double storeLat = -6.326;
    double storeLng = 108.324;

    double jarak = await ApiService.getDistance(
      storeLat,
      storeLng,
      userLoc['lat']!,
      userLoc['lng']!,
    );

    setState(() {
      if (jarak < 5) ongkir = 5000;
      else if (jarak < 10) ongkir = 10000;
      else if (jarak < 20) ongkir = 15000;
      else ongkir = 25000;
    });

  } catch (e) {
    print("ERROR ONGKIR: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    int grandTotal = widget.total + ongkir;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(title: Text("Checkout")),

      // 🔥 FIX: biar gak ketutup keyboard
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Data Pembeli",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  TextField(
                    controller: nameC,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: phoneC,
                    decoration: InputDecoration(
                      labelText: "No HP",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: addressC,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 LIST PRODUK (TETAP)
            ListView.builder(
              shrinkWrap: true, // 🔥 TAMBAHAN
              physics: NeverScrollableScrollPhysics(), // 🔥 TAMBAHAN
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
                      BoxShadow(color: Colors.black12, blurRadius: 5)
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
                    ],
                  ),
                );
              },
            ),

            // 🔥 TOTAL
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Ringkasan Pembayaran",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text("Rp ${widget.total}"),
                    ],
                  ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ongkir"),
                      Text("Rp $ongkir"),
                    ],
                  ),

                  Divider(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rp $grandTotal",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    onPressed: () async {
                      try {
                        String snapToken =
                            await ApiService.createPayment(grandTotal, widget.cart);

                        if (snapToken.isEmpty) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentPage(snapToken: snapToken),
                          ),
                        );
                      } catch (e) {
                        print("ERROR PAYMENT: $e");
                      }
                    },

                    child: Text(
                      "Bayar Sekarang",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 100), // 🔥 biar gak ketutup
          ],
        ),
      ),
    );
  }
}