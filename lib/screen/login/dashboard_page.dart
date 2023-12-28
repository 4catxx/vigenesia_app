import 'package:flutter/material.dart';
import 'package:vigenesia_app/screen/login/tambah_motivasi.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;
import 'motivasi_login.dart';
import 'semua_motivasi.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/4207.png', height: 200.0),
            SizedBox(height: 20),
            Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
