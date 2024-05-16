import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/homepage.dart';
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

  @override
  void initState() {
    super.initState();
    _getSavedCredentials();
  }

  void _getSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      txtEmail.text = prefs.getString('email') ?? '';
      txtPassword.text = prefs.getString('password') ?? '';
      rememberMe = txtEmail.text.isNotEmpty && txtPassword.text.isNotEmpty;
    });
    if (rememberMe) {
      _login();
    }
  }

  void _showInvalidCredentialsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Credentials'),
          content:
              const Text('The email or password you entered is incorrect.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['data']['token'];
        final int id_user = responseData['data']['user']['id'];

        if (token != null && id_user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('userId', id_user);

          if (rememberMe) {
            await prefs.setString('email', txtEmail.text.toString());
            await prefs.setString('password', txtPassword.text.toString());
          }

          _saveAndRedirectToHome();
          print('Login successful! Token: $token, User ID: $id_user');
        } else {
          setState(() {
            errorMessage = 'Failed to login: Token or user ID missing';
          });
          print('Failed to login: Token or user ID missing');
        }
      } else {
        setState(() {
          errorMessage = 'Failed to login: ${response.reasonPhrase}';
        });
        print('Failed to login: ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to the server: $e';
      });
      print('Failed to connect to the server: $e');
    } finally {
      setState(() {
        loading = false;
      });
      if (errorMessage.isNotEmpty) {
        _showInvalidCredentialsAlert();
      }
      txtPassword.clear();
    }
  }

  void _saveAndRedirectToHome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

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
              SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
              Text(
                "Sign In to access your account!",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(height: 1.5),
                      controller: txtEmail,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Enter e-Mail ',
                        suffixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(height: 1.5),
                      controller: txtPassword,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
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
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 55,
              ),
              Container(
                height: 60,
                width: 330,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                      (txtEmail.text.isNotEmpty && txtPassword.text.isNotEmpty)
                          ? _login()
                          : null;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB50B0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: loading
                        ? CircularProgressIndicator()
                        : Text(
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New Member?',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HalamanDaftar()));
                        },
                        child: Text(
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
