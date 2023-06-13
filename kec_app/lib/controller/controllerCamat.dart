import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class UpdateCamat {
  final CollectionReference _pdinas =
      FirebaseFirestore.instance.collection('pdinas');

  Future<void> update(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _no = TextEditingController();
    final TextEditingController _tujuan = TextEditingController();
    final TextEditingController _nama = TextEditingController();
    final TextEditingController _keperluan = TextEditingController();
    final TextEditingController _tanggal_mulai = TextEditingController();
    final TextEditingController _tanggal_berakhir = TextEditingController();

    if (documentSnapshot != null) {
      Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
      Timestamp timestamp = documentSnapshot['tanggal_berakhir'];
      var date = timerstamp.toDate();
      var date1 = timestamp.toDate();
      var timers = DateFormat('yyyy-MM-dd').format(date);
      var times1 = DateFormat('yyyy-MM-dd').format(date1);

      _no.text = documentSnapshot['id'].toString();
      _tujuan.text = documentSnapshot['tujuan'];
      _nama.text = documentSnapshot['nama'];
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
                TextField(
                  keyboardType: TextInputType.none,
                  controller: _nama,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.none,
                  controller: _tujuan,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Tujuan',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.none,
                  controller: _keperluan,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'keperluan',
                  ),
                ),
                DateTimeField(
                  enabled: false,
                  keyboardType: TextInputType.none,
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
                  enabled: false,
                  keyboardType: TextInputType.none,
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
                    filled: true,
                    fillColor: Colors.black26,
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
                        final String nama = _nama.text;
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
                          _nama.text = '';
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
}
