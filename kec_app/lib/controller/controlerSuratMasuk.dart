import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:kec_app/model/suratmasukService.dart';

class ControllerSM {

  final CollectionReference suratmasuk =
      FirebaseFirestore.instance.collection('suratmasuk');
      
  void createInputSurel(InputSurel inputSurel) async {
    final CollectionReference _suratmasuk =
        FirebaseFirestore.instance.collection('suratmasuk');

 

    final json = inputSurel.toJson();
    var querySnapshot = await _suratmasuk.orderBy("no", descending: true).limit(1).get();
    var maxId = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("no") : 0;
    json["no"] = maxId + 1;
    await _suratmasuk.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
  try {
    await suratmasuk.doc(id).delete();
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

Future<void> update(
    DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _no = TextEditingController();
  final TextEditingController _noBerkas = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _perihal = TextEditingController();
  final TextEditingController _tanggal_terima = TextEditingController();

  final CollectionReference suratmasuk =
      FirebaseFirestore.instance.collection('suratmasuk');

  if (documentSnapshot != null) {
    Timestamp timerstamp = documentSnapshot['tanggal'];
    Timestamp timestamp = documentSnapshot['tanggal_terima'];
    var date = timerstamp.toDate();
    var date1 = timestamp.toDate();
    var timers = DateFormat('yyyy-MM-dd').format(date);
    var times1 = DateFormat('yyyy-MM-dd').format(date1);

    _no.text = documentSnapshot['no'].toString();
    _noBerkas.text = documentSnapshot['no_berkas'];
    _alamat.text = documentSnapshot['alamat_pengirim'];
    _tanggal.text = timers.toString();
    _perihal.text = documentSnapshot['perihal'];
    _tanggal_terima.text = times1.toString();
  }

  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        var options = [
          'sudah diterima',
          'belum diterima',
        ];
        var _currentItemSelected = documentSnapshot['keterangan'];
        var _ket = documentSnapshot['keterangan'];
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
                keyboardType: TextInputType.text,
                controller: _noBerkas,
                decoration: const InputDecoration(
                  labelText: 'Nomor Berkas',
                ),
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _alamat,
                decoration: const InputDecoration(
                  labelText: 'Alamat Pengirim',
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
                controller: _tanggal,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tanggal',
                ),
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _perihal,
                decoration: const InputDecoration(
                  labelText: 'Perihal',
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
                controller: _tanggal_terima,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tanggal Terima',
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
                  labelText: 'Keterangan',
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
                      final String no_berkas = _noBerkas.text;
                      final String alamat = _alamat.text;
                      final DateTime tanggal = DateTime.parse(_tanggal.text);
                      final String perihal = _perihal.text;
                      final DateTime tanggal_terima =
                            DateTime.parse(_tanggal_terima.text);
                      final String keterangan = _ket;
                      if (no != null) {
                        await suratmasuk.doc(documentSnapshot.id).update({
                          "no": no,
                          "no_berkas": no_berkas,
                          "alamat_pengirim": alamat,
                          "tanggal": tanggal,
                          "perihal": perihal,
                          "tanggal_terima": tanggal_terima,
                          "keterangan": keterangan,
                        });
                        _no.text = '';
                        _noBerkas.text = '';
                        _alamat.text = '';
                        _tanggal.text = '';
                        _perihal.text = '';
                        _tanggal_terima.text = '';
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