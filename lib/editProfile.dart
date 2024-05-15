import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/api_response.dart';
import 'package:marketplace/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController namaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        print('Selected image name: ${pickedImage.path.split('/').last}');
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> fetchUserProfile() async {
    String token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('https://barbeqshop.online/api/profile'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            namaController.text = data['data']['user']['name'];
            teleponController.text = data['data']['user']['no_tlp'];
            emailController.text = data['data']['user']['email'];
            _imageUrl = data['data']['user']['gambar'];
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<ApiResponse> updateUser(
    String name, String email, String phone, File? image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiUrl = "https://barbeqshop.online/api/user";
  String? token = prefs.getString('token');

  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['no_tlp'] = phone;

    if (image != null) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('gambar', stream, length,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return ApiResponse.fromJson(jsonDecode(responseBody));
    } else {
      var responseBody = await response.stream.bytesToString();
      print('Failed to update profile: $responseBody');
      return ApiResponse(error: 'Failed to update profile');
    }
  } catch (e) {
    print('Exception occurred while updating profile: $e');
    return ApiResponse(error: 'An error occurred while updating profile');
  }
}


  Future<void> _updateProfile() async {
  try {
    print('Updating profile with the following data:');
    print('Name: ${namaController.text}');
    print('Email: ${emailController.text}');
    print('Phone: ${teleponController.text}');
    print('Image: ${_image != null ? 'Image selected' : 'No image selected'}');

    ApiResponse response = await updateUser(
      namaController.text,
      emailController.text,
      teleponController.text,
      _image,
    );

    if (response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully'),
      ));
      Navigator.pop(context, [
        namaController.text,
        teleponController.text,
        emailController.text,
        _image,
      ]);
    } else {
      print('Update profile failed with error: ${response.error}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error ?? 'Failed to update profile'),
      ));
    }
  } catch (e) {
    print('Error updating profile: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('An error occurred while updating profile'),
    ));
  }
}


  String getStringImage(File image) {
    final bytes = image.readAsBytesSync();
    return base64Encode(bytes);
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
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(
          child: Text(
            'Edit Profil',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _updateProfile,
            child: Text(
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
                        children: [
                          Container(
                            padding: EdgeInsets.all(50),
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
                                      : _imageUrl != null
                                          ? NetworkImage(_imageUrl!) as ImageProvider
                                          : null,
                                  child: _image == null && _imageUrl == null
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
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fullname'),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(height: 10),
                      Text('Phone number'),
                      TextField(
                        controller: teleponController,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(height: 10),
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
