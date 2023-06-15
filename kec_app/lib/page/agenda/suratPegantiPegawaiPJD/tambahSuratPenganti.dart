import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerSurat/ControllerSuratPenganti.dart';
import 'package:kec_app/model/surat/suratpenggantiService.dart';

import '../../../components/inputborder.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FormSuratPenganti extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const FormSuratPenganti({super.key, required this.documentSnapshot});

  @override
  State<FormSuratPenganti> createState() => _FormSuratPengantiState();
}

class _FormSuratPengantiState extends State<FormSuratPenganti> {
  late DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    super.initState();
    documentSnapshot = widget.documentSnapshot;
  }

  final _formkey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _nama_pengganti = TextEditingController();
  final _jabatan = TextEditingController();
  final _tanggal_surat = TextEditingController();
  final _tanggal_perjalanan = TextEditingController();
  final _alasan = TextEditingController();

  String _selectedValue = "";

  final dataSuratPengganti = ControllerSuratpengganti();

  @override
  Widget build(BuildContext context) {
    _nama_pengganti.text = documentSnapshot['nama'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Input Surat Pengganti'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                  child: FutureBuilder(
                      future: firestore.collection("pegawai").get(),
                      builder: ((context, snapshot) {
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
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  right: 10.0,
                                  left: 10.0,
                                ),
                                child: DropdownButtonForms(
                                    itemes: dropdownItems,
                                    onchage: ((value) {
                                      setState(() {
                                        _selectedValue = value!;
                                        getJabatanByNama(value).then((jabatan) {
                                          setState(() {
                                            _jabatan.text =
                                                jabatan; // Set nilai pada _jabatanController
                                          });
                                        }); // Panggil fungsi untuk mencari jabatan
                                      });
                                    }),
                                    labelTitle: "Nama Lengkap",
                                    validators: (value) => (value == null
                                        ? 'Nama tidak boleh kosong !'
                                        : null)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  right: 10.0,
                                  left: 10.0,
                                ),
                                child: TextFormFields(
                                  controllers: _jabatan,
                                  labelTexts: "Jabatan",
                                  keyboardtypes: TextInputType.none,
                                  enableds: false,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }))),

              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormFields(
                  controllers: _nama_pengganti,
                  enableds: false,
                  labelTexts: 'Nama Pengganti',
                  keyboardtypes: TextInputType.text,
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Nama Lengkap Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: DateTimeField(
                  format: DateFormat('yyyy-MM-dd'),
                  onShowPicker: (BuildContext context, DateTime? currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                  controller: _tanggal_surat,
                  validator: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal Surat Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.date_range_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // hintText: "Masukan Email",
                    fillColor: Colors.white70,
                    labelText: 'Tanggal Surat',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: DateTimeField(
                  format: DateFormat('yyyy-MM-dd'),
                  onShowPicker: (BuildContext context, DateTime? currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                  controller: _tanggal_perjalanan,
                  validator: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal Perjalanan Dinas Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.date_range_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // hintText: "Masukan Email",
                    fillColor: Colors.white70,
                    labelText: 'Tanggal Perjalanan Dinas',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormFields(
                  controllers: _alasan,
                  labelTexts: 'Alasan Penggantian',
                  keyboardtypes: TextInputType.text,
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Alasan Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                ),
              ),

              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      final suratPengganti = SuratPenggantiService(
                        nama: _selectedValue,
                        nama_pengganti: _nama_pengganti.text, 
                        jabatan: _jabatan.text,
                        tanggal_surat: DateTime.parse(_tanggal_surat.text),
                        tanggal_perjalanan:
                            DateTime.parse(_tanggal_perjalanan.text),
                        alasan: _alasan.text,
                        
                      );
                      dataSuratPengganti.createInputSuratBatal(documentSnapshot, suratPengganti);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Berhasil Menambahkan Data')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Gagal Menambahkan Data')));
                    }
                  },
                  child: Text('Submit'))

            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getJabatanByNama(String value) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('pegawai')
      .where('nama', isEqualTo: value)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    String jabatan = querySnapshot.docs[0]['jabatan'];
    return jabatan;
  } else {
    return 'Jabatan tidak ditemukan';
  }
}
