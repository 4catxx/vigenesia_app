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
          );
        },
      ),
    );
  }
}
