
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/page/Pegawai/FormPegawaiAsn.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:kec_app/util/shortpath.dart';

class EditPegawai extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const EditPegawai({super.key, required this.documentSnapshot});

  @override
  State<EditPegawai> createState() => _EditPegawaiState();
}

class _EditPegawaiState extends State<EditPegawai> {
  File? _selectedImage;

  final CollectionReference pegawai =
      FirebaseFirestore.instance.collection('pegawai');


  Future<void> updateImage(File imageFile, String documentID) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
          storage.ref().child('images/'+ DateTime.now().millisecondsSinceEpoch.toString());

    // Mengambil URL gambar sebelumnya dari Firestore
    DocumentSnapshot docSnapshot = await pegawai.doc(documentID).get();
    String previousImageUrl = docSnapshot.get('imageUrl');

    // Menghapus foto sebelumnya dari Firebase Storage jika ada
    if (previousImageUrl != null) {
      Reference previousImageRef = storage.refFromURL(previousImageUrl);
      await previousImageRef.delete();
    }

      if (imageFile != null) {
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        pegawai.doc(documentID).update({
          'imageUrl': imageUrl,
        });
      }
    } catch (error) {
      print(error);
      // Handle error
    }
  }

    final _formkey = GlobalKey<FormState>();
    final TextEditingController _id = TextEditingController();
    final TextEditingController _nama = TextEditingController();
    final  _nip = MaskedTextController(mask: '00000000 000000 0 000');
    final TextEditingController _jabatan = TextEditingController();
    final TextEditingController _tmulaitugas = TextEditingController();
    final TextEditingController _tlahir = TextEditingController();
    final _telp = MaskedTextController(mask: '0000 0000 0000');
    final TextEditingController _alamat = TextEditingController();
    final TextEditingController _tempatlahir = TextEditingController();
    final TextEditingController _jumlahAnak = TextEditingController();

    
    @override
    void initState() {
    super.initState();
    DocumentSnapshot documentSnapshot = widget.documentSnapshot;
    Timestamp timerstamp = documentSnapshot['tgl_lahir'];
    Timestamp timestamp = documentSnapshot['tgl_mulaitugas'];
    var date = timerstamp.toDate();
    var date1 = timestamp.toDate();
    var timers = DateFormat('yyyy-MM-dd').format(date);
    var times1 = DateFormat('yyyy-MM-dd').format(date1);

    _id.text = documentSnapshot['id'].toString();
    _nama.text = documentSnapshot['nama'];
    _nip.text = documentSnapshot['nip'];
    _jabatan.text = documentSnapshot['jabatan'];
    _tmulaitugas.text = timers.toString();
    _tlahir.text = times1.toString();
    _telp.text = documentSnapshot['telpon'];
    _alamat.text = documentSnapshot['alamat'];
    _tempatlahir.text = documentSnapshot['tempat_lahir'];
    _jumlahAnak.text = documentSnapshot['jumlah_anak'].toInt().toString();
  }
  


    Future<void> pickImage() async {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    }
    
  
  @override
  Widget build(BuildContext context) {
      var _pakat = widget.documentSnapshot['pangkat'];
      var _gol = widget.documentSnapshot['golongan'];
      var _stas = widget.documentSnapshot['status'];
      var _jk = widget.documentSnapshot['jenis_kelamin'];
      var _peak = widget.documentSnapshot['pendidikan_terakhir'];
      var _stper = widget.documentSnapshot['status_pernikahan'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Edit Pegawai'),
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
                          controller: _id,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'No',
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: _nama,
                          decoration: const InputDecoration(
                            labelText: 'Nama',
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _nip,
                          decoration: const InputDecoration(
                            labelText: 'Nip',
                          ),
                          
                        ),
                        //jenis kelamin
                        DropdownButtonFormUpdates(
                          labelTitle: "Jenis Kelamin",
                          itemes: jenis_k.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _jk = newValueSelected;
                          },
                          values: widget.documentSnapshot['jenis_kelamin'],
                        ),
                        //tgl lahir
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
                          controller: _tlahir,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.date_range_outlined),
                            labelText: 'Tanggal Lahir',
                          ),
                        ),
                        //tempat lahir
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: _tempatlahir,
                          decoration: const InputDecoration(
                            labelText: 'Tempat Lahir',
                          ),
                        ),
                        // tgl mulai tugas
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
                          controller: _tmulaitugas,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.date_range_outlined),
                            labelText: 'Tanggal Mulai Tugas',
                          ),
                        ),
                        // alamat
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: _alamat,
                          decoration: const InputDecoration(
                            labelText: 'Alamat',
                          ),
                        ),
                        // pendidikan terakhir
                        DropdownButtonFormUpdates(
                          labelTitle: "pendidikan terakhir",
                          itemes:
                              pendidikan_akhir.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _peak = newValueSelected;
                          },
                          values: widget.documentSnapshot['pendidikan_terakhir'],
                        ),
                        //pangkat
                        DropdownButtonFormUpdates(
                          labelTitle: "Pangkat",
                          itemes: pangkat.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _pakat = newValueSelected;
                          },
                          values: widget.documentSnapshot['pangkat'],
                        ),
                        // golongan
                        DropdownButtonFormUpdates(
                          labelTitle: "Golongan",
                          itemes: golongan.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _gol = newValueSelected;
                          },
                          values: widget.documentSnapshot['golongan'],
                        ),
                        //jabatan
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: _jabatan,
                          decoration: const InputDecoration(
                            labelText: 'Jabatan',
                          ),
                        ),
                        // status pegawai
                        DropdownButtonFormUpdates(
                          labelTitle: "Status",
                          itemes: status.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _stas = newValueSelected;
                          },
                          values: widget.documentSnapshot['status'],
                        ),
                        //status perkawinan
                        DropdownButtonFormUpdates(
                          labelTitle: "Status Pernikahan",
                          itemes: s_perkawinan.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                              ),
                            );
                          }).toList(),
                          onchage: (newValueSelected) {
                            var _currentItemSelected = newValueSelected!;
                            _stper = newValueSelected;
                          },
                          values: widget.documentSnapshot['status_pernikahan'],
                        ),

                        //jumlah anak
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _jumlahAnak,
                          decoration: const InputDecoration(
                            labelText: 'Jumlah Anak',
                          ),
                        ),
                        //telp
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _telp,
                          decoration: const InputDecoration(
                            labelText: 'Telpon',
                          ),

                        ),

                        //Update Foto
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.lightGreen),
                                ),
                                onPressed: pickImage,
                                child: Text('Select Image'),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                _selectedImage != null ? 'foto sudah dipilih' : shortenImageUpdate(widget.documentSnapshot['imageUrl']),
                                style: TextStyle(
                                  color: _selectedImage != null ? Colors.green : Colors.grey,
                                ),
                              ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text('Update'),
                              onPressed: () async {
                               // condition update image
                                if (_selectedImage != null) {
                                  await updateImage(
                                      _selectedImage!, widget.documentSnapshot.id);
                                }

                                final int no = int.parse(_id.text);
                                final String nama = _nama.text;
                                final String nip = _nip.text;
                                final DateTime tglmulai =
                                    DateTime.parse(_tmulaitugas.text);
                                final DateTime tgllahir =
                                    DateTime.parse(_tlahir.text);
                                final String telp = _telp.text;
                                final String alamat = _alamat.text;
                                final String temlahir = _tempatlahir.text;
                                final int jumlahanak =
                                    int.parse(_jumlahAnak.text);
                                final String pangkat = _pakat;
                                final String golongan = _gol;
                                final String jabatan = _jabatan.text;
                                final String status = _stas;
                                final String jk = _jk;
                                final String peak = _peak;
                                final String stper = _stper;
                                if (no != null) {
                                  await pegawai
                                      .doc(widget.documentSnapshot.id)
                                      .update({
                                    "id": no,
                                    "nama": nama,
                                    "nip": nip,
                                    "pangkat": pangkat,
                                    "golongan": golongan,
                                    "jabatan": jabatan,
                                    "status": status,
                                    "jenis_kelamin": jk,
                                    "tgl_lahir": tgllahir,
                                    "tempat_lahir": temlahir,
                                    "tgl_mulaitugas": tglmulai,
                                    "alamat": alamat,
                                    "pendidikan_terakhir": peak,
                                    "status_pernikahan": stper,
                                    "jumlah_anak": jumlahanak,
                                    "telpon": telp,
                                  });
                                  _id.text = '';
                                  _nama.text = '';
                                  _nip.text = '';
                                  _pakat = '';
                                  _gol = '';
                                  _jabatan.text = '';
                                  _stas = '';
                                  _alamat.text = '';
                                  _jk = '';
                                  _jumlahAnak.text = '';
                                  _peak = '';
                                  _stper = '';
                                  _telp.text = '';
                                  _tempatlahir.text = '';
                                  _tlahir.text = '';
                                  _tmulaitugas.text = '';
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              'Berhasil Memperbarui Data')));
                                }
                              },
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
      ),
    );
  }
}