import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarMotivasi extends StatefulWidget {
  @override
  _DaftarMotivasiState createState() => _DaftarMotivasiState();
}

class _DaftarMotivasiState extends State<DaftarMotivasi> {
  List motivasiList = [];

  @override
  void initState() {
    super.initState();
    fetchMotivasi();
  }

  fetchMotivasi() async {
    var url = Uri.parse('http://localhost/vigenesia/api/Motivasi');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        motivasiList = items;
      });
    } else {
      throw Exception('Gagal memuat data dari server.');
    }
  }

  editMotivasi(String id, String isiMotivasi) async {
    var url = Uri.parse('http://localhost/vigenesia/api/dev/PUTmotivasi');
    var response =
        await http.put(url, body: {'id': id, 'isi_motivasi': isiMotivasi});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    fetchMotivasi(); // Memperbarui daftar motivasi setelah edit
  }

  deleteMotivasi(String id) async {
    var url = Uri.parse('http://localhost/vigenesia/api/dev/DELETEmotivasi');
    var response = await http.delete(url, body: {'id': id});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    fetchMotivasi(); // Memperbarui daftar motivasi setelah delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Motivasi'),
      ),
      body: ListView.builder(
        itemCount: motivasiList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(motivasiList[index]['isi_motivasi']),
            subtitle:
                Text('Tanggal Input: ' + motivasiList[index]['tanggal_input']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Tambahkan fungsi untuk edit motivasi di sini
                    editMotivasi(motivasiList[index]['id'],
                        motivasiList[index]['isi_motivasi']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Tambahkan fungsi untuk delete motivasi di sini
                    deleteMotivasi(motivasiList[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
