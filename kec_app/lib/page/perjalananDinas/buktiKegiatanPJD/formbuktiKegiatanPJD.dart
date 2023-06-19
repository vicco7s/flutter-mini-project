import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/components/DateTimeFields.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerBuktiKegiatanPJD.dart';
import 'package:kec_app/model/PerjalananDinas/BuktiPJDService.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FormBuktiKegiatanPJD extends StatefulWidget {
  const FormBuktiKegiatanPJD({super.key});

  @override
  State<FormBuktiKegiatanPJD> createState() => _FormBuktiKegiatanPJDState();
}

class _FormBuktiKegiatanPJDState extends State<FormBuktiKegiatanPJD> {
  final _formkey = GlobalKey<FormState>();
  final _dasar = TextEditingController();
  final _nip = TextEditingController();
  final _jabatan = TextEditingController();
  final _keperluan = TextEditingController();
  final _tempat = TextEditingController();
  final _firstDate = TextEditingController();
  final _endDate = TextEditingController();
  final _hasil = TextEditingController();

  String _selectedName = "";

  final dataBuktiKegiatan = ControllerBuktiKegiatanPJD();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('input Data Kegiatan'),
        centerTitle: true,
        elevation: 0,
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
                                      _selectedName = value!;
                                      getJabatanAndNipByNama(value)
                                          .then((result) {
                                        setState(() {
                                          _jabatan.text = result['jabatan']!;
                                          _nip.text = result[
                                              'nip']!; // Set nilai pada _jabatanController
                                        });
                                      }); // Panggil fungsi untuk mencari jabatan
                                    });
                                  }),
                                  labelTitle: "Nama",
                                  validators: (value) => (value == null
                                      ? 'Nama tidak boleh kosong !'
                                      : null)),
                            ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    })),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _keperluan,
                  labelTexts: "Keperluan",
                  keyboardtypes: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _tempat,
                  labelTexts: "Tempat/Instansi Tujuan",
                  keyboardtypes: TextInputType.text,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: DateTimeFields(
                  controllers: _firstDate,
                  tanggalText: 'Tanggal Mulai',
                  validators: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal Mulai Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: DateTimeFields(
                  controllers: _endDate,
                  tanggalText: 'Tanggal Berkahir',
                  validators: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal Berakhir Tidak Boleh Kosong !";
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
                child: TextFormFields(
                  controllers: _dasar,
                  labelTexts: "Dasar",
                  keyboardtypes: TextInputType.multiline,
                  maxlines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _hasil,
                  labelTexts: "Hasil Perjalanan Dinas",
                  keyboardtypes: TextInputType.multiline,
                  maxlines: 3,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      final buktiKegiatan = BuktiKegiatan(
                        dasar: _dasar.text,
                        nama: _selectedName,
                        nip: _nip.text,
                        jabatan: _jabatan.text,
                        tempat: _tempat.text,
                        keperluan: _keperluan.text,
                        firstDate: DateTime.parse(_firstDate.text),
                        endDate: DateTime.parse(_endDate.text),
                        hasil: _hasil.text,
                      );
                      dataBuktiKegiatan.createInputPegawai(buktiKegiatan);
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

Future<Map<String, String>> getJabatanAndNipByNama(String value) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('pegawai')
      .where('nama', isEqualTo: value)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    String jabatan = querySnapshot.docs[0]['jabatan'];
    String nip = querySnapshot.docs[0]['nip'];
    return {
      'jabatan': jabatan,
      'nip': nip
    }; // Mengembalikan jabatan dan NIP dalam bentuk Map
  } else {
    return {'jabatan': 'Jabatan tidak ditemukan', 'nip': 'NIP tidak ditemukan'};
  }
}
