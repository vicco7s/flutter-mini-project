import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerSurat/controllerSuratKeluar.dart';
import 'package:kec_app/model/suratkeluarService.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

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
  final dataSuratKeluar = ControllerSK();

  var options = [
    'sudah dikirim',
    'belum dikirim',
  ];
  var _currentItemSelected = "sudah dikirm";
  var ket = "sudah dikirim";

  bool _isLoading = false;

  File? _selectedPdf;

  Future<String> uploadBerkasToFirestore(File? pdfFile) async {
    if (pdfFile == null) {
      throw Exception('No pdf file provided.');
    }

    try {
      // Generate a unique filename for the image using a timestamp and file extension
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = pdfFile.path.split('.').last;
      String filePath = 'berkas/$fileName.$extension';

      // Upload the image file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putFile(pdfFile);

      // Get the download URL for the uploaded image
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload pdf to Firestore: $e');
    }
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
                        validator: (value) => (value == null
                            ? 'keterangan tidak boleh kosong !'
                            : null)),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.lightGreen)),
                          onPressed: () async {
                            FilePickerResult? filepicker =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );

                            if (filepicker != null &&
                                filepicker.files.isNotEmpty) {
                              String? filePath = filepicker.files.single.path;
                              setState(() {
                                _selectedPdf = File(filePath!);
                              });
                            } else {
                              print('File path is not nullabel');
                            }
                          },
                          child: Text('Tambah PDF'),
                        ),
                        SizedBox(width: 10.0),
                        _selectedPdf != null
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(top: 7, bottom: 7, left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.blue
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.filePdf,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          '${_selectedPdf!.path.split('/').last}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text(
                                'Tidak ada File yang dipilih',
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                            ? null
                            : () async {
                              setState(() {
                                _isLoading = true;
                              });

                                if (_formkey.currentState!.validate()) {
                                  // Check the size of the PDF file
                                  int fileSize = 0;

                                  if (_selectedPdf != null) {
                                    fileSize = await _selectedPdf!.length();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text('Please select an Pdf'),
                                        ),
                                      );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return;
                                  }
                                  
                                  if (fileSize > 1048576){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('File PDF yang diupload lebih dari 1MB'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      setState(() {
                                      _isLoading = false;
                                    });
                                      return;
                                    }

                                  final inputSurel = OutputSurel(
                                      noBerkas: _noBerkas.text,
                                      alamat: _alamat.text,
                                      tanggal: DateTime.parse(_tanggal.text),
                                      perihal: _perihal.text,
                                      keterangan: ket,
                                      berkas: '');
                                  String? berkasPdf;
                                  try {
                                    berkasPdf = await uploadBerkasToFirestore(_selectedPdf);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Failed to upload pdf: $e'),
                                    ),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return;
                                  }
                                  inputSurel.berkas = berkasPdf;
                                  dataSuratKeluar.createOutputSurel(inputSurel);
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
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                            },
                            child: _isLoading ? ColorfulLinearProgressIndicator() : Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
