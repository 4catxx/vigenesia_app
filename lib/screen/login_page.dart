import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register_page.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dashboard_page.dart';
import 'home_page.dart';

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

  @override
  Widget build(BuildContext context) {
    title:
    'First App';
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.home),
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
                    Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),

                    SizedBox(height: 20), //awal script textfield email
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
                                    labelText: "Email"),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators
                                      .required(), // Bidang harus diisi
                                  FormBuilderValidators
                                      .email(), // Memastikan bahwa email dalam format yang benar
                                ]),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                obscureText: _obscureText,
                                name: "password",
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(),
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Berdasarkan kondisi, tampilkan ikon yang sesuai
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      // Ubah nilai _obscureText saat tombol ditekan
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                                validator: FormBuilderValidators.required(),
                              ), //akhir tahap 3
                              SizedBox(height: 30),
                              Text.rich(
                                TextSpan(children: [
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
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new Register()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueAccent),
                                  ),
                                ]),
                              ), //akhir tahap 4
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    // Validasi berhasil, lakukan tindakan login di sini
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Dashboard()),
                                    );
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
              ))),
    );
  }
}
