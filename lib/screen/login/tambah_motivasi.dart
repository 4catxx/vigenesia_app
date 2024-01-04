import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TambahMotivasi extends StatefulWidget {
  @override
  _TambahMotivasiState createState() => _TambahMotivasiState();
}

class _TambahMotivasiState extends State<TambahMotivasi> {
  final _formKey = GlobalKey<FormState>();
  final _isiMotivasiController = TextEditingController();

  @override
  void dispose() {
    _isiMotivasiController.dispose();
    super.dispose();
  }

  Future<int?> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    return id; // Mengembalikan null jika id adalah null
  }

  void tambahMotivasi() async {
    int? idUser = await getIdUser();
    if (idUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maaf kami tidak bisa menemukan id anda')),
      );
      return;
    }
    var url = Uri.parse('https://vigenesia.pw/api/dev/POSTmotivasi');
    var response = await http.post(url, body: {
      'isi_motivasi': _isiMotivasiController.text,
      'iduser': idUser.toString(),
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Motivasi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/4207.png', height: 200.0),
            SizedBox(height: 20),
            Text(
              'Tambah Motivasi Baru!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _isiMotivasiController,
                      decoration: InputDecoration(labelText: 'Isi Motivasi'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan isi motivasi';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          tambahMotivasi();
                        }
                      },
                      child: Text('Tambah Motivasi'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
