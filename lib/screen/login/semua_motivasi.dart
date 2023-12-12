import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../login_page.dart';
import 'setting_page.dart';
import 'dashboard_page.dart';
import 'motivasi_login.dart';
import 'tambah_motivasi.dart';

class SemuaMotivasi extends StatefulWidget {
  @override
  _SemuaMotivasiState createState() => _SemuaMotivasiState();
}

class _SemuaMotivasiState extends State<SemuaMotivasi> {
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
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Motivasi'),
              children: <Widget>[
                ListTile(
                  title: Text('Tambah Motivasi'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahMotivasi()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Daftar Motivasi'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaftarMotivasi()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Semua Motivasi'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SemuaMotivasi()),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting_profile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Tambahkan fungsi logout di sini
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
