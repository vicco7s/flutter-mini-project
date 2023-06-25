import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/model/PerjalananDinas/BuktiPJDService.dart';
import 'package:kec_app/page/perjalananDinas/buktiKegiatanPJD/formbuktiKegiatanPJD.dart';

class ControllerBuktiKegiatanPJD {
  final CollectionReference _buktiKegiatan =
      FirebaseFirestore.instance.collection('buktikegiatanpjd');

  void createInputBuktiPJD(BuktiKegiatan buktiKegiatan) async {
    final json = buktiKegiatan.toJson();
    var querySnapshot =
        await _buktiKegiatan.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    json["imageUrl"] = buktiKegiatan.imageUrl;
    await _buktiKegiatan.add(json);
  }

   Future<void> delete(String id, BuildContext context) async {
    try {
      await _buktiKegiatan.doc(id).delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Data Berhasil Di hapus')));
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
    final _dasar = TextEditingController();
    final _nip = TextEditingController();
    final _jabatan = TextEditingController();
    final _keperluan = TextEditingController();
    final _tempat = TextEditingController();
    final _hasil = TextEditingController();
    final _tgl_awal = TextEditingController();
    final _tgl_akhir = TextEditingController();

    Timestamp timerstamp = documentSnapshot['tgl_awal'];
    var date = timerstamp.toDate();
    var tanggal_awal = DateFormat('yyyy-MM-dd').format(date);

    Timestamp timerstamps = documentSnapshot['tgl_akhir'];
    var dates = timerstamps.toDate();
    var tanggal_akhir = DateFormat('yyyy-MM-dd').format(dates);

    _no.text = documentSnapshot['id'].toString();
    _dasar.text = documentSnapshot['dasar'];
    _nip.text = documentSnapshot['nip'];
    _jabatan.text = documentSnapshot['jabatan'];
    _keperluan.text = documentSnapshot['keperluan'];
    _tempat.text = documentSnapshot['tempat'];
    _tgl_awal.text = tanggal_awal.toString();
    _tgl_akhir.text = tanggal_akhir.toString();
    _hasil.text = documentSnapshot['hasil'];

    await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext ctx) {
      var _selectedName = documentSnapshot['nama'];
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
                    decoration: const InputDecoration(labelText: 'Nomor'),
                  ),
                  Padding(
                      padding: EdgeInsets.zero,
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("pegawai")
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot querySnapshot =
                                snapshot.data as QuerySnapshot;
                            List<DocumentSnapshot> items =
                                querySnapshot.docs;
                            List<DropdownMenuItem<String>> dropdownItems =
                                [];
                            for (var item in items) {
                              dropdownItems.add(DropdownMenuItem(
                                child: Text(item['nama']),
                                value: item['nama'],
                              ));
                            }
                            return Column(
                              children: [
                                // DropdownButtonFormField<String>(
                                //   dropdownColor: Colors.white,
                                //   isExpanded: true,
                                //   iconEnabledColor: Colors.black,
                                //   focusColor: Colors.black,
                                //   items: dropdownItems,
                                //   onChanged: (value) {
                                //     _selectedName = value!;
                                //     getJabatanAndNipByNama(value)
                                //         .then((result) {
                                //       _jabatan.text = result['jabatan']!;
                                //     });
                                //   },
                                //   decoration: const InputDecoration(
                                //     labelText: 'Nama',
                                //   ),
                                //   value: _selectedName,
                                // ),
                               
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _tempat,
                    decoration: const InputDecoration(labelText: 'Tempat'),
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    controller: _keperluan,
                    decoration:
                        const InputDecoration(labelText: 'Keperluan'),
                  ),
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
                    controller: _tgl_awal,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.date_range_outlined),
                      labelText: 'Tanggal Awal',
                    ),
                  ),
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
                    controller: _tgl_akhir,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.date_range_outlined),
                      labelText: 'Tanggal Akhir',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _dasar,
                    decoration: const InputDecoration(labelText: 'Dasar'),
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _hasil,
                    decoration: const InputDecoration(
                        labelText: 'Bukti Hasil Perjalanan Dinas'),
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
                          final String dasar = _dasar.text;
                          final String nama = _selectedName;
                          final String nip = _nip.text;
                          final String jabatan = _jabatan.text;
                          final String keperluan = _keperluan.text;
                          final String tempat = _tempat.text;
                          final DateTime firstDate =
                              DateTime.parse(_tgl_awal.text);
                          final DateTime endDate =
                              DateTime.parse(_tgl_akhir.text);
                          final String hasil = _hasil.text;
                          if (no != null) {
                            await _buktiKegiatan
                                .doc(documentSnapshot.id)
                                .update({
                              "id": no,
                              'dasar': dasar,
                              'nama': nama,
                              'nip': nip,
                              'jabatan': jabatan,
                              'keperluan': keperluan,
                              'tempat': tempat,
                              'tgl_awal': firstDate,
                              'tgl_akhir': endDate,
                              'hasil': hasil,
                            });
                            _no.text = '';
                            _selectedName = '';
                            _jabatan.text = '';
                            _nip.text = '';
                            _tempat.text = '';
                            _keperluan.text = '';
                            _tgl_awal.text = '';
                            _tgl_akhir.text = '';
                            _dasar.text = '';
                            _hasil.text = '';
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content:
                                        Text('Berhasil Memperbarui Data')));
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
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
