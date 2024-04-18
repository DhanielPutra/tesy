import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/homepage.dart';
import 'package:marketplace/models/api_response.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/view/Register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false;
  String errorMessage = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _showInvalidCredentialsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credentials'),
          content: Text('The email or password you entered is incorrect.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordVisible = false;

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }

  Future<void> _login() async {
    // Replace apiUrl with your actual login API endpoint
    const apiUrl = 'https://barbeqshop.online/api/login';
    setState(() {
      loading = true;
      errorMessage = '';
    });

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': txtEmail.text.toString(),
          'password': txtPassword.text.toString(),
        },
        // headers: {'Content-Type': 'application/json'},
      );

      // setState(() {
      //   var responseData = jsonDecode(response.body);
      //   print(response.statusCode.toString());
      //   print(responseData);
      // });
      if (response.statusCode == 200) {
        // Login successful
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        // final int id = responseData['user']['id'];
        // final String username = responseData['user']['username'];
        // setState(() {
        //   errorMessage = 'success';
        //   print(token);
        // });
        _saveAndRedirectToHome(User());

        // Handle the token or navigate to the home screen
        // For now, we'll print the token to the console
        // print('Login successful! Token: $token');
      } else {
        // Login failed
        setState(() {
          errorMessage = 'Failed to login';
        });
        // _showInvalidCredentialsAlert();
      }
    } catch (e) {
      // Exception occurred
      setState(() {
        errorMessage = 'Failed to connect to the server';
      });
    } finally {
      setState(() {
        loading = false;
      });
      _showInvalidCredentialsAlert();
      txtPassword.clear();
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('id', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => homepage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(height: 1.5),
                      controller: txtEmail,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: const EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Enter e-Mail ',
                        suffixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: const TextStyle(height: 1.5),
                      controller: txtPassword,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: const EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Enter Password',
                        suffixIcon: _buildPasswordVisibilityToggle(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool? newValue) {
                          setState(() {
                            rememberMe = newValue ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB50B0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New Member?',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HalamanDaftar()));
                        },
                        child: const Text(
                          'Register Now!',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
