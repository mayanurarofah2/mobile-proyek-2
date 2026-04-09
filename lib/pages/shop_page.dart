import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/shop.dart';
import 'shop_detail_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Shop> shops = [];
  bool isLoading = true; // 🔥 tambah ini

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      final data = await ApiService.getShops();
      setState(() {
        shops = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E2C7),

      appBar: AppBar(
        backgroundColor: Color(0xFFF3E2C7),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("Pilih Toko", style: TextStyle(color: Colors.black)),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 🔥 loading
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Temukan toko roti terdekat untuk pesanan Anda",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final s = shops[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShopDetailPage(shop: s),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4) // 🔥 tambahan ringan
                            ],
                          ),
                          child: Row(
                            children: [

                              CircleAvatar(
  radius: 30,
  backgroundColor: Colors.orange.shade100,
  backgroundImage: s.photo != null
      ? NetworkImage("${ApiService.uploadUrl}/${s.photo}")
      : null,
  child: s.photo == null
      ? Icon(Icons.store, color: Colors.orange)
      : null,
),

                              SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(s.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),

                                    SizedBox(height: 2),

                                    Text(s.address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis, // 🔥 biar rapi
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),

                                    SizedBox(height: 4),

                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            size: 14, color: Colors.orange),
                                        Text("4.8 (1k ulasan)",
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text("BUKA",
                                    style: TextStyle(color: Colors.green)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}