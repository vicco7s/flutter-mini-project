import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerpdinas.dart';
import 'package:kec_app/model/pdinasservice.dart';

class FormPDinasPage extends StatefulWidget {
  const FormPDinasPage({super.key});

  @override
  State<FormPDinasPage> createState() => _FormPDinasPageState();
}

class _FormPDinasPageState extends State<FormPDinasPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _tujuan = TextEditingController();
  final TextEditingController _keperluan = TextEditingController();
  final TextEditingController _tanggal_berangkat = TextEditingController();
  final TextEditingController _tanggal_berakhir = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _selectedValue = "";

  var options = [
    'diterima',
    'belum diterima',
  ];
  var _currentItemSelected = "diterima";
  var ket = "diterima";
  final dataCreateDinas = CreatePdinas();

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
      body: SingleChildScrollView(
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
                            List<DropdownMenuItem<String>> dropdownItems = [];
                            for (var item in items) {
                              dropdownItems.add(DropdownMenuItem(
                                child: Text(item['nama']),
                                value: item['nama'],
                              ));
                            }
                            return DropdownButtonForms(
                                itemes: dropdownItems,
                                onchage: ((value) {
                                  setState(() {
                                    _selectedValue = value!;
                                  });
                                }),
                                labelTitle: "Nama",
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: DropdownButtonForms(
                    itemes: options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                    onchage: (newValueSelected) {
                      setState(() {
                        _currentItemSelected = newValueSelected!;
                        ket = newValueSelected;
                      });
                    },
                    labelTitle: "Status",
                    validators: (value) =>
                        (value == null ? 'Status tidak boleh kosong !' : null),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: ()  async {
                    if (_formkey.currentState!.validate()) {
                      final inputDinas = InputDinas(
                        nama: _selectedValue,
                        tujuan: _tujuan.text,
                        keperluan: _keperluan.text,
                        tanggal_berangkat:
                            DateTime.parse(_tanggal_berangkat.text),
                        tanggal_berakhir:
                            DateTime.parse(_tanggal_berakhir.text),
                        status: ket,
                      );
                      dataCreateDinas.createInputSurel(inputDinas);
                      // createInputSurel(inputDinas);
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
                  child: Text('Submit'),
                )
              ],
            )),
      ),
    );
  }

}
