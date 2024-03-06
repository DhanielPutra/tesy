import 'package:flutter/material.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/view/Register/login.dart';

class HalamanDaftar extends StatefulWidget {
  HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  bool isFormComplete = false;
  String passwordError = '';

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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => login()));
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => login()));
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
