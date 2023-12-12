import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final namaController = TextEditingController();
  final profesiController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    if (id != null) {
      var response = await http.get(
        Uri.parse('http://localhost/vigenesia/api/user?iduser=$id'),
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          namaController.text = userData['nama'];
          profesiController.text = userData['profesi'];
          emailController.text = userData['email'];
        });
      } else {}
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan format email yang valid')),
      );
      return;
    }

    if (id != null) {
      var response = await http.put(
        Uri.parse('http://localhost/vigenesia/api/PUTprofile'),
        body: {
          'iduser': id.toString(),
          'nama': namaController.text,
          'profesi': profesiController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body)['message'];
        if (message == "user berhasil updated profile baru.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil melakukan update')),
          );
          await Future.delayed(Duration(seconds: 3));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else if (message == "Some problems occurred, please try again.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan, Mohon coba lagi')),
          );
        } else if (message == "Provide at least one user info to update.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data profile tidak ditemukan')),
          );
        }
      } else {
        // Handle failure
      }
    }
  }

  bool isValidEmail(String input) {
    final RegExp regex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: profesiController,
              decoration: InputDecoration(
                labelText: 'Profesi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggle,
                ),
              ),
              obscureText: _obscureText,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
