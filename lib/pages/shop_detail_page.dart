import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data =
        await ApiService.getProductsByShop(widget.shop.userId);

    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 HEADER
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
              ),
            ),

            // 🔥 AVATAR
            Transform.translate(
              offset: Offset(0, -50),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange.shade100,
                  backgroundImage: shop.photo != null
    ? NetworkImage("${ApiService.uploadUrl}/${shop.photo}")
    : null,
child: shop.photo == null
    ? Text(
        shop.ownerName.length >= 2
            ? shop.ownerName.substring(0, 2).toUpperCase()
            : shop.ownerName.substring(0, 1).toUpperCase(),
      )
    : null,
                ),
              ),
            ),

            // 🔥 INFO
            Transform.translate(
              offset: Offset(0, -40),
              child: Column(
                children: [
                  Text(shop.name,
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(shop.email,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 🔥 STAT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: box("Produk", products.length.toString())),
                  SizedBox(width: 10),
                  Expanded(child: box("Pesanan", "0")),
                  SizedBox(width: 10),
                  Expanded(child: box("Pendapatan", "Rp 0")),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 🔥 DETAIL TITLE
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Detail Toko",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            // 🔥 DETAIL TOKO (UPDATED DESIGN)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(Icons.store,
                              color: Colors.orange, size: 18),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Nama Toko",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Text(shop.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),

                    Divider(height: 20),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(Icons.person,
                              color: Colors.orange, size: 18),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Pemilik",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Text(shop.ownerName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),

                    Divider(height: 20),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(Icons.location_on,
                              color: Colors.orange, size: 18),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Alamat",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Text(shop.address),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔥 PRODUK
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Produk",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            SizedBox(height: 10),

            isLoading
                ? CircularProgressIndicator()
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final p = products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(product: p),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12, blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            children: [

                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  "${ApiService.imageUrl}/${p.image}",
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(p.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 4),
                                    Text("Rp ${p.price}",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget box(String title, String value) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFF3E2C7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title),
          SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}