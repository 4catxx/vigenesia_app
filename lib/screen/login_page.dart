import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register_page.dart';
import 'dashboard_page.dart';

final _formKey = GlobalKey<FormBuilderState>();
bool _obscureText = true;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> loginUser(String email, String password) async {
    final apiUrl = Uri.parse('http://127.0.0.1:80/vigenesia/api/login');
    final response = await http.post(
      apiUrl,
      body: {'email': email, 'password': password},
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData['is_active'] ? "success" : 'Gagal.';
    } else if (response.statusCode == 400) {
      if (responseData == "Ada kesalahan di email / password.") {
        return 'Login gagal. Email atau password salah.';
      } else if (responseData == "Belum mengisi email dan password.") {
        return 'Email dan password harus diisi.';
      } else {
        return 'Terjadi kesalahan.';
      }
    } else {
      return 'Terjadi kesalahan saat menghubungi server.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4CAF50), // Warna latar belakang hijau
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/4207.png',
                  height: 200.0), // Gambar dari assets
              Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Warna teks putih
                ),
              ),
              Text(
                'Silakan masuk untuk melanjutkan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Warna teks putih
                ),
              ),
              SizedBox(height: 20),
              FormBuilder(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "email",
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Email harus diisi',
                          ),
                          FormBuilderValidators.email(
                            errorText: 'Format email tidak valid',
                          ),
                        ]),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        obscureText: _obscureText,
                        name: "password",
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Password harus diisi',
                          ),
                        ]),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Belum punya akun? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Daftar sekarang',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Register(),
                                        ),
                                      );
                                    },
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF2196F3), // Warna tombol biru
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                String response = await loginUser(
                                    emailController.text,
                                    passwordController.text);

                                if (response == "success") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Dashboard(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Color(0xFFE57373),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text('Masuk'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
