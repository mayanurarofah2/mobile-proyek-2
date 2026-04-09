import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    var data = await ApiService.getOrders();
    setState(() {
      orders = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pesanan")),
      body: orders.isEmpty
          ? Center(child: Text("Belum ada pesanan"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                var order = orders[i];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🏪 NAMA TOKO
                        Text(
  order['user']?['shop']?['store_name'] ?? '-',
  style: TextStyle(fontWeight: FontWeight.bold),
),

                        SizedBox(height: 5),

                        /// 📦 PRODUK
                        ...order['items'].map<Widget>((item) {
                          return Text(
                              "${item['product']['name']} x${item['quantity']}");
                        }).toList(),

                        SizedBox(height: 5),

                        /// 💰 TOTAL
                        Text("Rp ${order['total']}"),

                        /// 📊 STATUS
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: order['status'] == 'pending'
                                ? Colors.orange
                                : order['status'] == 'diproses'
                                    ? Colors.blue
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            order['status'].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        SizedBox(height: 10),

                        /// 📞 NO HP
                        Text("Hubungi Penjual: ${order['phone'] ?? '-'}"),

                        SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () async {
                            final phone = order['phone'];
                            if (phone != null) {
                              final url =
                                  Uri.parse("https://wa.me/$phone");
                              await launchUrl(url);
                            }
                          },
                          child: Text("Hubungi Penjual"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}