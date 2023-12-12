import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminViewProfile extends StatefulWidget {
  @override
  _AdminViewProfileState createState() => _AdminViewProfileState();
}

class _AdminViewProfileState extends State<AdminViewProfile> {
  var profileData;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    if (id != null) {
      var response = await http
          .get(Uri.parse('http://localhost/vigenesia/api/user?iduser=$id'));

      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
        backgroundColor: Colors.blue,
      ),
      body: profileData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: profileData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nama: ' + (profileData[index]['nama'] ?? 'N/A'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email: ' + (profileData[index]['email'] ?? 'N/A'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Profesi: ' +
                              (profileData[index]['profesi'] ?? 'N/A'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Role: ' +
                              ((profileData[index]['role_id'] == '2')
                                  ? 'Member'
                                  : 'Non-Member'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Status: ' +
                              ((profileData[index]['is_active'] == '1')
                                  ? 'Active'
                                  : 'Inactive'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tanggal Input: ' +
                              (profileData[index]['tanggal_input'] ?? 'N/A'),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
