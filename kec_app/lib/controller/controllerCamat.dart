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

    _no.text = documentSnapshot['id'].toString();

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          var options = [
            'diterima',
            'belum dikonfirmasi',
          ];
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
                  value: _ket,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                        final String status = _ket;
                        if (no != null) {
                          await _pdinas.doc(documentSnapshot.id).update({
                            'id': no,
                            "status": status,
                          });
                          _no.text = '';
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
