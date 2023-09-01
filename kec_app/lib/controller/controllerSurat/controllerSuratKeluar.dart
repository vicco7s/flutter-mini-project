import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/model/suratkeluarService.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

class ControllerSK {
  final CollectionReference suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');

  void createOutputSurel(OutputSurel outputSurel) async {
    final CollectionReference<Map<String, dynamic>> _suratkeluar =
        FirebaseFirestore.instance.collection('suratkeluar');
    final json = outputSurel.toJson();
    var querySnapshot =
        await _suratkeluar.orderBy("no", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("no") : 0;
    json["no"] = maxId + 1;
    await _suratkeluar.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      final snapshot = await suratkeluar.doc(id).get();
      final data = snapshot.data();

      if (snapshot.exists &&
          data != null &&
          data is Map<String, dynamic> &&
          data['berkas'] != null) {
        final filePdf = data['berkas'];

        await FirebaseStorage.instance.refFromURL(filePdf).delete();

        await suratkeluar.doc(id).delete();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Data Berhasil Dihapus'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }else{
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

}

//edit dengan class steful terpisah
class EditSuratKeluar extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const EditSuratKeluar({super.key, required this.documentSnapshot});

  @override
  State<EditSuratKeluar> createState() => _EditSuratKeluarState();
}

class _EditSuratKeluarState extends State<EditSuratKeluar> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _no = TextEditingController();
  final TextEditingController _noBerkas = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _perihal = TextEditingController();

  final CollectionReference suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');

  File? _selectedPdf;

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    DocumentSnapshot documentSnapshot = widget.documentSnapshot;
    Timestamp timerstamp = documentSnapshot['tanggal'];

    var date = timerstamp.toDate();
    var timers = DateFormat('yyyy-MM-dd').format(date);

    _no.text = documentSnapshot['no'].toString();
    _noBerkas.text = documentSnapshot['no_berkas'];
    _alamat.text = documentSnapshot['alamat_penerima'];
    _tanggal.text = timers.toString();
    _perihal.text = documentSnapshot['perihal'];
  }

  Future<void> pickPdfUpdate() async {
    FilePickerResult? filepicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (filepicker != null && filepicker.files.isNotEmpty) {
      String? filePath = filepicker.files.single.path;
      File file = File(filePath!);
      int fileSize = await file.length();
      if (fileSize > 1000000) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File PDF yang diupload lebih dari 1MB'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          _selectedPdf = file;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File path is not nullable'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updatePdfFile(File? pdfFile, String documentID) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('berkas/' + DateTime.now().millisecondsSinceEpoch.toString());

      // Mengambil URL gambar sebelumnya dari Firestore
      DocumentSnapshot docSnapshot = await suratkeluar.doc(documentID).get();
      String previousPdfFile = docSnapshot.get('berkas');

      // Menghapus foto sebelumnya dari Firebase Storage jika ada
      if (previousPdfFile != null) {
        Reference previousImageRef = storage.refFromURL(previousPdfFile);
        await previousImageRef.delete();
      }

      if (pdfFile != null) {
        UploadTask uploadTask = storageReference.putFile(pdfFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String filePdf = await taskSnapshot.ref.getDownloadURL();

        suratkeluar.doc(documentID).update({
          'berkas': filePdf,
        });
      }
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    var options = [
      'sudah dikirim',
      'belum dikirim',
    ];
    var _currentItemSelected = widget.documentSnapshot['keterangan'];
    var ket = widget.documentSnapshot['keterangan'];
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            AppBar(
              elevation: 0.0,
              title: Text('Edit Surat Keluar'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.expand_more_outlined)),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Padding(
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
                    keyboardType: TextInputType.text,
                    controller: _noBerkas,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Berkas',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _alamat,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Pengirim',
                    ),
                  ),
                  DateTimeField(
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.date_range_outlined),
                      labelText: 'Tanggal',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _perihal,
                    decoration: const InputDecoration(
                      labelText: 'Perihal',
                    ),
                  ),
                  DropdownButtonFormField<String>(
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
                      var _currentItemSelected = newValueSelected!;
                      ket = newValueSelected;
                    },
                    value: _currentItemSelected,
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
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
                          onPressed: pickPdfUpdate,
                          child: Text('Tambah PDF'),
                        ),
                        SizedBox(width: 10.0),
                        _selectedPdf != null
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 7, bottom: 7, left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(10)),
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
                            : Expanded(
                                child: Text(
                                  '${widget.documentSnapshot['berkas'].split('/').last.split('?').first}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                      ],
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
                          child: _isloading
                          ? ColorfulLinearProgressIndicator()
                          : Text('Update'),
                          onPressed: _isloading
                          ? null
                          : () async {
                            setState(() {
                                  _isloading = true; // Set loading state to true
                            });
                            if (_selectedPdf != null) {
                              await updatePdfFile(
                                  _selectedPdf, widget.documentSnapshot.id);
                            }
                            final int no = int.parse(_no.text);
                            final String no_berkas = _noBerkas.text;
                            final String alamat = _alamat.text;
                            final DateTime tanggal =
                                DateTime.parse(_tanggal.text);
                            final String perihal = _perihal.text;
                            if (no != null) {
                              await suratkeluar
                                  .doc(widget.documentSnapshot.id)
                                  .update({
                                "no": no,
                                "no_berkas": no_berkas,
                                "alamat_penerima": alamat,
                                "tanggal": tanggal,
                                "perihal": perihal,
                                "keterangan": ket
                              });
                              _no.text = '';
                              _noBerkas.text = '';
                              _alamat.text = '';
                              _tanggal.text = '';
                              _perihal.text = '';
                              ket = '';
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content:
                                          Text('Berhasil Memperbarui Data')));
                            }
                            setState(() {
                              _isloading = false; // Set loading state to true
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: (() => Navigator.pop(context)),
                        child: const Text("Cencel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // background
                          foregroundColor: Colors.white, // foreground
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
