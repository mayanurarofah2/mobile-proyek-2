import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    user = await ApiService.getUser();
    setState(() {});
  }

  void logout() async {
    await ApiService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFE6),

      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [

                // 🔥 HEADER
                Container(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [

                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: user!['photo'] != null
                                ? FileImage(File(user!['photo']))
                                : null,
                            child: user!['photo'] == null
                                ? Text(
                                    (user!['name'] ?? "U")[0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  )
                                : null,
                          ),

                          // 🔥 tombol edit di foto
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfilePage(user: user!),
                                  ),
                                );
                                loadUser();
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.edit, size: 18, color: Colors.orange),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 10),

                      Text(user!['name'] ?? "-",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),

                      Text(user!['email'] ?? "-",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [

                      infoCard(Icons.phone, "No HP", user!['phone']),
                      infoCard(Icons.location_on, "Alamat", user!['address']),

                      SizedBox(height: 20),

                      button("Edit Profil", Colors.orange, () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(user: user!),
                          ),
                        );

                        loadUser();
                      }),

                      SizedBox(height: 10),

                      button("Logout", Colors.red, logout),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget infoCard(IconData icon, String title, String? value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey)),
                Text(value ?? "-", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
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
              borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(text),
      ),
    );
  }
}