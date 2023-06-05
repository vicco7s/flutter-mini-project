import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class ControllerPegawai {
  final CollectionReference pegawai =
      FirebaseFirestore.instance.collection('pegawai');

  void createInputSurel(InputAsn inputAsn) async {
    final json = inputAsn.toJson();
    var querySnapshot =
        await pegawai.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await pegawai.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      await pegawai.doc(id).delete();
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
    final TextEditingController _id = TextEditingController();
    final TextEditingController _nama = TextEditingController();
    final TextEditingController _nip = TextEditingController();
    final TextEditingController _jabatan = TextEditingController();
    final TextEditingController _tmulaitugas = TextEditingController();
    final TextEditingController _tlahir = TextEditingController();
    final TextEditingController _telp = TextEditingController();
    final TextEditingController _alamat = TextEditingController();
    final TextEditingController _tempatlahir = TextEditingController();
    final TextEditingController _jumlahAnak = TextEditingController();

    if (documentSnapshot != null) {
      Timestamp timerstamp = documentSnapshot['tgl_lahir'];
      Timestamp timestamp = documentSnapshot['tgl_mulaitugas'];
      var date = timerstamp.toDate();
      var date1 = timestamp.toDate();
      var timers = DateFormat('yyyy-MM-dd').format(date);
      var times1 = DateFormat('yyyy-MM-dd').format(date1);

      _id.text = documentSnapshot['id'].toString();
      _nama.text = documentSnapshot['nama'];
      _nip.text = documentSnapshot['nip'].toInt().toString();
      _jabatan.text = documentSnapshot['jabatan'];
      _tmulaitugas.text = timers.toString();
      _tlahir.text = times1.toString();
      _telp.text = documentSnapshot['telpon'].toInt().toString();
      _alamat.text = documentSnapshot['alamat'];
      _tempatlahir.text = documentSnapshot['tempat_lahir'];
      _jumlahAnak.text = documentSnapshot['jumlah_anak'].toInt().toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          var _pakat = documentSnapshot['pangkat'];
          var _gol = documentSnapshot['golongan'];
          var _stas = documentSnapshot['status'];
          var _jk = documentSnapshot['jenis_kelamin'];
          var _peak = documentSnapshot['pendidikan_terakhir'];
          var _stper = documentSnapshot['status_pernikahan'];
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
                    controller: _id,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'No',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _nama,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _nip,
                    decoration: const InputDecoration(
                      labelText: 'Nip',
                    ),
                  ),
                  //jenis kelamin
                  DropdownButtonFormUpdates(
                    labelTitle: "Jenis Kelamin",
                    itemes: jenis_k.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _jk = newValueSelected;
                    },
                    values: documentSnapshot['jenis_kelamin'],
                  ),
                  //tgl lahir
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
                  controller: _tlahir,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.date_range_outlined),
                    labelText: 'Tanggal Lahir',
                  ),
                ),
                  //tempat lahir
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _tempatlahir,
                    decoration: const InputDecoration(
                      labelText: 'Tempat Lahir',
                    ),
                  ),
                  // tgl mulai tugas
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
                  controller: _tmulaitugas,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.date_range_outlined),
                    labelText: 'Tanggal Mulai Tugas',
                  ),
                ),
                  // alamat
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _alamat,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                    ),
                  ),
                  // pendidikan terakhir
                  DropdownButtonFormUpdates(
                    labelTitle: "pendidikan terakhir",
                    itemes: pendidikan_akhir.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _peak = newValueSelected;
                    },
                    values: documentSnapshot['pendidikan_terakhir'],
                  ),
                  //pangkat
                  DropdownButtonFormUpdates(
                    labelTitle: "Pangkat",
                    itemes: pangkat.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _pakat = newValueSelected;
                    },
                    values: documentSnapshot['pangkat'],
                  ),
                 // golongan
                  DropdownButtonFormUpdates(
                    labelTitle: "Golongan",
                    itemes: golongan.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _gol = newValueSelected;
                    },
                    values: documentSnapshot['golongan'],
                  ),
                  //jabatan
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _jabatan,
                    decoration: const InputDecoration(
                      labelText: 'Jabatan',
                    ),
                  ),
                  // status pegawai
                  DropdownButtonFormUpdates(
                    labelTitle: "Status",
                    itemes: status.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _stas = newValueSelected;
                    },
                    values: documentSnapshot['status'],
                  ),
                  //status perkawinan
                  DropdownButtonFormUpdates(
                    labelTitle: "Status Perkawinan",
                    itemes: s_perkawinan.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      var _currentItemSelected = newValueSelected!;
                      _stper= newValueSelected;
                    },
                    values: documentSnapshot['status_pernikahan'],
                  ),

                  //jumlah anak
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _jumlahAnak,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Anak',
                    ),
                  ),
                  //telp
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _telp,
                    decoration: const InputDecoration(
                      labelText: 'Telpon',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('Update'),
                        onPressed: () async {
                          final int no = int.parse(_id.text);
                          final String nama = _nama.text;
                          final int nip = int.parse(_nip.text);
                          final String pangkat = _pakat;
                          final String golongan = _gol;
                          final String jabatan = _jabatan.text;
                          final String status = _stas;
                          if (no != null) {
                            await pegawai.doc(documentSnapshot.id).update({
                              "id": no,
                              "nama": nama,
                              "nip": nip,
                              "pangkat": pangkat,
                              "golongan": golongan,
                              "jabatan": jabatan,
                              "status": status,
                            });
                            _id.text = '';
                            _nama.text = '';
                            _nip.text = '';
                            _pakat = '';
                            _gol = '';
                            _jabatan.text = '';
                            _stas = '';
                            Navigator.pop(context);
                            Navigator.pop(context);
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
              });
        });
  }
}
