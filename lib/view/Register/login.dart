import 'package:flutter/material.dart';
import 'package:marketplace/homepage.dart';
import 'package:marketplace/models/api_response.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/user_services.dart';
import 'package:marketplace/view/Register/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  Future<ApiResponse> loginUser(String email, String password) async {
    // Replace this with your actual login API call
    // For demonstration, I'm just returning a dummy response
    return ApiResponse();
  }

  void _loginUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      ApiResponse response =
          await loginUser(txtEmail.text, txtPassword.text);
      if (response.error == null) {
        _saveAndRedirectToHome(response.data as User);
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
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
                        hintText: 'Enter e-Mail / Username',
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
                      obscureText: true,
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
                        suffixIcon: const Icon(Icons.password_outlined),
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
                      _loginUser();
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
