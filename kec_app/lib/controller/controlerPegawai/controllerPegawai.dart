import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage ;
import '../../page/Pegawai/FormPegawaiAsn.dart';
import '../../util/shortpath.dart';

class ControllerPegawai {
  final CollectionReference pegawai =
      FirebaseFirestore.instance.collection('pegawai');

  void createInputPegawai(InputAsn inputAsn) async {
    final json = inputAsn.toJson();
    var querySnapshot =
        await pegawai.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    json["imageUrl"] = inputAsn.imageUrl;
    await pegawai.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
     // Dapatkan URL gambar dari Firestore
    final snapshot = await pegawai.doc(id).get();
    final data = snapshot.data();
    if (snapshot.exists &&
        data != null &&
        data is Map<String, dynamic> &&
        data['imageUrl'] != null) {
      final imageUrl = data['imageUrl'];

      // Hapus dokumen dari Firestore
      await pegawai.doc(id).delete();

      // Hapus imageUrl dari Firebase Storage
      final storageRef = storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

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

  // File? _selectedImage;

  // Future<void> updateImage(File imageFile, String documentID) async {
  //   try {
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     Reference storageReference =
  //         storage.ref().child('images/$documentID.jpg');

  //     if (imageFile != null) {
  //       UploadTask uploadTask = storageReference.putFile(imageFile);
  //       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

  //       String imageUrl = await taskSnapshot.ref.getDownloadURL();

  //       pegawai.doc(documentID).update({
  //         'imageUrl': imageUrl,
  //       });
  //     }
  //   } catch (error) {
  //     print(error);
  //     // Handle error
  //   }
  // }

  // Future<void> update(
  //     DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
  //   final _formkey = GlobalKey<FormState>();
  //   final TextEditingController _id = TextEditingController();
  //   final TextEditingController _nama = TextEditingController();
  //   final TextEditingController _nip = TextEditingController();
  //   final TextEditingController _jabatan = TextEditingController();
  //   final TextEditingController _tmulaitugas = TextEditingController();
  //   final TextEditingController _tlahir = TextEditingController();
  //   final TextEditingController _telp = TextEditingController();
  //   final TextEditingController _alamat = TextEditingController();
  //   final TextEditingController _tempatlahir = TextEditingController();
  //   final TextEditingController _jumlahAnak = TextEditingController();

  //   Timestamp timerstamp = documentSnapshot['tgl_lahir'];
  //   Timestamp timestamp = documentSnapshot['tgl_mulaitugas'];
  //   var date = timerstamp.toDate();
  //   var date1 = timestamp.toDate();
  //   var timers = DateFormat('yyyy-MM-dd').format(date);
  //   var times1 = DateFormat('yyyy-MM-dd').format(date1);

  //   _id.text = documentSnapshot['id'].toString();
  //   _nama.text = documentSnapshot['nama'];
  //   _nip.text = documentSnapshot['nip'].toInt().toString();
  //   _jabatan.text = documentSnapshot['jabatan'];
  //   _tmulaitugas.text = timers.toString();
  //   _tlahir.text = times1.toString();
  //   _telp.text = documentSnapshot['telpon'].toInt().toString();
  //   _alamat.text = documentSnapshot['alamat'];
  //   _tempatlahir.text = documentSnapshot['tempat_lahir'];
  //   _jumlahAnak.text = documentSnapshot['jumlah_anak'].toInt().toString();

  //   bool _isImageSelected = false;

  //   Future<void> pickImage() async {
  //     final pickedImage =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedImage != null) {
  //       _selectedImage = File(pickedImage.path);
  //       _isImageSelected = true;
  //     }
  //   }


  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         var _pakat = documentSnapshot['pangkat'];
  //         var _gol = documentSnapshot['golongan'];
  //         var _stas = documentSnapshot['status'];
  //         var _jk = documentSnapshot['jenis_kelamin'];
  //         var _peak = documentSnapshot['pendidikan_terakhir'];
  //         var _stper = documentSnapshot['status_pernikahan'];
  //         return DraggableScrollableSheet(
  //             expand: false,
  //             builder: (context, scrollController) {
  //               return SingleChildScrollView(
  //                 controller: scrollController,
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                       top: 20,
  //                       left: 20,
  //                       right: 20,
  //                       bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       TextField(
  //                         keyboardType: TextInputType.none,
  //                         controller: _id,
  //                         enabled: false,
  //                         decoration: const InputDecoration(
  //                           labelText: 'No',
  //                         ),
  //                       ),
  //                       TextField(
  //                         keyboardType: TextInputType.text,
  //                         controller: _nama,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Nama',
  //                         ),
  //                       ),
  //                       TextField(
  //                         keyboardType: TextInputType.number,
  //                         controller: _nip,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Nip',
  //                         ),
  //                       ),
  //                       //jenis kelamin
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "Jenis Kelamin",
  //                         itemes: jenis_k.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _jk = newValueSelected;
  //                         },
  //                         values: documentSnapshot['jenis_kelamin'],
  //                       ),
  //                       //tgl lahir
  //                       DateTimeField(
  //                         format: DateFormat('yyyy-MM-dd'),
  //                         onShowPicker:
  //                             (BuildContext context, DateTime? currentValue) {
  //                           return showDatePicker(
  //                             context: context,
  //                             firstDate: DateTime(1900),
  //                             initialDate: currentValue ?? DateTime.now(),
  //                             lastDate: DateTime(2100),
  //                           );
  //                         },
  //                         controller: _tlahir,
  //                         decoration: const InputDecoration(
  //                           prefixIcon: Icon(Icons.date_range_outlined),
  //                           labelText: 'Tanggal Lahir',
  //                         ),
  //                       ),
  //                       //tempat lahir
  //                       TextField(
  //                         keyboardType: TextInputType.text,
  //                         controller: _tempatlahir,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Tempat Lahir',
  //                         ),
  //                       ),
  //                       // tgl mulai tugas
  //                       DateTimeField(
  //                         format: DateFormat('yyyy-MM-dd'),
  //                         onShowPicker:
  //                             (BuildContext context, DateTime? currentValue) {
  //                           return showDatePicker(
  //                             context: context,
  //                             firstDate: DateTime(1900),
  //                             initialDate: currentValue ?? DateTime.now(),
  //                             lastDate: DateTime(2100),
  //                           );
  //                         },
  //                         controller: _tmulaitugas,
  //                         decoration: const InputDecoration(
  //                           prefixIcon: Icon(Icons.date_range_outlined),
  //                           labelText: 'Tanggal Mulai Tugas',
  //                         ),
  //                       ),
  //                       // alamat
  //                       TextField(
  //                         keyboardType: TextInputType.text,
  //                         controller: _alamat,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Alamat',
  //                         ),
  //                       ),
  //                       // pendidikan terakhir
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "pendidikan terakhir",
  //                         itemes:
  //                             pendidikan_akhir.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _peak = newValueSelected;
  //                         },
  //                         values: documentSnapshot['pendidikan_terakhir'],
  //                       ),
  //                       //pangkat
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "Pangkat",
  //                         itemes: pangkat.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _pakat = newValueSelected;
  //                         },
  //                         values: documentSnapshot['pangkat'],
  //                       ),
  //                       // golongan
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "Golongan",
  //                         itemes: golongan.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _gol = newValueSelected;
  //                         },
  //                         values: documentSnapshot['golongan'],
  //                       ),
  //                       //jabatan
  //                       TextField(
  //                         keyboardType: TextInputType.text,
  //                         controller: _jabatan,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Jabatan',
  //                         ),
  //                       ),
  //                       // status pegawai
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "Status",
  //                         itemes: status.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _stas = newValueSelected;
  //                         },
  //                         values: documentSnapshot['status'],
  //                       ),
  //                       //status perkawinan
  //                       DropdownButtonFormUpdates(
  //                         labelTitle: "Status Perkawinan",
  //                         itemes: s_perkawinan.map((String dropDownStringItem) {
  //                           return DropdownMenuItem<String>(
  //                             value: dropDownStringItem,
  //                             child: Text(
  //                               dropDownStringItem,
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onchage: (newValueSelected) {
  //                           var _currentItemSelected = newValueSelected!;
  //                           _stper = newValueSelected;
  //                         },
  //                         values: documentSnapshot['status_pernikahan'],
  //                       ),

  //                       //jumlah anak
  //                       TextField(
  //                         keyboardType: TextInputType.number,
  //                         controller: _jumlahAnak,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Jumlah Anak',
  //                         ),
  //                       ),
  //                       //telp
  //                       TextField(
  //                         keyboardType: TextInputType.number,
  //                         controller: _telp,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Telpon',
  //                         ),
  //                       ),

  //                       Padding(
  //                         padding:
  //                             EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
  //                         child: Row(
  //                           children: [
  //                             ElevatedButton(
  //                               style: ButtonStyle(
  //                                 backgroundColor: MaterialStateProperty.all(
  //                                     Colors.lightGreen),
  //                               ),
  //                               onPressed: pickImage,
  //                               child: Text('Select Image'),
  //                             ),
  //                             SizedBox(width: 10.0),
  //                             Expanded(
  //                               child: Text(
  //                                 _isImageSelected 
  //                                     ? shortenImagePath(_selectedImage!.path)
  //                                     : "Foto belum dipilih",
  //                                 style: TextStyle(
  //                                   color: _isImageSelected ? Colors.green : Colors.red,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),

  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       Row(
  //                         children: [
  //                           ElevatedButton(
  //                             child: const Text('Update'),
  //                             onPressed: () async {
  //                               //condition update image
  //                               if (_selectedImage != null) {
  //                                 await updateImage(
  //                                     _selectedImage!, documentSnapshot.id);
  //                               }

  //                               final int no = int.parse(_id.text);
  //                               final String nama = _nama.text;
  //                               final int nip = int.parse(_nip.text);
  //                               final DateTime tglmulai =
  //                                   DateTime.parse(_tmulaitugas.text);
  //                               final DateTime tgllahir =
  //                                   DateTime.parse(_tlahir.text);
  //                               final int telp = int.parse(_telp.text);
  //                               final String alamat = _alamat.text;
  //                               final String temlahir = _tempatlahir.text;
  //                               final int jumlahanak =
  //                                   int.parse(_jumlahAnak.text);
  //                               final String pangkat = _pakat;
  //                               final String golongan = _gol;
  //                               final String jabatan = _jabatan.text;
  //                               final String status = _stas;
  //                               final String jk = _jk;
  //                               final String peak = _peak;
  //                               final String stper = _stper;
  //                               if (no != null) {
  //                                 await pegawai
  //                                     .doc(documentSnapshot.id)
  //                                     .update({
  //                                   "id": no,
  //                                   "nama": nama,
  //                                   "nip": nip,
  //                                   "pangkat": pangkat,
  //                                   "golongan": golongan,
  //                                   "jabatan": jabatan,
  //                                   "status": status,
  //                                   "jenis_kelamin": jk,
  //                                   "tgl_lahir": tgllahir,
  //                                   "tempat_lahir": temlahir,
  //                                   "tgl_mulaitugas": tglmulai,
  //                                   "alamat": alamat,
  //                                   "pendidikan_terakhir": peak,
  //                                   "status_perkawinan": stper,
  //                                   "jumlah_anak": jumlahanak,
  //                                   "telpon": telp,
  //                                 });
  //                                 _id.text = '';
  //                                 _nama.text = '';
  //                                 _nip.text = '';
  //                                 _pakat = '';
  //                                 _gol = '';
  //                                 _jabatan.text = '';
  //                                 _stas = '';
  //                                 _alamat.text = '';
  //                                 _jk = '';
  //                                 _jumlahAnak.text = '';
  //                                 _peak = '';
  //                                 _stper = '';
  //                                 _telp.text = '';
  //                                 _tempatlahir.text = '';
  //                                 _tlahir.text = '';
  //                                 _tmulaitugas.text = '';
  //                                 Navigator.pop(context);
  //                                 Navigator.pop(context);
  //                                 ScaffoldMessenger.of(context).showSnackBar(
  //                                     const SnackBar(
  //                                         backgroundColor: Colors.green,
  //                                         content: Text(
  //                                             'Berhasil Memperbarui Data')));
  //                               }
  //                             },
  //                           ),
  //                           const SizedBox(
  //                             width: 20,
  //                           ),
  //                           ElevatedButton(
  //                             onPressed: (() => Navigator.pop(context)),
  //                             child: const Text("Cencel"),
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: Colors.red, // background
  //                               foregroundColor: Colors.white, // foreground
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             });
  //       });
  // }
}