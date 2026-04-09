import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController address;

  File? image;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.user['name']);
    phone = TextEditingController(text: widget.user['phone']);
    address = TextEditingController(text: widget.user['address']);

    if (widget.user['photo'] != null) {
      image = File(widget.user['photo']);
    }
  }

  Future pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  void save() async {
    widget.user['name'] = name.text;
    widget.user['phone'] = phone.text;
    widget.user['address'] = address.text;

    if (image != null) {
      widget.user['photo'] = image!.path; // 🔥 SIMPAN PATH
    }

    await ApiService.saveUser(widget.user);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profil")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: image != null ? FileImage(image!) : null,
                child: image == null ? Icon(Icons.camera_alt) : null,
              ),
            ),

            SizedBox(height: 20),

            TextField(controller: name, decoration: InputDecoration(labelText: "Nama")),
            TextField(controller: phone, decoration: InputDecoration(labelText: "No HP")),
            TextField(controller: address, decoration: InputDecoration(labelText: "Alamat")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}