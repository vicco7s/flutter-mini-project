import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DetailPdinas extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPdinas({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    Timestamp timerstamps = documentSnapshot['tanggal_berakhir'];
    var date = timerstamp.toDate();
    var dates = timerstamps.toDate();
    var timers = DateFormat.yMMMMd().format(date);
    var timer = DateFormat.yMMMMd().format(dates);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Perjalanan Dinas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 15.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                )),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Text(
                        "No :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['id'].toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Nama :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['nama'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tujuan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['tujuan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Keperluan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['keperluan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tanggal Mulai :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        timers.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tanggal Berakhir :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        timer.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Status :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: (documentSnapshot['status'] == 'diterima')
                          ? Text(
                              documentSnapshot['status'],
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                            )
                          : Text(
                              documentSnapshot['status'],
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  _update(documentSnapshot, context);
                },
                child: const Text("Update"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _delete(documentSnapshot.id, context);
                },
                child: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

Future<void> _delete(String id, BuildContext context) async {
  final CollectionReference _pdinas =
      FirebaseFirestore.instance.collection('pdinas');
  try {
    await _pdinas.doc(id).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Data Berhasil Di hapus')));
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  } on StateError catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Data tidak berhasil di hapus')));
  }
}

Future<void> _update(
    DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _no = TextEditingController();
  final TextEditingController _tujuan = TextEditingController();
  final TextEditingController _keperluan = TextEditingController();
  final TextEditingController _tanggal_mulai = TextEditingController();
  final TextEditingController _tanggal_berakhir = TextEditingController();

  final CollectionReference _pdinas =
      FirebaseFirestore.instance.collection('pdinas');

  if (documentSnapshot != null) {
    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    Timestamp timestamp = documentSnapshot['tanggal_berakhir'];
    var date = timerstamp.toDate();
    var date1 = timestamp.toDate();
    var timers = DateFormat('yyyy-MM-dd').format(date);
    var times1 = DateFormat('yyyy-MM-dd').format(date1);

    _no.text = documentSnapshot['id'].toString();
    _tujuan.text = documentSnapshot['tujuan'];
    _keperluan.text = documentSnapshot['keperluan'];
    _tanggal_mulai.text = timers.toString();
    _tanggal_berakhir.text = times1.toString();
  }

  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        var options = [
          'diterima',
          'belum diterima',
        ];
        var _currentItemSelected = documentSnapshot['status'];
        var _ket = documentSnapshot['status'];
        var _selectedValue = documentSnapshot['nama'];
        var _nameValue = documentSnapshot['nama'];
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.none,
                controller: _no,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Nomor'),
              ),
              Padding(
                  padding: EdgeInsets.zero,
                  child: FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection("pegawai").get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;
                        List<DocumentSnapshot> items = querySnapshot.docs;
                        List<DropdownMenuItem<String>> dropdownItems = [];
                        for (var item in items) {
                          dropdownItems.add(DropdownMenuItem(
                            child: Text(item['nama']),
                            value: item['nama'],
                          ));
                        }
                        return DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          iconEnabledColor: Colors.black,
                          focusColor: Colors.black,
                          items: dropdownItems,
                          onChanged: (value) {
                            var _selectedValue = value!;
                            _nameValue = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Nama',
                          ),
                          value: _selectedValue,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )),
              TextField(
                keyboardType: TextInputType.text,
                controller: _tujuan,
                decoration: const InputDecoration(
                  labelText: 'Tujuan',
                ),
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _keperluan,
                decoration: const InputDecoration(
                  labelText: 'keperluan',
                ),
              ),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd'),
                onShowPicker: (BuildContext context, DateTime? currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                },
                controller: _tanggal_mulai,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tanggal Mulai',
                ),
              ),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd'),
                onShowPicker: (BuildContext context, DateTime? currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                },
                controller: _tanggal_berakhir,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tanggal Berakhir',
                ),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                isExpanded: true,
                iconEnabledColor: Colors.black,
                focusColor: Colors.black,
                items: options.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(
                      dropDownStringItem,
                    ),
                  );
                }).toList(),
                onChanged: (newValueSelected) {
                  var _currentItemSelected = newValueSelected!;
                  _ket = newValueSelected;
                },
                value: _currentItemSelected,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final int no = int.parse(_no.text);
                      final String nama = _nameValue;
                      final String tujuan = _tujuan.text;
                      final String keperluan = _keperluan.text;
                      final DateTime tanggal_mulai =
                          DateTime.parse(_tanggal_mulai.text);
                      final DateTime tanggal_berakhir =
                          DateTime.parse(_tanggal_berakhir.text);
                      final String status = _ket;
                      if (no != null) {
                        await _pdinas.doc(documentSnapshot.id).update({
                          "no": no,
                          "nama": nama,
                          "tujuan": tujuan,
                          "keperluan": keperluan,
                          "tanggal_mulai": tanggal_mulai,
                          "tanggal_berakhir": tanggal_berakhir,
                          "status": status,
                        });
                        _no.text = '';
                        _nameValue = '';
                        _tujuan.text = '';
                        _keperluan.text = '';
                        _tanggal_mulai.text = '';
                        _tanggal_berakhir.text = '';
                        _ket = '';
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Berhasil Memperbarui Data')));
                      }
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: (() => Navigator.pop(context)),
                    child: const Text("Cencel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
