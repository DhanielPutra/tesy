import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/api_response.dart';
import 'package:marketplace/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController namaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _image; // Variabel untuk menyimpan gambar yang dipilih

  @override
  void initState() {
    super.initState();
    // Menggunakan gambar yang disediakan awal sebagai gambar default
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        print('Nama gambar terpilih: ${pickedImage.path.split('/').last}');
      } else {
        print('No image selected.');
      }
    });
  }

  String apiUrl = "https://barbeqshop.online/api/user";

  Future<ApiResponse> updateUser(
      String name, String email, String phone, String? imageBase64) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(
        'token'); // Asumsikan kamu menggunakan token untuk autentikasi

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'image': imageBase64,
      }),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse(error: 'Failed to update profile');
    }
  }

  Future<void> _updateProfile() async {
    try {
      ApiResponse response = await updateUser(
        namaController.text,
        teleponController.text,
        emailController.text,
        _image != null ? getStringImage(_image!) : null,
      );
      if (response.data != null) {
        // Jika berhasil, tampilkan pesan sukses atau lakukan tindakan lain yang sesuai
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
        Navigator.pop(context, [
          namaController.text,
          teleponController.text,
          emailController.text,
          _image, // Mengirim gambar kembali ke layar Profile
        ]);
      } else {
        // Jika gagal, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.error ?? 'Failed to update profile'),
        ));
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while updating profile'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 201, 11, 11),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
            child: Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          TextButton(
            onPressed: () {
              _updateProfile();
            },
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //gambar
                        children: [
                          Container(
                            padding: const EdgeInsets.all(50),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 201, 11, 11),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                              child: GestureDetector(
                                onTap: _getImageFromGallery,
                                child: CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: _image != null
                                      ? (_image!.path.startsWith('http')
                                          ? NetworkImage(_image!.path)
                                              as ImageProvider
                                          : FileImage(_image!))
                                      : null,
                                  child: _image == null
                                      ? Icon(Icons.person, size: 80)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fullname'),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Phone number'),
                      TextField(
                        controller: teleponController,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Email'),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
