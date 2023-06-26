import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage ;
import 'package:kec_app/model/PerjalananDinas/BuktiPJDService.dart';

class ControllerBuktiKegiatanPJD {
  final CollectionReference _buktiKegiatan =
      FirebaseFirestore.instance.collection('buktikegiatanpjd');

  void createInputBuktiPJD(BuktiKegiatan buktiKegiatan) async {
    final json = buktiKegiatan.toJson();
    var querySnapshot =
        await _buktiKegiatan.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    json["imageUrl"] = buktiKegiatan.imageUrl;
    await _buktiKegiatan.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      final snapshot = await _buktiKegiatan.doc(id).get();
      final data = snapshot.data();
      
      if (snapshot.exists &&
        data != null &&
        data is Map<String, dynamic> &&
        data['imageUrl'] != null) {
      final List<String> imageUrl = List<String>.from(data['imageUrl']);

      // Hapus dokumen dari Firestore
      await _buktiKegiatan.doc(id).delete();

      // Hapus imageUrl dari Firebase Storage
      for (String url in imageUrl) {
        final storageRef = storage.FirebaseStorage.instance.refFromURL(url);
        await storageRef.delete();
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Data Berhasil Dihapus'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Data tidak berhasil dihapus'),
        ),
      );
    }
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Data tidak berhasil di hapus')));
    }
  }

  // List<XFile> imageFileList = [];
  // final ImagePicker imagePicker = ImagePicker();

  // Future<void> update(
  //     DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
  //   final _formkey = GlobalKey<FormState>();
  //   final _no = TextEditingController();
  //   final _dasar = TextEditingController();
  //   final _nama = TextEditingController();
  //   final _nip = TextEditingController();
  //   final _jabatan = TextEditingController();
  //   final _keperluan = TextEditingController();
  //   final _tempat = TextEditingController();
  //   final _hasil = TextEditingController();
  //   final _tgl_awal = TextEditingController();
  //   final _tgl_akhir = TextEditingController();

  //   Timestamp timerstamp = documentSnapshot['tgl_awal'];
  //   var date = timerstamp.toDate();
  //   var tanggal_awal = DateFormat('yyyy-MM-dd').format(date);

  //   Timestamp timerstamps = documentSnapshot['tgl_akhir'];
  //   var dates = timerstamps.toDate();
  //   var tanggal_akhir = DateFormat('yyyy-MM-dd').format(dates);

  //   _no.text = documentSnapshot['id'].toString();
  //   _nama.text = documentSnapshot['nama'];
  //   _dasar.text = documentSnapshot['dasar'];
  //   _nip.text = documentSnapshot['nip'];
  //   _jabatan.text = documentSnapshot['jabatan'];
  //   _keperluan.text = documentSnapshot['keperluan'];
  //   _tempat.text = documentSnapshot['tempat'];
  //   _tgl_awal.text = tanggal_awal.toString();
  //   _tgl_akhir.text = tanggal_akhir.toString();
  //   _hasil.text = documentSnapshot['hasil'];

  //   Future<String> uploadImageToFirestore(XFile? imageFile) async {
  //     if (imageFile == null) {
  //       throw Exception('No image file provided.');
  //     }

  //     try {
  //       // Upload image to Firebase Storage
  //       String folderName = 'buktipjd'; // Nama folder yang diinginkan
  //       String fileName =
  //           '$folderName/' + DateTime.now().millisecondsSinceEpoch.toString();
  //       firebase_storage.Reference ref =
  //           firebase_storage.FirebaseStorage.instance.ref().child(fileName);
  //       File image = File(imageFile.path);
  //       int fileSize = image.lengthSync();

  //       Uint8List? compressedImage =
  //           await FlutterImageCompress.compressWithFile(
  //         image.path,
  //         quality: 90,
  //       );
  //       await ref.putData(compressedImage!);

  //       String downloadURL = await ref.getDownloadURL();
  //       return downloadURL;
  //     } catch (e) {
  //       throw Exception('Failed to upload image to Firestore: $e');
  //     }
  //   }

  //   Future<void> updateImage(DocumentSnapshot<Object?> documentSnapshot,
  //       BuildContext context) async {
  //     try {
  //       if (imageFileList.isEmpty) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.yellowAccent,
  //           content: Text(
  //             'Tidak ada pembaruan foto',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //         ));
  //         return;
  //       }

  //       // Hapus foto-foto lama dari Firebase Storage
  //       List<String> existingImageUrls =
  //           List<String>.from(documentSnapshot['imageUrl']);
  //       for (var imageUrl in existingImageUrls) {
  //         await firebase_storage.FirebaseStorage.instance
  //             .refFromURL(imageUrl)
  //             .delete();
  //       }

  //       List<String> imageUrls = [];

  //       // Upload foto-foto baru ke Firebase Storage
  //       for (var imageFile in imageFileList) {
  //         String downloadURL = await uploadImageToFirestore(imageFile);
  //         imageUrls.add(downloadURL);
  //       }

  //       // Update imageFileList dengan foto-foto baru
  //       imageFileList = imageUrls.map<XFile>((imageUrl) {
  //         return XFile(imageUrl);
  //       }).toList();

  //       // Perbarui dokumen di Firestore dengan URL foto yang baru
  //       await _buktiKegiatan.doc(documentSnapshot.id).update({
  //         'imageUrl': imageUrls,
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text('Foto berhasil diperbarui'),
  //       ));
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text('Gagal memperbarui foto'),
  //       ));
  //     }
  //   }

  //   void selectImages() async {
  //     try {
  //       List<XFile>? pickedImages = await imagePicker.pickMultiImage(
  //         imageQuality: 90,
  //       );
  //       if (pickedImages != null) {
  //         imageFileList.addAll(pickedImages);
  //       }
  //     } on PlatformException catch (e) {
  //       print('Failed to pick images: $e');
  //     }
  //   }

  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         var _selectedName = documentSnapshot['nama'];
  //         return DraggableScrollableSheet(
  //           expand: false,
  //           builder: (context, scrollController) {
  //             return SingleChildScrollView(
  //               controller: scrollController,
  //               child: Padding(
  //                 padding: EdgeInsets.only(
  //                     top: 20,
  //                     left: 20,
  //                     right: 20,
  //                     bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     TextField(
  //                       keyboardType: TextInputType.none,
  //                       controller: _no,
  //                       enabled: false,
  //                       decoration: const InputDecoration(labelText: 'Nomor'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.none,
  //                       controller: _nama,
  //                       enabled: false,
  //                       decoration: const InputDecoration(labelText: 'Nomor'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.none,
  //                       controller: _nip,
  //                       enabled: false,
  //                       decoration: const InputDecoration(labelText: 'Nomor'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.none,
  //                       controller: _jabatan,
  //                       enabled: false,
  //                       decoration: const InputDecoration(labelText: 'Nomor'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.text,
  //                       controller: _tempat,
  //                       enabled: false,
  //                       decoration: const InputDecoration(labelText: 'Tempat'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: 2,
  //                       controller: _keperluan,
  //                       enabled: false,
  //                       decoration:
  //                           const InputDecoration(labelText: 'Keperluan'),
  //                     ),
  //                     DateTimeField(
  //                       format: DateFormat('yyyy-MM-dd'),
  //                       onShowPicker:
  //                           (BuildContext context, DateTime? currentValue) {
  //                         return showDatePicker(
  //                           context: context,
  //                           firstDate: DateTime(1900),
  //                           initialDate: currentValue ?? DateTime.now(),
  //                           lastDate: DateTime(2100),
  //                         );
  //                       },
  //                       controller: _tgl_awal,
  //                       enabled: false,
  //                       decoration: const InputDecoration(
  //                         prefixIcon: Icon(Icons.date_range_outlined),
  //                         labelText: 'Tanggal Awal',
  //                       ),
  //                     ),
  //                     DateTimeField(
  //                       format: DateFormat('yyyy-MM-dd'),
  //                       onShowPicker:
  //                           (BuildContext context, DateTime? currentValue) {
  //                         return showDatePicker(
  //                           context: context,
  //                           firstDate: DateTime(1900),
  //                           initialDate: currentValue ?? DateTime.now(),
  //                           lastDate: DateTime(2100),
  //                         );
  //                       },
  //                       controller: _tgl_akhir,
  //                       enabled: false,
  //                       decoration: const InputDecoration(
  //                         prefixIcon: Icon(Icons.date_range_outlined),
  //                         labelText: 'Tanggal Akhir',
  //                       ),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: 3,
  //                       controller: _dasar,
  //                       decoration: const InputDecoration(labelText: 'Dasar'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: 3,
  //                       controller: _hasil,
  //                       decoration: const InputDecoration(
  //                           labelText: 'Bukti Hasil Perjalanan Dinas'),
  //                     ),
  //                     ListTile(
  //                       title: Text('Upload Bukti Foto Kegiatan'),
  //                       subtitle: Padding(
  //                         padding:
  //                             EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
  //                         child: Row(
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: selectImages,
  //                               child: Text('Select Image'),
  //                             ),
  //                             SizedBox(width: 10.0),
  //                             Expanded(
  //                               child:SingleChildScrollView(
  //                                   scrollDirection: Axis.horizontal,
  //                                   child: Row(
  //                                     children: [
  //                                       for (var imageFile
  //                                           in imageFileList)
  //                                         Container(
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 5.0),
  //                                           height: 50.0,
  //                                           width: 50.0,
  //                                           child: Image.file(
  //                                             File(imageFile.path),
  //                                             fit: BoxFit.cover,
  //                                             errorBuilder: (context, error,
  //                                                     stackTrace) =>
  //                                                 Icon(Icons.error),
  //                                           ),
  //                                         ),
  //                                       for (var imageUrl
  //                                           in documentSnapshot['imageUrl'])
  //                                         Container(
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 5.0),
  //                                           height: 50.0,
  //                                           width: 50.0,
  //                                           child: Image.network(
  //                                             imageUrl,
  //                                             fit: BoxFit.cover,
  //                                             errorBuilder: (context, error,
  //                                                     stackTrace) =>
  //                                                 Icon(Icons.error),
  //                                           ),
  //                                         ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white, // background
  //                             foregroundColor: Colors.blue, // foreground
  //                           ),
  //                           child: const Text('Update'),
  //                           onPressed: () async {
  //                             if (imageFileList != null) {
  //                               await updateImage(documentSnapshot, context);
  //                             }
  //                             final int no = int.parse(_no.text);
  //                             final String dasar = _dasar.text;
  //                             final String nama = _selectedName;
  //                             final String nip = _nip.text;
  //                             final String jabatan = _jabatan.text;
  //                             final String keperluan = _keperluan.text;
  //                             final String tempat = _tempat.text;
  //                             final DateTime firstDate =
  //                                 DateTime.parse(_tgl_awal.text);
  //                             final DateTime endDate =
  //                                 DateTime.parse(_tgl_akhir.text);
  //                             final String hasil = _hasil.text;
  //                             if (no != null) {
  //                               await _buktiKegiatan
  //                                   .doc(documentSnapshot.id)
  //                                   .update({
  //                                 "id": no,
  //                                 'dasar': dasar,
  //                                 'nama': nama,
  //                                 'nip': nip,
  //                                 'jabatan': jabatan,
  //                                 'keperluan': keperluan,
  //                                 'tempat': tempat,
  //                                 'tgl_awal': firstDate,
  //                                 'tgl_akhir': endDate,
  //                                 'hasil': hasil,
  //                               });
  //                               _no.text = '';
  //                               _selectedName = '';
  //                               _jabatan.text = '';
  //                               _nip.text = '';
  //                               _tempat.text = '';
  //                               _keperluan.text = '';
  //                               _tgl_awal.text = '';
  //                               _tgl_akhir.text = '';
  //                               _dasar.text = '';
  //                               _hasil.text = '';
  //                               Navigator.of(context).pop();
  //                               Navigator.of(context).pop();
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                   const SnackBar(
  //                                       backgroundColor: Colors.green,
  //                                       content:
  //                                           Text('Berhasil Memperbarui Data')));
  //                             }
  //                           },
  //                         ),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         ElevatedButton(
  //                           onPressed: (() => Navigator.pop(context)),
  //                           child: const Text("Cencel"),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white, // background
  //                             foregroundColor: Colors.red, // foreground
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }
}
