import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia_app/screen/login_page.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    name: "name",
                    controller: nameController,
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
                        onPressed: () {
                          //pindah kehalaman login
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
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
