import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/model/suratmasukService.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/util/OptionDropDown.dart';

class FormPegawaiAsn extends StatefulWidget {
  const FormPegawaiAsn({super.key});

  @override
  State<FormPegawaiAsn> createState() => _FormPegawaiAsnState();
}

class _FormPegawaiAsnState extends State<FormPegawaiAsn> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _nip = TextEditingController();
  final TextEditingController _jabatan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text('Masukan Data Pegawai Asn'),
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
                    child: TextFormFields(
                      controllers: _nama,
                      labelTexts: 'nama',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "nama Tidak Boleh Kosong !";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _nip,
                      labelTexts: 'nip',
                      keyboardtypes: TextInputType.number,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "nip Tidak Boleh Kosong !";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                        child: DropdownButtonForms(
                      itemes: pangkat.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                      onchage:  (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          pakat = newValueSelected;
                        });
                      },
                      labelTitle: "Pangkat",
                      validators: ((value) =>
                      (value == null ? 'Pangkat tidak boleh kosong !' : null)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                        child: DropdownButtonForms(
                      itemes: golongan.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                      onchage:  (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          gol = newValueSelected;
                        });
                      },
                      labelTitle: "golongan",
                      validators: ((value) =>
                      (value == null ? 'golongan tidak boleh kosong !' : null)),
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
                      labelTexts: 'Jabatan',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Jabatan Tidak Boleh Kosong !";
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
                    child: DropdownButtonForms(
                      itemes: status.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(),
                      onchage:  (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          stas = newValueSelected;
                        });
                      },
                      labelTitle: "Status",
                      validators: ((value) =>
                      (value == null ? 'Status tidak boleh kosong !' : null)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final inputAsn = InputAsn(
                          nama: _nama.text, 
                          nip: int.parse(_nip.text), 
                          pangkat: pakat, 
                          golongan: gol, 
                          jabatan: _jabatan.text, 
                          status: stas,
                        );
                        _createInputSurel(inputAsn);
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
        ));
  }

  

  void _createInputSurel(InputAsn inputAsn) async {
    final CollectionReference _pegawaiAsn =
        FirebaseFirestore.instance.collection('pegawai');

    // inputSurel.id = _suratmasuk.id;

    final json = inputAsn.toJson();
    var querySnapshot = await _pegawaiAsn.orderBy("id", descending: true).limit(1).get();
    var maxId = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await _pegawaiAsn.add(json);
  }
   
}


