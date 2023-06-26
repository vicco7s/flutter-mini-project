import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/util/OptionDropDown.dart';

class UpdatePdinasUser {
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
          var _konkirim = documentSnapshot['konfirmasi_kirim'];
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
                
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  iconEnabledColor: Colors.black,
                  focusColor: Colors.black,
                  items: konfir_kirim.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValueSelected) {
                    var _currentItemSelected = newValueSelected!;
                    _konkirim = newValueSelected;
                  },
                  value: _konkirim,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Konfirmasi pengiriman',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Kirim'),
                      onPressed: () async {
                        final int no = int.parse(_no.text);
                        final String status = _konkirim;
                        if (no != null) {
                          await _pdinas.doc(documentSnapshot.id).update({
                            'id': no,
                            "konfirmasi_kirim": status,
                          });
                          _no.text = '';
                          _konkirim = '';
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('konfirmasi berhasil diubah silahkan kirim bukti PJD')));
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
