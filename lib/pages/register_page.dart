import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

void register() async {
  try {
    final res = await ApiService.register(
      name.text.trim(),
      email.text.trim(),
      password.text.trim(),
      phone.text.trim(),
      address.text.trim(),
    );

    print("REGISTER RESPONSE: $res");

    if (res['user'] != null) {
      await ApiService.saveUser(res['user']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi gagal")),
      );
    }
  } catch (e) {
    print("ERROR REGISTER: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFE6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
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

              Text("REGISTRASI",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),

              SizedBox(height: 30),

              input(name, "Nama Lengkap"),
              input(email, "Masukkan email"),
              input(password, "Masukkan password", isPassword: true),
              input(phone, "No HP"),
              input(address, "Alamat"),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("DAFTAR"),
              ),
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
}