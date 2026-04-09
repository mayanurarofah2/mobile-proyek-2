import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  final List<Product> cart;

  const SearchPage({super.key, required this.cart});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> products = [];
  List<Product> filtered = [];
  String selectedCategory = "Semua";

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await ApiService.getProducts();
    setState(() {
      products = data;
      filtered = data;
    });
  }

  void search(String q) {
    setState(() {
      filtered = products.where((e) {
        final matchName =
            e.name.toLowerCase().contains(q.toLowerCase());

        final matchCategory = selectedCategory == "Semua" ||
            e.category == selectedCategory;

        return matchName && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Semua",
      "Roti Tawar",
      "Pastry",
      "Kue"
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: TextField(
          onChanged: search,
          decoration: InputDecoration(
            hintText: "Cari roti favoritmu...",
            border: InputBorder.none,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.tune, color: Colors.white),
          )
        ],
      ),

      body: Column(
        children: [

          // 🔥 KATEGORI
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final c = categories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = c;
                      search("");
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == c
                          ? Colors.orange
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        c,
                        style: TextStyle(
                          color: selectedCategory == c
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 10),

          // 🔥 GRID PRODUK
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filtered.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final p = filtered[index];

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
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        // IMAGE + RATING
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.vertical(
                                      top: Radius.circular(20)),
                              child: Image.network(
                               "${ApiService.imageUrl}/${p.image}",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 14,
                                        color: Colors.orange),
                                    Text("4.8",
                                        style:
                                            TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [

                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    // KATEGORI
                                    Text(
                                      p.category.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange,
                                          fontWeight:
                                              FontWeight.bold),
                                    ),

                                    SizedBox(height: 4),

                                    Text(
                                      p.name,
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold),
                                    ),

                                    SizedBox(height: 4),

                                    // 🔥 NAMA TOKO
                                    Text(
                                      p.storeName,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      "Rp ${p.price}",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight:
                                              FontWeight.bold),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.cart.add(p);
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Ditambahkan ke keranjang"),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.orange,
                                        child: Icon(Icons.add,
                                            color: Colors.white,
                                            size: 18),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
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