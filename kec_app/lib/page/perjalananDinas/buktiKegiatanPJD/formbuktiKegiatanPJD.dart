import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/components/DateTimeFields.dart';
import 'package:kec_app/components/DropDownSearch/DropDownSearch.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerBuktiKegiatanPJD.dart';
import 'package:kec_app/model/PerjalananDinas/BuktiPJDService.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FormBuktiKegiatanPJD extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const FormBuktiKegiatanPJD({super.key, required this.documentSnapshot});

  @override
  State<FormBuktiKegiatanPJD> createState() => _FormBuktiKegiatanPJDState();
}

class _FormBuktiKegiatanPJDState extends State<FormBuktiKegiatanPJD> {
  late DocumentSnapshot documentSnapshot;

  final _formkey = GlobalKey<FormState>();
  final _dasar = TextEditingController();
  final _nama = TextEditingController();
  final _nip = TextEditingController();
  final _jabatan = TextEditingController();
  final _keperluan = TextEditingController();
  final _tempat = TextEditingController();
  final _firstDate = TextEditingController();
  final _endDate = TextEditingController();
  final _hasil = TextEditingController();

  String _selectedName = "";
  bool isLoading = false;

  final dataBuktiKegiatan = ControllerBuktiKegiatanPJD();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  Future<String> uploadImageToFirestore(XFile? imageFile) async {
    if (imageFile == null) {
      throw Exception('No image file provided.');
    }

    try {
      // Generate a unique filename for the image using a timestamp and file extension
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = imageFile.path.split('.').last;
      String filePath = 'buktipjd/$fileName.$extension';

      // Compress the image file
      Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        quality: 80, // Adjust the image quality as needed (0-100)
      );

      // Upload the compressed image file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putData(compressedImage!);

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
  void initState() {
    documentSnapshot = widget.documentSnapshot;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nama.text = documentSnapshot['nama'];
    _nip.text = documentSnapshot['nip'];
    _jabatan.text = documentSnapshot['jabatan'];
    _keperluan.text = documentSnapshot['keperluan'];
    _tempat.text = documentSnapshot['tujuan'];

    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    var date = timerstamp.toDate();
    var tanggal_awal = DateFormat('yyyy-MM-dd').format(date);

    Timestamp timerstamps = documentSnapshot['tanggal_berakhir'];
    var dates = timerstamps.toDate();
    var tanggal_akhir = DateFormat('yyyy-MM-dd').format(dates);

    _firstDate.text = tanggal_awal.toString();
    _endDate.text = tanggal_akhir.toString();

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
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _nama,
                  labelTexts: "Nama",
                  keyboardtypes: TextInputType.none,
                  enableds: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _nip,
                  labelTexts: "Nip",
                  keyboardtypes: TextInputType.none,
                  enableds: false,
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: TextFormFields(
                  controllers: _keperluan,
                  labelTexts: "Keperluan",
                  keyboardtypes: TextInputType.none,
                  enableds: false,
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
                  keyboardtypes: TextInputType.none,
                  enableds: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: DateTimeFields(
                  controllers: _firstDate,
                  tanggalText: 'Tanggal Berkahir',
                  enableds: false,
                  validators: (value) {
                    // if ((value.toString().isEmpty) ||
                    //     (DateTime.tryParse(value.toString()) == null)) {
                    //   return "Tanggal Berakhir Tidak Boleh Kosong !";
                    // }
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
                  enableds: false,
                  validators: (value) {
                    // if ((value.toString().isEmpty) ||
                    //     (DateTime.tryParse(value.toString()) == null)) {
                    //   return "Tanggal Berakhir Tidak Boleh Kosong !";
                    // }
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
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Dasar Tidak Boleh Kosong !";
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
                  controllers: _hasil,
                  labelTexts: "Hasil Perjalanan Dinas",
                  keyboardtypes: TextInputType.multiline,
                  maxlines: 3,
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Hasil Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListTile(
                  title: Text('Upload Bukti Foto Kegiatan'),
                  subtitle: Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightGreen),
                        ),
                        onPressed: selectImages,
                        child: Text('Select Image'),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var imageFile in imageFileList)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  height: 50.0,
                                  width: 50.0,
                                  child: Image.file(
                                    File(imageFile.path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      if (imageFileList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Pilih minimal satu foto atau lebih.'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });

                      final buktiKegiatan = BuktiKegiatan(
                        dasar: _dasar.text,
                        nama: _nama.text,
                        nip: _nip.text,
                        jabatan: _jabatan.text,
                        tempat: _tempat.text,
                        keperluan: _keperluan.text,
                        firstDate: DateTime.parse(_firstDate.text),
                        endDate: DateTime.parse(_endDate.text),
                        hasil: _hasil.text,
                        imageUrl: [],
                      );

                      // Upload semua gambar yang dipilih ke Firebase Storage
                      List<String> imageUrls = [];
                      for (var imageFile in imageFileList) {
                        String imageUrl;
                        try {
                          imageUrl = await uploadImageToFirestore(imageFile);
                          imageUrls.add(imageUrl);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Gagal mengunggah foto.'),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      // Set daftar URL gambar ke objek buktiKegiatan
                      buktiKegiatan.imageUrl = imageUrls;

                      // Simpan objek buktiKegiatan ke Firestore
                      dataBuktiKegiatan.createInputBuktiPJD(buktiKegiatan);

                      // Reset daftar gambar yang dipilih
                      imageFileList.clear();
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
                  child: isLoading
                  ? LinearProgressIndicator(color: Colors.blue, backgroundColor: Colors.white,)
                  : Text('Submit'),),
            
            ],
          ),
        ),
      ),
    );
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length: ${imageFileList.length}");
    setState(() {});
  }
}
