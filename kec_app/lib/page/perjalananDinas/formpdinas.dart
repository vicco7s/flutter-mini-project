import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../../components/DropDownSearch/DropDownSearch.dart';
import '../../../../components/DropdownButtonForm.dart';
import '../../../../components/inputborder.dart';
import 'package:intl/intl.dart';
import '../../../../controller/controllerPerjalananDinas/controllerpdinas.dart';
import '../../../../model/pdinasservice.dart';
import 'package:provider/provider.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FormPDinasPage extends StatefulWidget {
  const FormPDinasPage({super.key});

  @override
  State<FormPDinasPage> createState() => _FormPDinasPageState();
}

class _FormPDinasPageState extends State<FormPDinasPage> {
  final _formkey = GlobalKey<FormState>();
  final _tujuan = TextEditingController();
  final _keperluan = TextEditingController();
  final _jabatan = TextEditingController();
  final _nip = TextEditingController();
  final _tanggal_berangkat = TextEditingController();
  final _tanggal_berakhir = TextEditingController();
  final _uangharian = TextEditingController();
  final _hari = TextEditingController();
  final _transport = TextEditingController();
  final _pulangpergi = TextEditingController();
  final _penginapan = TextEditingController();
  final _lamaMenginap = TextEditingController();
  final _total = TextEditingController();

  String _selectedValue = "";

  var ket = "belum dikonfirmasi";
  var konfirmasi = "belum dikirim";
  final dataPdinas = ControllerPDinas();

  var berangkat = ["Pergi", "Pulang Pergi"];
  var berkat = 'Pergi';

  @override
  void dispose() {
    _uangharian.dispose();
    _hari.dispose();
    _transport.dispose();
    _pulangpergi.dispose();
    _penginapan.dispose();
    _lamaMenginap.dispose();
    _total.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Masukan Data'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      child: FutureBuilder(
                          future: firestore.collection("pegawai").get(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              QuerySnapshot querySnapshot =
                                  snapshot.data as QuerySnapshot;
                              List<DocumentSnapshot> items = querySnapshot.docs;
                              List<String> namaList = items
                                  .map((item) => item['nama'] as String)
                                  .toList();
                              // for (var item in items) {
                              //   dropdownItems.add(DropdownMenuItem(
                              //     child: Text(item['nama']),
                              //     value: item['nama'],
                              //   ));
                              // }
                              return DropdownButtonSearch(
                                  itemes: namaList,
                                  textDropdownPorps: 'Nama pegawai',
                                  hintTextProps: 'Search Nama...',
                                  onChage: (value) {
                                    setState(() {
                                      _selectedValue = value!;
                                      getJabatanAndNipByNama(value)
                                          .then((result) {
                                        setState(() {
                                          _jabatan.text = result['jabatan']!;
                                          _nip.text = result['nip']!;
                                        });
                                      });
                                    });
                                  },
                                  validators: (value) => (value == null
                                      ? 'Nama tidak boleh kosong !'
                                      : null));
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
                    child: TextFormFields(
                      controllers: _tujuan,
                      labelTexts: 'Tujuan',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Tujuan Tidak Boleh Kosong !";
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
                      controllers: _keperluan,
                      labelTexts: 'Keperluan',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Keperluan Tidak Boleh Kosong !";
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
                      onShowPicker:
                          (BuildContext context, DateTime? currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      controller: _tanggal_berangkat,
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal berangkat Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal Berangkat',
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
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal berakhir Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal Berakhir',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: TextFormFields(
                            controllers: _uangharian,
                            labelTexts: 'Uang Harian',
                            onChangeds: (value) {
                              updateTotal();
                            },
                            keyboardtypes: TextInputType.number,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "Uang Harian Tidak Boleh Kosong !";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 0.0),
                          child: TextFormFields(
                            controllers: _hari,
                            labelTexts: 'Hari',
                            onChangeds: (value) {
                              updateTotal();
                            },
                            keyboardtypes: TextInputType.number,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "Harus diisi!";
                              }
                              return null;
                            },
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
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: TextFormFields(
                            controllers: _transport,
                            labelTexts: 'Uang Transportasi',
                            onChangeds: (value) {
                              updateTotal();
                            },
                            keyboardtypes: TextInputType.number,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "harus diisi";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 10.0, left: 0.0),
                            child: DropdownButtonForms(
                              itemes:
                                  berangkat.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                  ),
                                );
                              }).toList(),
                              onchage: (newValueSelected) {
                                setState(() {
                                  var _currentItemSelected = newValueSelected!;
                                  berkat = newValueSelected;
                                  updateTotal();
                                });
                              },
                              labelTitle: "Opsi",
                              validators: ((value) =>
                                  (value == null ? 'Harus diisi!' : null)),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: TextFormFields(
                            controllers: _penginapan,
                            labelTexts: 'Uang Penginapan',
                            onChangeds: (value) {
                              updateTotal();
                            },
                            keyboardtypes: TextInputType.number,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "harus diisi";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: TextFormFields(
                            controllers: _lamaMenginap,
                            labelTexts: 'Lama',
                            onChangeds: (value) {
                              updateTotal();
                            },
                            keyboardtypes: TextInputType.number,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "harus diisi";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _total,
                      labelTexts: 'Jumlah Total',
                      keyboardtypes: TextInputType.none,
                      enableds: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // int pulangpergi = berkat == 'Pergi' ? 1 : 2;
                        final inputDinas = InputDinas(
                          nama: _selectedValue,
                          jabatan: _jabatan.text,
                          nip: _nip.text,
                          tujuan: _tujuan.text,
                          keperluan: _keperluan.text,
                          tanggal_berangkat:
                              DateTime.parse(_tanggal_berangkat.text),
                          tanggal_berakhir:
                              DateTime.parse(_tanggal_berakhir.text),
                          uangharian: int.parse(_uangharian.text),
                          hari: int.parse(_hari.text),
                          transport: int.parse(_transport.text),
                          pulang_pergi: int.parse(_pulangpergi.text),
                          penginapan: int.parse(_penginapan.text),
                          lama_menginap: int.parse(_lamaMenginap.text),
                          jumlah_total: int.parse(_total.text),
                          status: ket,
                          konfirmasi_kirim: konfirmasi, 
                          uid: '',
                        );
                        dataPdinas.createInputSurel(inputDinas);
                        // createInputSurel(inputDinas);
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
                    child: Text('Submit'),
                  )
                ],
              )),
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
      'nip': nip,
    }; // Mengembalikan jabatan dan NIP dalam bentuk Map
  } else {
    return {'jabatan': 'Jabatan tidak ditemukan', 'nip': 'Nip tidak Ditemukan'};
  }
}
