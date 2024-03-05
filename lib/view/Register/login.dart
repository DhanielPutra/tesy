import 'package:flutter/material.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/view/Register/register.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(15, 90, 15, 0),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/bbq.jpg',
              fit: BoxFit.cover,
              width: 130.0,
              height: 130.0,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Back",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 23),
          ),
          const Text(
            "Sign In to access your account!",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            style: const TextStyle(height: 1.5),
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
                borderSide: const BorderSide(
                    color: Colors.black), // Hilangkan borderSide
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Enter e-Mail / Username',
              suffixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            style: const TextStyle(height: 1.5),
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
                borderSide: const BorderSide(
                    color: Colors.black), // Hilangkan borderSide
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Enter Password',
              suffixIcon: const Icon(Icons.password_outlined),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (bool? newValue) {
                  setState(() {
                    rememberMe = newValue!;
                  });
                },
              ),
              const Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 86,
              ),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 55,
          ),
          Container(
            height: 60,
            width: 330,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => homepage()));
                },
                child: Text(
                  'LOGIN',
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
          Padding(padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
          child :
           Row(
            children: [
              const Text(
                'New Member?',style: TextStyle(color: Colors.black,fontSize: 15),
              ),
              TextButton(
                  onPressed: () {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HalamanDaftar()));
                  },
                  child: const Text(
                    'Register Now!',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),),
        ],
      ),
    ));
  }
}
