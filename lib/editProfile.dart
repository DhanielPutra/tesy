import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String initialNama;
  final String initialTelepon;
  final String initialEmail;
  final File? initialImage; // Variabel untuk menyimpan gambar profil
  const EditProfile(
      {super.key,
      required this.initialNama,
      required this.initialTelepon,
      required this.initialEmail,
      this.initialImage});

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
    namaController.text = widget.initialNama;
    teleponController.text = widget.initialTelepon;
    emailController = TextEditingController(text: widget.initialEmail);
    _image = widget
        .initialImage; // Menggunakan gambar yang disediakan awal sebagai gambar default
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
              _sendDataBack(context);
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
                                      ? FileImage(_image!)
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

  void _sendDataBack(BuildContext context) {
    Navigator.pop(context, [
      namaController.text,
      teleponController.text,
      emailController.text,
      _image, // Mengirim gambar kembali ke layar Profile
    ]);
  }
}
