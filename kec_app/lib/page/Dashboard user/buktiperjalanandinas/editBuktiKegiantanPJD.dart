import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditButkiKegiantanPjd extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const EditButkiKegiantanPjd({super.key, required this.documentSnapshot});

  @override
  State<EditButkiKegiantanPjd> createState() => _EditButkiKegiantanPjdState();
}

class _EditButkiKegiantanPjdState extends State<EditButkiKegiantanPjd> {
  late DocumentSnapshot documentSnapshot;

  bool _isLoading = false;

  final CollectionReference _buktiKegiatan =
      FirebaseFirestore.instance.collection('buktikegiatanpjd');

    final _formkey = GlobalKey<FormState>();
    final _no = TextEditingController();
    final _dasar = TextEditingController();
    final _nama = TextEditingController();
    final _nip = TextEditingController();
    final _jabatan = TextEditingController();
    final _keperluan = TextEditingController();
    final _tempat = TextEditingController();
    final _hasil = TextEditingController();
    final _tgl_awal = TextEditingController();
    final _tgl_akhir = TextEditingController();

  @override
  void initState() {
    documentSnapshot = widget.documentSnapshot;
    Timestamp timerstamp = documentSnapshot['tgl_awal'];
    var date = timerstamp.toDate();
    var tanggal_awal = DateFormat('yyyy-MM-dd').format(date);

    Timestamp timerstamps = documentSnapshot['tgl_akhir'];
    var dates = timerstamps.toDate();
    var tanggal_akhir = DateFormat('yyyy-MM-dd').format(dates);

    _no.text = documentSnapshot['id'].toString();
    _nama.text = documentSnapshot['nama'];
    _dasar.text = documentSnapshot['dasar'];
    _nip.text = documentSnapshot['nip'];
    _jabatan.text = documentSnapshot['jabatan'];
    _keperluan.text = documentSnapshot['keperluan'];
    _tempat.text = documentSnapshot['tempat'];
    _tgl_awal.text = tanggal_awal.toString();
    _tgl_akhir.text = tanggal_akhir.toString();
    _hasil.text = documentSnapshot['hasil'];
    super.initState();
  }

  List<XFile> imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  Future<String> uploadImageToFirestore(XFile? imageFile) async {
      if (imageFile == null) {
        throw Exception('No image file provided.');
      }

      try {
        // Upload image to Firebase Storage
        String folderName = 'buktipjd'; // Nama folder yang diinginkan
        String fileName =
            '$folderName/' + DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        File image = File(imageFile.path);
        int fileSize = image.lengthSync();

        Uint8List? compressedImage =
            await FlutterImageCompress.compressWithFile(
          image.path,
          quality: 90,
        );
        await ref.putData(compressedImage!);

        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        throw Exception('Failed to upload image to Firestore: $e');
      }
    }

    Future<void> updateImage(DocumentSnapshot<Object?> documentSnapshot,
        BuildContext context) async {
      try {
        if (imageFileList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.yellowAccent,
            content: Text(
              'Tidak ada pembaruan foto',
              style: TextStyle(color: Colors.black),
            ),
          ));
          return;
        }

        // Hapus foto-foto lama dari Firebase Storage
        List<String> existingImageUrls =
            List<String>.from(documentSnapshot['imageUrl']);
        for (var imageUrl in existingImageUrls) {
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(imageUrl)
              .delete();
        }

        List<String> imageUrls = [];

        // Upload foto-foto baru ke Firebase Storage
        for (var imageFile in imageFileList) {
          String downloadURL = await uploadImageToFirestore(imageFile);
          imageUrls.add(downloadURL);
        }

        // Update imageFileList dengan foto-foto baru
        imageFileList = imageUrls.map<XFile>((imageUrl) {
          return XFile(imageUrl);
        }).toList();

        // Perbarui dokumen di Firestore dengan URL foto yang baru
        await _buktiKegiatan.doc(documentSnapshot.id).update({
          'imageUrl': imageUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Foto berhasil diperbarui'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Gagal memperbarui foto'),
        ));
      }
    }

  Future<void> selectImages() async {
      try {
        List<XFile>? pickedImages = await imagePicker.pickMultiImage(
          imageQuality: 90,
        );
        if (pickedImages != null) {
          setState(() {
            imageFileList.addAll(pickedImages);
          });
        }
      } on PlatformException catch (e) {
        print('Failed to pick images: $e');
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
        title: Text('Ubah Bukti'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        keyboardType: TextInputType.none,
                        controller: _no,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Nomor'),
                      ),
                      TextField(
                        keyboardType: TextInputType.none,
                        controller: _nama,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Nomor'),
                      ),
                      TextField(
                        keyboardType: TextInputType.none,
                        controller: _nip,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Nomor'),
                      ),
                      TextField(
                        keyboardType: TextInputType.none,
                        controller: _jabatan,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Nomor'),
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _tempat,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Tempat'),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        controller: _keperluan,
                        enabled: false,
                        decoration:
                            const InputDecoration(labelText: 'Keperluan'),
                      ),
                      DateTimeField(
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
                        controller: _tgl_awal,
                        enabled: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range_outlined),
                          labelText: 'Tanggal Awal',
                        ),
                      ),
                      DateTimeField(
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
                        controller: _tgl_akhir,
                        enabled: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range_outlined),
                          labelText: 'Tanggal Akhir',
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _dasar,
                        decoration: const InputDecoration(labelText: 'Dasar'),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _hasil,
                        decoration: const InputDecoration(
                            labelText: 'Bukti Hasil Perjalanan Dinas'),
                      ),
                      ListTile(
                        title: Text('Upload Bukti Foto Kegiatan'),
                        subtitle: Padding(
                          padding:
                              EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: selectImages,
                                child: Text('Select Image'),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child:SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                       for (var imageFile in imageFileList ?? [])
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
                                      if (imageFileList == null || imageFileList!.isEmpty)
                                        for (var imageUrl in documentSnapshot['imageUrl'])
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                                            height: 50.0,
                                            width: 50.0,
                                            child: Image.network(
                                              imageUrl,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // background
                                foregroundColor: Colors.blue, // foreground
                              ),
                              child: _isLoading
                                ? LinearProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.blue,
                                ) // Display loading indicator when loading
                                : Text('Update'),
                              onPressed: _isLoading ? null:() async{
                                setState(() {
                                _isLoading = true; // Set loading state to true
                              });
                                if (imageFileList != null) {
                                  await updateImage(documentSnapshot, context);
                                }
                                final int no = int.parse(_no.text);
                                final String dasar = _dasar.text;
                                final String nama = _nama.text;
                                final String nip = _nip.text;
                                final String jabatan = _jabatan.text;
                                final String keperluan = _keperluan.text;
                                final String tempat = _tempat.text;
                                final DateTime firstDate =
                                    DateTime.parse(_tgl_awal.text);
                                final DateTime endDate =
                                    DateTime.parse(_tgl_akhir.text);
                                final String hasil = _hasil.text;
                                if (no != null) {
                                  await _buktiKegiatan
                                      .doc(documentSnapshot.id)
                                      .update({
                                    "id": no,
                                    'dasar': dasar,
                                    'nama': nama,
                                    'nip': nip,
                                    'jabatan': jabatan,
                                    'keperluan': keperluan,
                                    'tempat': tempat,
                                    'tgl_awal': firstDate,
                                    'tgl_akhir': endDate,
                                    'hasil': hasil,
                                  });
                                  _no.text = '';
                                  _nama.text = '';
                                  _jabatan.text = '';
                                  _nip.text = '';
                                  _tempat.text = '';
                                  _keperluan.text = '';
                                  _tgl_awal.text = '';
                                  _tgl_akhir.text = '';
                                  _dasar.text = '';
                                  _hasil.text = '';
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content:
                                          Text('Berhasil Memperbarui Data')));
                                }
                          
                                setState(() {
                                _isLoading = false; // Set loading state to false
                              });
                          
                              }
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: (() => Navigator.pop(context)),
                            child: const Text("Cencel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // background
                              foregroundColor: Colors.red, // foreground
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
    );

    
  }
  
}
