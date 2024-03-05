import 'package:flutter/material.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/view/Register/login.dart';

class HalamanDaftar extends StatelessWidget {
  const HalamanDaftar({super.key});

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
              //LOGO
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
              //WELCOME
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
              SizedBox(height: 40),

              //TOMBOL SIGN UP
              Container(
                height: 50,
                width: 330,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => login()));
                    },
                    child: Text(
                      'Sign Up',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17,color: Colors.white),
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
