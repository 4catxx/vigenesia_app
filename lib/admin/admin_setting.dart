import 'package:flutter/material.dart';
import 'package:vigenesia_app/screen/login/tambah_motivasi.dart';
import '../screen/login_page.dart';
//import '../motivasi_page.dart';
import 'package:http/http.dart' as http;
import 'admin_motivasi.dart';
import 'admin_dashboard.dart';
//import 'profile_view.dart';
import 'admin_profile_edit.dart';
import 'admin_motivasi.dart';
import 'user_member.dart';
import 'admin_profile_view.dart';

class Admin_Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                'View Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminViewProfile()),
                );
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
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
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
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
                      MaterialPageRoute(builder: (context) => AdminMotivasi()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Semua Motivasi'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminMotivasi()),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Member'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin_Setting()),
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
