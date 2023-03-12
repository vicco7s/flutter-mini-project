
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/model/suratkeluarService.dart';

class ControllerSK {
  final CollectionReference suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');

  void createOutputSurel(OutputSurel outputSurel) async {
    final CollectionReference<Map<String, dynamic>> _suratkeluar =
        FirebaseFirestore.instance.collection('suratkeluar');
    final json = outputSurel.toJson();
    var querySnapshot =
        await _suratkeluar.orderBy("no", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("no") : 0;
    json["no"] = maxId + 1;
    await _suratkeluar.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
  try {
    await suratkeluar.doc(id).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green, content: Text('Data Berhasil Di hapus')));
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
  final CollectionReference suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');
  if (documentSnapshot != null) {
    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var timers = DateFormat('yyyy-MM-dd').format(date);

    _no.text = documentSnapshot['no'].toString();
    _noBerkas.text = documentSnapshot['no_berkas'];
    _alamat.text = documentSnapshot['alamat_penerima'];
    _tanggal.text = timers.toString();
    _perihal.text = documentSnapshot['perihal'];
  }

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext ctx) {
      var options = [
        'sudah dikirim',
        'belum dikirim',
      ];
      var _currentItemSelected = documentSnapshot['keterangan'];
      var ket = documentSnapshot['keterangan'];
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
                ket = newValueSelected;
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
                    if (no != null) {
                      await suratkeluar.doc(documentSnapshot.id).update({
                        "no": no,
                        "no_berkas": no_berkas,
                        "alamat_penerima": alamat,
                        "tanggal": tanggal,
                        "perihal": perihal,
                        "keterangan": ket
                      });
                      _no.text = '';
                      _noBerkas.text = '';
                      _alamat.text = '';
                      _tanggal.text = '';
                      _perihal.text = '';
                      ket = '';
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