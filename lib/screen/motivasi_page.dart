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
  List<Map<String, dynamic>> motivasiList = [];
  Map<String, dynamic> userMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchMotivasi();
  }

  fetchUsers() async {
    final response = await http.get(Uri.parse('https://vigenesia.pw/api/user'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        for (var item in jsonResponse) {
          userMap[item['iduser'].toString()] = item['nama'];
        }
      } else {
        throw Exception('Failed to load users');
      }
    } else {
      throw Exception('Failed to load users');
    }
  }

  fetchMotivasi() async {
    final response =
        await http.get(Uri.parse('https://vigenesia.pw/api/Motivasi'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        for (var item in jsonResponse) {
          String namaPembuat = userMap[item['iduser'].toString()] ?? 'Unknown';
          setState(() {
            motivasiList.add({
              'isi_motivasi': item['isi_motivasi'],
              'dibuat_oleh': namaPembuat
            });
          });
        }
        setState(() {
          isLoading = false;
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: motivasiList.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(motivasiList[index]['isi_motivasi']),
                  subtitle: Text(
                      'Dibuat oleh: ' + motivasiList[index]['dibuat_oleh']),
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
