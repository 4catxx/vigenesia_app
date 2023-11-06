import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'register_page.dart';
import 'menu_page.dart';

class HalamanMotivasi extends StatefulWidget {
  @override
  _HalamanMotivasiState createState() => _HalamanMotivasiState();
}

class _HalamanMotivasiState extends State<HalamanMotivasi> {
  List<String> motivasiList = ['Loading...'];

  @override
  void initState() {
    super.initState();
    fetchMotivasi();
  }

  fetchMotivasi() async {
    final response =
        await http.get(Uri.parse('http://localhost/vigenesia/api/Motivasi'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        setState(() {
          motivasiList =
              jsonResponse.map<String>((item) => item['isi_motivasi']).toList();
        });
      } else {
        throw Exception('Failed to load motivasi');
      }
    } else {
      throw Exception('Failed to load motivasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView.builder(
        itemCount: motivasiList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(motivasiList[index]),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu Utama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Daftar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Motivasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HalamanMotivasi()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
