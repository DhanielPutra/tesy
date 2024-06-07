import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/view/Register/login.dart';

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
        
        errormessage = 'success';
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()), (route) => false);
      } else {
        // Login failed
        setState(() {
          errormessage = 'Failed to login';
          print(response);
        });
      }
    } catch (e) {
      // Exception occurred
      setState(() {
        errormessage = 'Failed to connect to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.only(top: 20),
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
              const SizedBox(
                height: 10,
              ),
              //WELCOME TEXT
              const Text(
                'Get started',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create Your BarBeQ Account!',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 20),

              //NAMA LENGKAP
              TextField(
                style: const TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: namaLengkapController,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFD9D9D9),
                  filled: true,
                  contentPadding: const EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  hintText: 'Fullname',
                  suffixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),

              // TELEPON
              TextField(
                style: const TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: teleponController,
                decoration: InputDecoration(
                  fillColor: const Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: const EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Phone Number',
                  suffixIcon: const Icon(Icons.phone_enabled_outlined),
                ),
              ),
              const SizedBox(height: 10),

              //EMAIL
              TextField(
                style: const TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: const Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: const EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Email', suffixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 10),

              //PASSWORD
              TextField(
                style: const TextStyle(height: 1.5),
                onChanged: (value) {
                  setState(() {
                    isFormComplete = validateForm();
                  });
                },
                controller: passwordController,
                decoration: InputDecoration(
                  fillColor: const Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: const EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Password', suffixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),

              //KONFIRMASI PAASSWORD
              TextField(
                style: const TextStyle(height: 1.5),
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

                  fillColor: const Color(
                      0xFFD9D9D9), // Ganti dengan warna latar belakang yang diinginkan
                  filled: true,
                  contentPadding: const EdgeInsets.all(20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.transparent), // Hilangkan borderSide
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black), // Hilangkan borderSide
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Konfirmasi Password',

                  suffixIcon: const Icon(Icons.lock_outlined),
                ),
              ),
              Text(
                passwordError,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 40),

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB50B0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Sesuaikan nilai radius sesuai keinginan
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),

              //LINK LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('sudah memiliki akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Login(),
            transitionDuration: const Duration(milliseconds: 0),
          ),
          (route) => false,
        );
                    },
                    child: const Text(
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
