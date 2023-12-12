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
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                String tempName = members[index]['nama'];
                String tempProfession = members[index]['profesi'];
                String tempRoleId = members[index]['role_id'] ?? '1';
                String tempIsActive = members[index]['is_active'] ?? '1';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Member'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                tempName = value;
                              },
                              controller: TextEditingController(
                                text: members[index]['nama'],
                              ),
                            ),
                            TextField(
                              onChanged: (value) {
                                tempProfession = value;
                              },
                              controller: TextEditingController(
                                text: members[index]['profesi'],
                              ),
                            ),
                            DropdownButton<String>(
                              value: tempRoleId,
                              items: <String>['1', '2'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child:
                                      Text(value == '1' ? 'Admin' : 'Member'),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  tempRoleId = newValue!;
                                });
                              },
                            ),
                            DropdownButton<String>(
                              value: tempIsActive,
                              items: <String>['1', '2'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                      value == '1' ? 'Active' : 'Inactive'),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  tempIsActive = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Update'),
                          onPressed: () {
                            setState(() {
                              members[index]['nama'] = tempName;
                              members[index]['profesi'] = tempProfession;
                              members[index]['role_id'] = tempRoleId;
                              members[index]['is_active'] = tempIsActive;
                            });
                            Navigator.of(context).pop();
                            editMember(
                              members[index]['id'],
                              tempName,
                              tempProfession,
                              tempRoleId,
                              tempIsActive,
                            );
                          },
                        ),
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
