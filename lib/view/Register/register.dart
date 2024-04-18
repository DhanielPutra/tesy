import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/homepage.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/view/Register/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanDaftar extends StatefulWidget {
  HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  bool isFormComplete = false;
  String passwordError = '';
  String errormessage = '';

  final TextEditingController namaLengkapController = TextEditingController();

  final TextEditingController teleponController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController konfirmasiPasswordController =
      TextEditingController();

  bool validateForm() {
    return namaLengkapController.text.isNotEmpty &&
        teleponController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        konfirmasiPasswordController.text.isNotEmpty;
  }

  Future<void> _register() async {
    // Replace apiUrl with your actual register API endpoint
    const apiUrl = 'https://barbeqshop.online/api/register';

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': namaLengkapController.text.toString(),
          'no_tlp': teleponController.text.toString(),
          'email': emailController.text.toString(),
          'password': passwordController.text.toString(),
        },
        // headers: {'Content-Type': 'application/json'},
      );

      setState(() {
        var responseData = jsonDecode(response.body);
        print(response.statusCode.toString());
        print(responseData);
      });
      if (response.statusCode == 200) {
        // Login successful
        final responseData = jsonDecode(response.body);
        // final String token = responseData['token'];
        // final int id = responseData['user']['id'];
        // final String username = responseData['user']['username'];
        // setState(() {
        errormessage = 'success';
        //   print(token);
        // });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);

        // Handle the token or navigate to the home screen
        // For now, we'll print the token to the console
        // print('Login successful! Token: $token');
      } else {
        // Login failed
        setState(() {
          errormessage = 'Failed to login';
        });
      }
    } catch (e) {
      // Exception occurred
      setState(() {
        errormessage = 'Failed to connect to the server';
      });
    }
  }

  // void _saveAndRedirectToLogin(User user) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   // await pref.setString('token', user.token ?? '');
  //   await pref.setInt('id', user.id ?? 0);
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => Login()), (route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LOGO APP
              ClipOval(
                child: Image.asset(
                  'assets/bbq.jpg', // Ganti dengan nama file gambar Anda
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover, // Atur sesuai kebutuhan tata letak gambar
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //WELCOME TEXT
              Text(
                'Get started',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Create Your BarBeQ Account!',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 20),

              //NAMA LENGKAP
              TextField(
                style: TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: namaLengkapController,
                decoration: InputDecoration(
                  fillColor: Color(0xFFD9D9D9),
                  filled: true,
                  contentPadding: EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  hintText: 'Fullname',
                  suffixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 10),

              // TELEPON
              TextField(
                style: TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: teleponController,
                decoration: InputDecoration(
                  fillColor: Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Phone Number',
                  suffixIcon: Icon(Icons.phone_enabled_outlined),
                ),
              ),
              SizedBox(height: 10),

              //EMAIL
              TextField(
                style: TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Email', suffixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 10),

              //PASSWORD
              TextField(
                style: TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: passwordController,
                decoration: InputDecoration(
                  fillColor: Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Password', suffixIcon: Icon(Icons.lock_outline),
                ),
              ),
              SizedBox(height: 10),

              //KONFIRMASI PAASSWORD
              TextField(
                style: TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                    passwordError = passwordController.text == value
                        ? ''
                        : 'Passwords do not match';
                  });
                },
                controller: konfirmasiPasswordController,
                decoration: InputDecoration(
                  iconColor: Colors.black,

                  fillColor: Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Konfirmasi Password',

                  suffixIcon: Icon(Icons.lock_outlined),
                ),
              ),
              Text(
                passwordError,
                style: TextStyle(color: Colors.red),
              ),

              SizedBox(height: 40),

              //TOMBOL SIGN UP
              Container(
                height: 50,
                width: 330,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: isFormComplete && passwordError.isEmpty
                        ? () {
                            _register();
                          }
                        : null,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB50B0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Sesuaikan nilai radius sesuai keinginan
                      ),
                    ),
                  ),
                ),
              ),

              //LINK LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('sudah memiliki akun?'),
                  TextButton(
                    onPressed: () {
                      _register();
                    },
                    child: Text(
                      'Log in!',
                      style: TextStyle(color: Color(0xFFB50B0B)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
