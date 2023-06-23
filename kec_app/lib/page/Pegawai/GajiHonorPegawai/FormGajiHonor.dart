import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/components/DateTimeFields.dart';
import 'package:kec_app/components/DropDownSearch/DropDownSearch.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controlerPegawai/controllerHonorGaji.dart';
import 'package:kec_app/model/Pegawai/gajihonorservice.dart';
import 'package:kec_app/report/reportPegawai/ReportDetaiPegawai.dart';

class FormGajiHonorPegawai extends StatefulWidget {
  const FormGajiHonorPegawai({super.key});

  @override
  State<FormGajiHonorPegawai> createState() => _FormGajiHonorPegawaiState();
}

class _FormGajiHonorPegawaiState extends State<FormGajiHonorPegawai> {
  final _formkey = GlobalKey<FormState>();
  final _tanggal = TextEditingController();
  final _gajihonor = TextEditingController();
  final _bonus = TextEditingController();
  final _keterangan = TextEditingController();
  final _jabatan = TextEditingController();
  final _total = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _selectedValue = "";

  String totalValue = "";

  final dataHonorPegawai = ControllerGajiHonor();

  @override
  void dispose() {
    _gajihonor.dispose();
    _bonus.dispose();
    _total.dispose();
    super.dispose();
  }

  void updateTotal() {
    int gajiHonor = int.tryParse(_gajihonor.text) ?? 0;
    int bonus = int.tryParse(_bonus.text) ?? 0;
    int total = gajiHonor + bonus;
    _total.text = total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Input Pembayaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                    child: FutureBuilder(
                        future: firestore.collection("pegawai").where('status', isEqualTo: "NON ASN").get(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot querySnapshot =
                                snapshot.data as QuerySnapshot;
                            List<DocumentSnapshot> items = querySnapshot.docs;
                            List<String> namaList = items.map((item) => item['nama'] as String).toList();
                            // for (var item in items) {
                            //   dropdownItems.add(DropdownMenuItem(
                            //     child: Text(item['nama']),
                            //     value: item['nama'],
                            //   ));
                            // }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    right: 10.0,
                                    left: 10.0,
                                  ),
                                  child: DropdownButtonSearch(
                                    itemes: namaList,
                                    textDropdownPorps: "Nama Pegawai",
                                    hintTextProps: "Search Nama...",
                                    onChage: (value) {
                                      setState(() {
                                      _selectedValue = value!;
                                      getJabatanByNama(value).then((jabatan) {
                                        setState(() {
                                          _jabatan.text = jabatan; // Set nilai pada _jabatanController
                                        });
                                      });
                                    });
                                    },
                                    validators:  (value) => (value == null ? 'Nama tidak boleh kosong!' : null),
                                  ),
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
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    right: 10.0,
                    left: 10.0,
                  ),
                  child: DateTimeFields(
                    controllers: _tanggal, 
                    tanggalText: 'Tanggal', 
                    validators: (value) { 
                      if ((value.toString().isEmpty) ||
                          (DateTime.tryParse(value.toString()) == null)) {
                        return "Tanggal Tidak Boleh Kosong !";
                      }
                      return null;
                     },
                    
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: TextFormFields(
                    controllers: _gajihonor,
                    labelTexts: 'Pembayaran',
                    onChangeds: (value) {
                      updateTotal();
                    },
                    keyboardtypes: TextInputType.number,
                    validators: (value) {
                      if (value!.isEmpty) {
                        return "Pembayaran Tidak Boleh Kosong !";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: TextFormFields(
                    controllers: _bonus,
                    labelTexts: 'Bonus',
                    onChangeds: (value) {
                      updateTotal();
                    },
                    keyboardtypes: TextInputType.number,
                    validators: (value) {
                      if (value!.isEmpty) {
                        return "Bonus Tidak Boleh Kosong !";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: TextFormFields(
                    controllers: _total,
                    labelTexts: 'Total',
                    keyboardtypes: TextInputType.none,
                    enableds: false,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: TextFormFields(
                    controllers: _keterangan,
                    labelTexts: 'Keterangan',
                    keyboardtypes: TextInputType.text,
                    validators: (value) {
                      if (value!.isEmpty) {
                        return "Keterangan Tidak Boleh Kosong !";
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        final gajihonor = GajiHonor(
                            nama: _selectedValue,
                            jabatan: _jabatan.text,
                            tanggal: DateTime.parse(_tanggal.text),
                            gaji_honor: int.parse(_gajihonor.text),
                            bonus: int.parse(_bonus.text),
                            total: int.parse(_total.text),
                            keterangan: _keterangan.text);
                        dataHonorPegawai.createInputPegawai(gajihonor);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Berhasil Menambahkan Data')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Gagal Menambahkan Data')));
                      }
                    },
                    child: Text('Submit'))
              ],
            )),
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
