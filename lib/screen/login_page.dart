import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register_page.dart';
import 'menu_page.dart';
import 'login/dashboard_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/admin_dashboard.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final ValueNotifier<bool> _obscureText = ValueNotifier(true);

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  Future<void> simpanIdUser(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final ValueNotifier<bool> _isLoading = ValueNotifier(false);

    Future<String> loginUser(String email, String password) async {
      _isLoading.value = true; // Menampilkan indikator login
      final apiUrl = Uri.parse('https://www.vigenesia.org/api/login');

      try {
        print('Sending login request to server'); // Logging tambahan
        final response = await http.post(
          apiUrl,
          body: {'email': email, 'password': password},
        ).timeout(const Duration(seconds: 30)); // HTTP request timeout

        print('Received response from server: $response'); // Logging tambahan

        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          if (responseData['is_active'] == true) {
            print('User login successful.');
            int idUser = int.parse(responseData['data']['iduser']);
            await simpanIdUser(idUser); // Save iduser ke sharepreferences
            if (responseData['data']['role_id'] == "1") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            }
            return "Success";
          } else {
            print('User login failed.');
            return 'Failed.';
          }
        } else if (response.statusCode == 400) {
          if (responseData == "Ada kesalahan di email / password.") {
            return 'Login gagal. Email atau password salah.';
          } else if (responseData == "Belum mengisi email dan password.") {
            return 'Email dan password harus diisi.';
          } else {
            return 'Terjadi kesalahan.';
          }
        } else {
          return 'Terjadi kesalahan saat menghubungi server. Status Code: ${response.statusCode}';
        }
      } on TimeoutException catch (e) {
        print('Timeout ke server: $e'); // Logging tambahan
        return 'Timeout ke server.';
      } catch (error) {
        print('Error: $error'); // Logging tambahan
        return 'Terjadi kesalahan: $error';
      } finally {
        _isLoading.value = false; // Menyembunyikan indikator login
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/4207.png', height: 200.0),
                  Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Silakan masuk untuk melanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(),
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: _obscureText.value,
                            controller: passwordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  _obscureText.value = !_obscureText.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
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
                                  primary: Color(0xFF2196F3),
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    String response = await loginUser(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    if (response != "success") {
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
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, _) {
              if (isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
