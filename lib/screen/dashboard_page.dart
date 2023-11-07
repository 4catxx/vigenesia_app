import 'package:flutter/material.dart';
import 'login_page.dart';
import 'motivasi_page.dart';
import 'package:http/http.dart' as http;

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
                  onTap: () async {
                    var url = Uri.parse(
                        'http://localhost/vigenesia/api/dev/POSTmotivasi');
                    var response = await http
                        .post(url, body: {'key1': 'value1', 'key2': 'value2'});
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  },
                ),
                ListTile(
                  title: Text('Hapus Motivasi'),
                  onTap: () async {
                    var url = Uri.parse(
                        'http://localhost/vigenesia/api/dev/DELETEmotivasi');
                    var response = await http.delete(url);
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  },
                ),
                ListTile(
                  title: Text('Edit Motivasi'),
                  onTap: () async {
                    var url = Uri.parse(
                        'http://localhost/vigenesia/api/dev/PUTmotivasi');
                    var response = await http
                        .put(url, body: {'key1': 'value1', 'key2': 'value2'});
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  },
                ),
                ListTile(
                  title: Text('Daftar Motivasi'),
                  onTap: () async {
                    var url =
                        Uri.parse('http://localhost/vigenesia/api/Motivasi');
                    var response = await http.get(url);
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
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
