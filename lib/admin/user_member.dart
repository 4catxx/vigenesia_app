import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  List members = [];

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost/vigenesia/api/user'),
      );

      if (response.statusCode == 200) {
        var items = json.decode(response.body);
        setState(() {
          members = items;
        });
      } else {
        throw Exception('Gagal memuat data dari server.');
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  Future<void> editMember(String id, String newName, String newProfession,
      String newRoleId, String newIsActive) async {
    try {
      var url = Uri.parse('http://localhost/vigenesia/api/PUTprofile');

      var response = await http.put(
        url,
        body: {
          'id': id,
          'nama': newName,
          'profesi': newProfession,
          'role_id': newRoleId,
          'is_active': newIsActive,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Jika perlu, tambahkan logika tambahan setelah pembaruan berhasil
        print('Member updated successfully');
      } else {
        // Handle kasus ketika update gagal
        print('Failed to update member');
      }

      // Panggil kembali fetchMembers untuk memperbarui tampilan setelah pembaruan
      fetchMembers();
    } catch (e) {
      print('Failed to make PUT request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Member'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(members[index]['nama']),
            subtitle: Text('Profesi: ' + members[index]['profesi']),
          );
        },
      ),
    );
  }
}
