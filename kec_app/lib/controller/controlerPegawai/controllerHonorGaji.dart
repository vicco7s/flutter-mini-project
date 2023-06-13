import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/model/Pegawai/gajihonorservice.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Pegawai/GajiHonorPegawai/FormGajiHonor.dart';

class ControllerGajiHonor {
  final CollectionReference gajihonor =
      FirebaseFirestore.instance.collection('gajihonorpegawai');

  void createInputPegawai(GajiHonor gajiHonor) async {
    final json = gajiHonor.toJson();
    var querySnapshot =
        await gajihonor.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await gajihonor.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      await gajihonor.doc(id).delete();
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
    final _no = TextEditingController();
    final _tanggal = TextEditingController();
    final _gajihonor = TextEditingController();
    final _bonus = TextEditingController();
    final _keterangan = TextEditingController();
    final _jabatan = TextEditingController();
    final _total = TextEditingController();

    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var tanggal = DateFormat('yyyy-MM-dd').format(date);

    _no.text = documentSnapshot['id'].toString();
    _tanggal.text = tanggal.toString();
    _gajihonor.text = documentSnapshot['gaji_honor'].toInt().toString();
    _bonus.text = documentSnapshot['bonus'].toInt().toString();
    _total.text = documentSnapshot['total'].toInt().toString();
    _keterangan.text = documentSnapshot['keterangan'];
    _jabatan.text = documentSnapshot['jabatan'];

    void updateTotal() {
      int gajiHonor = int.tryParse(_gajihonor.text) ?? 0;
      int bonus = int.tryParse(_bonus.text) ?? 0;
      int total = gajiHonor + bonus;
      _total.text = total.toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          var _selectedValue = documentSnapshot['nama'];
          var _nameValue = documentSnapshot['nama'];
          return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
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
                            decoration:
                                const InputDecoration(labelText: 'Nomor'),
                          ),
                          Padding(
                              padding: EdgeInsets.zero,
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("pegawai").where("status", isEqualTo: "NON ASN")
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    QuerySnapshot querySnapshot =
                                        snapshot.data as QuerySnapshot;
                                    List<DocumentSnapshot> items =
                                        querySnapshot.docs;
                                    List<DropdownMenuItem<String>>
                                        dropdownItems = [];
                                    for (var item in items) {
                                      dropdownItems.add(DropdownMenuItem(
                                        child: Text(item['nama']),
                                        value: item['nama'],
                                      ));
                                    }
                                    return Column(
                                      children: [
                                        DropdownButtonFormField<String>(
                                          dropdownColor: Colors.white,
                                          isExpanded: true,
                                          iconEnabledColor: Colors.black,
                                          focusColor: Colors.black,
                                          items: dropdownItems,
                                          onChanged: (value) {
                                            _selectedValue = value!;
                                            getJabatanByNama(value)
                                                .then((jabatan) {
                                              _jabatan.text =
                                                  jabatan; // Set nilai pada _jabatanController
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Nama',
                                          ),
                                          value: _selectedValue,
                                        ),
                                        TextField(
                                          keyboardType: TextInputType.none,
                                          controller: _jabatan,
                                          enabled: false,
                                          decoration: const InputDecoration(
                                              labelText: 'Jabatan'),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              )),
                          DateTimeField(
                            format: DateFormat('yyyy-MM-dd'),
                            onShowPicker:
                                (BuildContext context, DateTime? currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
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
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _gajihonor,
                            onChanged: (value) {
                              updateTotal();
                            },
                            decoration: const InputDecoration(
                                labelText: 'Pembayaran Honor'),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _bonus,
                            onChanged: (value) {
                              updateTotal();
                            },
                            decoration:
                                const InputDecoration(labelText: 'Bonus'),
                          ),
                          TextField(
                            keyboardType: TextInputType.none,
                            controller: _total,
                            enabled: false,
                            decoration:
                                const InputDecoration(labelText: 'Total'),
                          ),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            controller: _keterangan,
                            decoration:
                                const InputDecoration(labelText: 'Keterangan'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // background
                                  foregroundColor: Colors.blue, // foreground
                                ),
                                child: const Text('Update'),
                                onPressed: () async {
                                  final int no = int.parse(_no.text);
                                  final String nama = _selectedValue;
                                  final String jabatan = _jabatan.text;
                                  final DateTime tanggal =
                                      DateTime.parse(_tanggal.text);
                                  final int gajihonorpegawai =
                                      int.parse(_gajihonor.text);
                                  final int bonus = int.parse(_bonus.text);
                                  final int total = int.parse(_total.text);
                                  final String ket = _keterangan.text;
                                  if (no != null) {
                                    await gajihonor
                                        .doc(documentSnapshot.id)
                                        .update({
                                      "id": no,
                                      "nama": nama,
                                      "jabatan": jabatan,
                                      "tanggal": tanggal,
                                      "gaji_honor": gajihonorpegawai,
                                      "bonus": bonus,
                                      "total": total,
                                      "keterangan": ket,
                                    });
                                    _no.text = '';
                                    _selectedValue = '';
                                    _jabatan.text = '';
                                    _tanggal.text = '';
                                    _gajihonor.text = '';
                                    _bonus.text = '';
                                    _total.text = '';
                                    _keterangan.text = '';
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Berhasil Memperbarui Data')));
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
                                  backgroundColor: Colors.white, // background
                                  foregroundColor: Colors.red, // foreground
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                );
              });
        });
  }
}
