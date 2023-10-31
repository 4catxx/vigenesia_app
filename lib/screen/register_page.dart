import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia_app/screen/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<String> registerUser(
      String nama, String profesi, String email, String password) async {
    final apiUrl = Uri.parse('http://127.0.0.1:80/vigenesia/api/registrasi');
    final response = await http.post(
      apiUrl,
      body: {
        'nama': nama,
        'profesi': profesi,
        'email': email,
        'password': password
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
      // Jika status kode HTTP adalah 400, kembalikan pesan yang sesuai
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
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Buat Akun",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 50),
                  FormBuilderTextField(
                    name: "nama",
                    controller: namaController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Nama"),
                  ), //akhir textediting Nama
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    name: "profesi",
                    controller: profesiController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Profesi"),
                  ), //akhir textediting Profesi

                  // awal widget texteditting email
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    name: "email",
                    controller: emailController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Email"),
                  ),
                  //akhir widget texteditting email
                  // awal widget texteditting password
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    obscureText:
                        true, // <-- Buat bikin setiap inputan jadi bintang "*"
                    name: "password",
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Password"),
                  ),
                  //akhir widget texteditting password
                  //awal widget/navigasi daftar
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          String response = await registerUser(
                              namaController.text,
                              profesiController.text,
                              emailController.text,
                              passwordController.text);

                          if (response == "success") {
                            //pindah kehalaman login
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response),
                              ),
                            );
                          }
                        },
                        child: Text("Daftar")),
                  ),
                  //akhir widget navigasi daftar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
