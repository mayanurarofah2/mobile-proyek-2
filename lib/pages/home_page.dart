import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'search_page.dart';
import 'cart_page.dart';
import 'detail_page.dart';
import 'shop_page.dart';
import 'profile_page.dart';
import '../pages/order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> cart = [];
  String selectedCategory = "All";

  bool hideBadge = false;

  // 🔥 TAMBAHAN (LOAD CART PER USER)
  @override
  void initState() {
    super.initState();
    loadCart();
  }

 Future<void> loadCart() async {
    cart = await ApiService.getCart();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: ApiService.getProducts(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Tidak ada produk"));
            }

            final products = snapshot.data!;

            final categories = ["All"] +
                products.map((e) => e.name.split(" ").first).toSet().toList();

            final filteredProducts = selectedCategory == "All"
                ? products
                : products
                    .where((e) => e.name
                        .toLowerCase()
                        .contains(selectedCategory.toLowerCase()))
                    .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔍 SEARCH
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SearchPage(cart: cart),
    ),
  );
},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey),
                                  SizedBox(width: 10),
                                  Text("Cari roti favoritmu...",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        // 🛒 CART
                      GestureDetector(
  onTap: () async {
await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CartPage(cart: cart),
  ),
);

// 🔥 1. reload data dulu
await loadCart();

// 🔥 2. baru setState
setState(() {
  hideBadge = true;
});
  },
                          child: Stack(
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 28),
                             if (cart.isNotEmpty && !hideBadge)
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.orange,
                                    child: Text(
                                      cart.length.toString(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),

                        SizedBox(width: 10),

                        // 🔔 NOTIF
                        Stack(
                          children: [
                            Icon(Icons.notifications_none, size: 28),
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.orange,
                                child: Text("1",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔥 SLIDER
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      itemCount: products.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        final p = products[index];

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                "${ApiService.imageUrl}/${p.image}" //awassssss
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // 📦 KATEGORI
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Kategori",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),

                  SizedBox(height: 10),

                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final c = categories[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = c;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == c
                                        ? Colors.orange
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.cake,
                                      color: selectedCategory == c
                                          ? Colors.white
                                          : Colors.orange),
                                ),
                                SizedBox(height: 6),
                                Text(c)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🧁 GRID
                  GridView.builder(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final p = filteredProducts[index];

                     return GestureDetector(
  onTap: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(product: p),
      ),
    );

    if (result == true) {
      loadCart();
    }
  },
                        child: Container(
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

                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  "${ApiService.imageUrl}/${p.image}",
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),

                                          SizedBox(height: 2),

                                          Text(
                                            p.storeName,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Rp ${p.price}",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          // 🔥 FIX TOMBOL + (MASUK CART)
                                          GestureDetector(
                                            onTap: () async {
                                              cart.add(p);

                                              await ApiService.saveCart(cart);

                                              setState(() {
  hideBadge = false; // 🔥 munculin notif lagi
});

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "${p.name} ditambahkan"),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.orange,
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

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF3E2C7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, "BERANDA", true),
            GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopPage(),
      ),
    );
  },
  child: _navItem(Icons.store, "Shop", false),
),
           GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderPage(),
      ),
    );
  },
  child: _navItem(Icons.receipt, "PESANAN", false),
),
            GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(),
      ),
    );
  },
  child: _navItem(Icons.person, "PROFIL", false),
),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String title, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.orange : Colors.grey),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: active ? Colors.orange : Colors.grey,
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
