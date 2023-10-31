import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register_page.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dashboard_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Inisialisasi GlobalKey untuk FormBuilder
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

  // Fungsi untuk mengirim data login ke API
  Future<String> loginUser(String email, String password) async {
    final apiUrl = Uri.parse('http://127.0.0.1:80/vigenesia/api/login');
    final response = await http.post(
      apiUrl,
      body: {'email': email, 'password': password},
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      bool isActive = responseData['is_active'];

      if (isActive) {
        return "success";
      } else {
        return 'Gagal.';
      }
    } else if (response.statusCode == 400) {
      // Jika status kode HTTP adalah 400, kembalikan pesan yang sesuai
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
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/4207.jpg', height: 300.0),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Center(
                  child: FormBuilder(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: "email",
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(),
                              labelText: "Email",
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
                              contentPadding: EdgeInsets.only(left: 10),
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
                            validator: FormBuilderValidators.required(),
                          ),
                          SizedBox(height: 30),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Tidak ada akun ? ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
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
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
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
                                      content: Text(response),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text('Login'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
