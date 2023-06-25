import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/components/DropDownSearch/DropdownSearchUpdate.dart';
import 'package:kec_app/model/pdinasservice.dart';
import 'package:kec_app/page/perjalananDinas/formpdinas.dart';

class ControllerPDinas {
  final CollectionReference _pdinas =
      FirebaseFirestore.instance.collection('pdinas');

  void createInputSurel(InputDinas inputDinas) async {
    final json = inputDinas.toJson();
    var querySnapshot =
        await _pdinas.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await _pdinas.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
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

  Future<void> update(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final _no = TextEditingController();
    final _jabatan = TextEditingController();
    final _nip = TextEditingController();
    final _tujuan = TextEditingController();
    final _keperluan = TextEditingController();
    final _tanggal_mulai = TextEditingController();
    final _tanggal_berakhir = TextEditingController();
    final _uangharian = TextEditingController();
    final _hari = TextEditingController();
    final _transport = TextEditingController();
    final _pulangpergi = TextEditingController();
    final _penginapan = TextEditingController();
    final _lamaMenginap = TextEditingController();
    final _total = TextEditingController();

    if (documentSnapshot != null) {
      Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
      Timestamp timestamp = documentSnapshot['tanggal_berakhir'];
      var date = timerstamp.toDate();
      var date1 = timestamp.toDate();
      var timers = DateFormat('yyyy-MM-dd').format(date);
      var times1 = DateFormat('yyyy-MM-dd').format(date1);

      _no.text = documentSnapshot['id'].toString();
      _jabatan.text = documentSnapshot['jabatan'];
      _nip.text = documentSnapshot['nip'];
      _tujuan.text = documentSnapshot['tujuan'];
      _keperluan.text = documentSnapshot['keperluan'];
      _tanggal_mulai.text = timers.toString();
      _tanggal_berakhir.text = times1.toString();
      _uangharian.text = documentSnapshot['uangharian'].toInt().toString();
      _hari.text = documentSnapshot['hari'].toInt().toString();
      _transport.text = documentSnapshot['transport'].toInt().toString();
      _pulangpergi.text = documentSnapshot['pulang_pergi'].toInt().toString();
      _penginapan.text = documentSnapshot['penginapan'].toInt().toString();
      _lamaMenginap.text = documentSnapshot['lama_menginap'].toInt().toString();
      _total.text = documentSnapshot['total'].toInt().toString();
    }

    var berkat = documentSnapshot['pulang_pergi'];

    void updateTotal() {
      int uangharian = int.tryParse(_uangharian.text) ?? 0;
      int hari = int.tryParse(_hari.text) ?? 0;
      int total_harian = uangharian * hari;

      int transport = int.tryParse(_transport.text) ?? 0;
      int pulangpergi = berkat == 'Pergi' ? 1 : 2;
      int total_transport = transport * pulangpergi;

      int penginapan = int.tryParse(_penginapan.text) ?? 0;
      int lama_menginap = int.tryParse(_lamaMenginap.text) ?? 0;
      int total_menginap = penginapan * lama_menginap;

      int total = total_harian + total_transport + total_menginap;
      _pulangpergi.text = pulangpergi.toString();
      _total.text = total.toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          var berangkat = ["Pergi", "Pulang Pergi"];
          var _selectedValue = documentSnapshot['nama'];
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
                                List<String> namaList = items
                                    .map((item) => item['nama'] as String)
                                    .toList();
                                // for (var item in items) {
                                //   dropdownItems.add(DropdownMenuItem(
                                //     child: Text(item['nama']),
                                //     value: item['nama'],
                                //   ));
                                // }
                                return DropdownSearchUpdate(
                                  itemes: namaList,
                                  textDropdownPorps: 'Nama',
                                  hintTextProps: 'Search Nama...',
                                  onChage: (value) {
                                    _selectedValue = value!;
                                    getJabatanAndNipByNama(value)
                                        .then((result) {
                                      _jabatan.text = result['jabatan']!;
                                      _nip.text = result['nip']!;
                                    });
                                  },
                                  selectedItems: _selectedValue,
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
                        onShowPicker:
                            (BuildContext context, DateTime? currentValue) {
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
                        onShowPicker:
                            (BuildContext context, DateTime? currentValue) {
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _uangharian,
                                onChanged: (value) {
                                  updateTotal();
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Uang Harian',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _hari,
                              onChanged: (value) {
                                updateTotal();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Hari',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _transport,
                                decoration: const InputDecoration(
                                  labelText: 'Uang Transportasi',
                                ),
                                onChanged: (value) {
                                  updateTotal();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              iconEnabledColor: Colors.black,
                              focusColor: Colors.black,
                              items: berangkat.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                berkat = newValueSelected!;
                                updateTotal();
                              },
                              value: (berkat == 1 ? 'Pergi' : 'Pulang Pergi'),
                              decoration: const InputDecoration(
                                labelText: 'Opsi',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _penginapan,
                                decoration: const InputDecoration(
                                  labelText: 'Uang Menginap',
                                ),
                                onChanged: (value) {
                                  updateTotal();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _lamaMenginap,
                              decoration: const InputDecoration(
                                labelText: 'Lama',
                              ),
                              onChanged: (value) {
                                updateTotal();
                              },
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.none,
                        enabled: false,
                        controller: _total,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Total',
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
                              final String nama = _selectedValue;
                              final String nip = _nip.text;
                              final String jabatan = _jabatan.text;
                              final String tujuan = _tujuan.text;
                              final String keperluan = _keperluan.text;
                              final DateTime tanggal_mulai =
                                  DateTime.parse(_tanggal_mulai.text);
                              final DateTime tanggal_berakhir =
                                  DateTime.parse(_tanggal_berakhir.text);
                              final int uangharian =
                                  int.parse(_uangharian.text);
                              final int hari = int.parse(_hari.text);
                              final int transport = int.parse(_transport.text);
                              final int pulang_pergi =
                                  int.parse(_pulangpergi.text);
                              final int penginapan =
                                  int.parse(_penginapan.text);
                              final int lama_menginap =
                                  int.parse(_lamaMenginap.text);
                              final int jumlah_total = int.parse(_total.text);
                              if (no != null) {
                                await _pdinas.doc(documentSnapshot.id).update({
                                  "id": no,
                                  "nama": nama,
                                  "nip": nip,
                                  "jabatan": jabatan,
                                  "tujuan": tujuan,
                                  "keperluan": keperluan,
                                  "tanggal_mulai": tanggal_mulai,
                                  "tanggal_berakhir": tanggal_berakhir,
                                  'uangharian': uangharian,
                                  'hari': hari,
                                  'transport': transport,
                                  'pulang_pergi': pulang_pergi,
                                  'penginapan': penginapan,
                                  'lama_menginap': lama_menginap,
                                  'total': jumlah_total,
                                });
                                _no.text = '';
                                _selectedValue = '';
                                _nip.text = '';
                                _jabatan.text = '';
                                _tujuan.text = '';
                                _keperluan.text = '';
                                _tanggal_mulai.text = '';
                                _tanggal_berakhir.text = '';
                                _uangharian.text = '';
                                _hari.text = '';
                                _transport.text = '';
                                _pulangpergi.text = '';
                                _penginapan.text = '';
                                _lamaMenginap.text = '';
                                _total.text = '';
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
                              backgroundColor: Colors.red, // background
                              foregroundColor: Colors.white, // foreground
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
