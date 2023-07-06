import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controlerPegawai/controllerPegawai.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../util/shortpath.dart';

class FormPegawaiAsn extends StatefulWidget {
  const FormPegawaiAsn({super.key});

  @override
  State<FormPegawaiAsn> createState() => _FormPegawaiAsnState();
}

class _FormPegawaiAsnState extends State<FormPegawaiAsn> {
  final _formkey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final  _nip = MaskedTextController(mask: '00000000 000000 0 000');
  final _tmulaitugas = TextEditingController();
  final _tlahir = TextEditingController();
  final _telp = MaskedTextController(mask: '0000 0000 0000');
  final _alamat = TextEditingController();
  final _tempatlahir = TextEditingController();
  final _jumlahAnak = TextEditingController();

  File? _selectedImage;

  final dataPegawai = ControllerPegawai();

  Future<String> uploadImageToFirestore(File? imageFile) async {
    if (imageFile == null) {
      throw Exception('No image file provided.');
    }

    try {
      // Generate a unique filename for the image using a timestamp and file extension
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = imageFile.path.split('.').last;
      String filePath = 'images/$fileName.$extension';

      // Upload the image file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putFile(imageFile);

      // Get the download URL for the uploaded image
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();
     

      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload image to Firestore: $e');
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
          title: Text('Masukan Data Pegawai'),
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
                        return null;
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
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: DropdownButtonForms(
                      itemes: jenis_k.map((String dropDownStringItem) {
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
                          jk = newValueSelected;
                        });
                      },
                      labelTitle: "Jenis Kelamin",
                      validators: ((value) => (value == null
                          ? 'Jenis kelamin tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  //tgl lahir
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
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      controller: _tlahir,
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal Lahir Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal Lahir',
                      ),
                    ),
                  ),
                  // tempat lahir
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _tempatlahir,
                      labelTexts: 'Tempat Lahir',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "tempat lahir Tidak Boleh Kosong !";
                        }
                        return null;
                      },
                    ),
                  ),
                  // tanggal mulai tugas
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
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      controller: _tmulaitugas,
                      validator: (value) {
                        if ((value.toString().isEmpty) ||
                            (DateTime.tryParse(value.toString()) == null)) {
                          return "Tanggal mulai tugas Tidak Boleh Kosong !";
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
                        labelText: 'Tanggal Mulai Tugas',
                      ),
                    ),
                  ),
                  // alamat
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: TextFormFields(
                      controllers: _alamat,
                      labelTexts: 'Alamat',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "alamat Tidak Boleh Kosong !";
                        }
                        return null;
                      },
                    ),
                  ),
                  //pendidikan akhir
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: DropdownButtonForms(
                      itemes: pendidikan_akhir.map((String dropDownStringItem) {
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
                          pendidikan_ak = newValueSelected;
                        });
                      },
                      labelTitle: "Pendidikan Terkahir",
                      validators: ((value) => (value == null
                          ? 'Pendidikan Terakhir tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  //pangkat
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
                      onchage: (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          pakat = newValueSelected;
                        });
                      },
                      labelTitle: "Pangkat",
                      validators: ((value) => (value == null
                          ? 'Pangkat tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  //golongan
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
                      onchage: (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          gol = newValueSelected;
                        });
                      },
                      labelTitle: "golongan",
                      validators: ((value) => (value == null
                          ? 'golongan tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  // Jabatan
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: DropdownButtonForms(
                      itemes: jabatan.map((String dropDownStringItem) {
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
                          jabat = newValueSelected;
                        });
                      },
                      labelTitle: "Jabatan",
                      validators: ((value) => (value == null
                          ? 'Jabatan tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  // status pegawai
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
                      onchage: (newValueSelected) {
                        setState(() {
                          var _currentItemSelected = newValueSelected!;
                          stas = newValueSelected;
                        });
                      },
                      labelTitle: "Status Pegawai",
                      validators: ((value) => (value == null
                          ? 'Status Pegawai tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  //Status Perkawinan
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: DropdownButtonForms(
                      itemes: s_perkawinan.map((String dropDownStringItem) {
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
                          sperkawinan = newValueSelected;
                        });
                      },
                      labelTitle: "Status Pernikahan",
                      validators: ((value) => (value == null
                          ? 'Status Perkawinan tidak boleh kosong !'
                          : null)),
                    ),
                  ),
                  //jumlah anak
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _jumlahAnak,
                      labelTexts: 'jumlah anak',
                      keyboardtypes: TextInputType.number,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "jumlah anak Tidak Boleh Kosong !";
                        }
                        return null;
                      },
                    ),
                  ),
                  //telp
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: TextFormFields(
                      controllers: _telp,
                      labelTexts: 'telp',
                      keyboardtypes: TextInputType.phone,
                      validators: (value) {
                       if (value!.isEmpty) {
                          return "telp Tidak Boleh Kosong !";
                        }
                        return null;
                      },
                    ),
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
                            // Open the image picker to select an image from the gallery
                            final pickedImage = (await ImagePicker()
                                .pickImage(source: ImageSource.gallery));
                            if (pickedImage != null) {
                              setState(() {
                                _selectedImage = File(pickedImage.path);
                              });
                            }
                          },
                          child: Text('Select Image'),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            _selectedImage != null
                                ? 'foto berhasil dipilih'
                                : 'tidak ada foto yang dipilih',
                            style: TextStyle(
                              color: _selectedImage != null
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: ()  async {
                      if (_formkey.currentState!.validate()) {
                        //validation image if image no pick on gallery
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Please select an image'),
                            ),
                          );
                          return;
                        }

                        final inputAsn = InputAsn(
                          nama: _nama.text,
                          nip: _nip.text,
                          pangkat: pakat,
                          golongan: gol,
                          jabatan: jabat,
                          status: stas,
                          jenis_kelamin: jk,
                          alamat: _alamat.text,
                          jumlah_anak: int.parse(_jumlahAnak.text),
                          pendidikan_terakhir: pendidikan_ak,
                          status_perkawinan: sperkawinan,
                          tanggal_mulai_tugas:
                              DateTime.parse(_tmulaitugas.text),
                          tempat_lahir: _tempatlahir.text,
                          tgl_lahir: DateTime.parse(_tlahir.text),
                          telp: _telp.text,
                          imageUrl: '', uid: '',
                        );
                        String? imageUrl;
                        // Upload the image to Firestore and get the image URL
                        try {
                           imageUrl = await uploadImageToFirestore(_selectedImage);
                         } catch (e) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               backgroundColor: Colors.red,
                               content: Text('Failed to upload image: $e'),
                             ),
                           );
                           return;
                         }
                        inputAsn.imageUrl = imageUrl;
                        dataPegawai.createInputPegawai(inputAsn);
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


