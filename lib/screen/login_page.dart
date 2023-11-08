import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register_page.dart';
import 'menu_page.dart';
import 'dashboard_page.dart';
import 'dart:async';

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
  bool _isLoading = false;

  Future<String> loginUser(String email, String password) async {
    setState(() {
      _isLoading = true; // Tampilkan loading indicator
    });

    final apiUrl = Uri.parse('http://127.0.0.1:80/vigenesia/api/login');

    try {
      final response = await http.post(
        apiUrl,
        body: {'email': email, 'password': password},
      ).timeout(const Duration(seconds: 10)); // Timeout ke permintaan HTTP

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
    } on TimeoutException catch (e) {
      return 'Terjadi kesalahan saat menghubungi server.';
    } catch (error) {
      return 'Terjadi kesalahan saat menghubungi server.';
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan loading indicator
      });
    }

    return 'Terjadi kesalahan.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      color: Colors.black, // Warna teks
                    ),
                  ),
                  Text(
                    'Silakan masuk untuk melanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Warna teks
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
                                        color: Colors.black,
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
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF2196F3), // Warna tombol
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            response,
                                            style:
                                                TextStyle(color: Colors.white),
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Lapisan hitam transparan
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
