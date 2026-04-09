import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

void login() async {
  final user = await ApiService.loginLocal(
    email.text.trim(),
    password.text.trim(),
  );

  if (user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email / password salah")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFE6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cake, color: Colors.orange, size: 30),
                  SizedBox(width: 8),
                  Text("Ruang Kue",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ],
              ),

              SizedBox(height: 40),

              Text("LOGIN",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),

              SizedBox(height: 30),

              input(email, "Masukan Email"),
              input(password, "Masukan password", isPassword: true),

              SizedBox(height: 20),

              button("LOGIN", Colors.orange, login),

              SizedBox(height: 10),

              button("Registrasi", Colors.orange.shade300, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RegisterPage()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget input(TextEditingController c, String hint,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Color(0xFFF3E2C7),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget button(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }
}