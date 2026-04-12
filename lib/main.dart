import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  Future<Widget> checkLogin() async {
    final user = await ApiService.getUser();

    if (user != null) {
      return HomePage(); // 🔥 sudah login
    } else {
      return LoginPage(); // 🔥 belum login
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}
