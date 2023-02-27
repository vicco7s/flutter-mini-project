import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/model/suratkeluarService.dart';

class FormSuratKeluar extends StatefulWidget {
  const FormSuratKeluar({super.key});

  @override
  State<FormSuratKeluar> createState() => _FormSuratKeluarState();
}

class _FormSuratKeluarState extends State<FormSuratKeluar> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _noBerkas = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _perihal = TextEditingController();
  String? _input;
  String? _inputErrorText;

  var options = [
    'sudah dikirim',
    'belum dikirim',
  ];
  var _currentItemSelected = "sudah dikirm";
  var ket = "sudah dikirim";

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
                            return "Nomor berkas tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      )),
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
                      validator: (value) => (value == null ? 'keterangan tidak boleh kosong !' :null)
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_formkey.currentState!.validate()) {
                          final inputSurel = OutputSurel(
                            noBerkas: _noBerkas.text,
                            alamat: _alamat.text,
                            tanggal: DateTime.parse(_tanggal.text),
                            perihal: _perihal.text, 
                            keterangan: ket
                          );
                          _createOutputSurel(inputSurel);
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
                      });
                    },
                    child: Text('Submit'),
                  )
                ],
              )),
        ));
  }

  void _createOutputSurel(OutputSurel outputSurel) async {
    final CollectionReference<Map<String, dynamic>> _suratkeluar =
        FirebaseFirestore.instance.collection('suratkeluar');

    // outputSurel.id = _suratkeluar.id;

    final json = outputSurel.toJson();
     var querySnapshot = await _suratkeluar.orderBy("no", descending: true).limit(1).get();
    var maxId = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("no") : 0;
    json["no"] = maxId + 1;
    await _suratkeluar.add(json);
  }
}
