import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controllerSurat/controlerSuratMasuk.dart';
import 'package:kec_app/model/suratmasukService.dart';
import 'package:intl/intl.dart';

class FormSuratMasuk extends StatefulWidget {
  const FormSuratMasuk({super.key});

  @override
  State<FormSuratMasuk> createState() => _FormSuratMasukState();
}

class _FormSuratMasukState extends State<FormSuratMasuk> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _no = TextEditingController();
  final TextEditingController _noBerkas = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _perihal = TextEditingController();
  final TextEditingController _tanggal_terima = TextEditingController();

  final dataControllerSM = ControllerSM();
  var options = [
    'sudah diterima',
    'belum diterima',
  ];
  var _currentItemSelected = "sudah diterima";
  var ket = "sudah diterima";

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
                    child: TextFormFields(
                      controllers: _noBerkas,
                      labelTexts: 'Nomor Berkas',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Nomor Berkas Tidak Boleh Kosong !";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _alamat,
                      labelTexts: 'Alamat Pengirim',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Alamat Pengirim Tidak Boleh Kosong !";
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
                      controller: _tanggal,
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: TextFormFields(
                      controllers: _perihal,
                      labelTexts: 'Perihal',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Perihal Tidak Boleh Kosong !";
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
                      controller: _tanggal_terima,
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal Diterima',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        iconEnabledColor: Colors.black,
                        focusColor: Colors.black,
                        items: options.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValueSelected) {
                          setState(() {
                            _currentItemSelected = newValueSelected!;
                            ket = newValueSelected;
                          });
                        },
                        // value: _currentItemSelected,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          // hintText: "Masukan Email",
                          fillColor: Colors.white70,
                          labelText: "keterangan",
                        ),
                        validator: (value) => (value == null
                            ? 'keterangan tidak boleh kosong !'
                            : null)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final inputSurel = InputSurel(
                          noBerkas: _noBerkas.text,
                          alamat: _alamat.text,
                          tanggal: DateTime.parse(_tanggal.text),
                          perihal: _perihal.text,
                          tanggal_terima: DateTime.parse(_tanggal_terima.text),
                          keterangan: ket,
                        );
                        dataControllerSM.createInputSurel(inputSurel);
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
        ));
  }
}
