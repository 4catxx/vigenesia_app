import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namaController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscureText = true;

  Future<String> registerUser(
      String nama, String profesi, String email, String password) async {
    final apiUrl = Uri.parse('http://127.0.0.1:80/vigenesia/api/registrasi');
    final response = await http.post(
      apiUrl,
      body: {
        'nama': nama,
        'profesi': profesi,
        'email': email,
        'password': password,
      },
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      bool isActive = responseData['is_active'];

      if (isActive) {
        return "success";
      } else {
        return 'Gagal mendaftar.';
      }
    } else if (response.statusCode == 400) {
      if (responseData == "The given email already exists.") {
        return 'Email sudah terdaftar.';
      } else if (responseData == "Provide complete user info to add.") {
        return 'Harap lengkapi informasi pengguna.';
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
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white, // Warna latar belakang hijau
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  children: [
                    Image.asset('images/4207.png', height: 200.0),
                    Text(
                      "Buat Akun",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: "nama",
                            controller: namaController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(),
                              labelText: "Nama",
                              fillColor:
                                  Colors.white, // Warna latar belakang putih
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "profesi",
                            controller: profesiController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(),
                              labelText: "Profesi",
                              fillColor:
                                  Colors.white, // Warna latar belakang putih
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "email",
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              fillColor:
                                  Colors.white, // Warna latar belakang putih
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          SizedBox(height: 20),
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
                              fillColor:
                                  Colors.white, // Warna latar belakang putih
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Sudah punya akun? ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Login(),
                                            ),
                                          );
                                        },
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
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
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    String response = await registerUser(
                                      namaController.text,
                                      profesiController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );

                                    if (response == "success") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(response),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text("Daftar"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
