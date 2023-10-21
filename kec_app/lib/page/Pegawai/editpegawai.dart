import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../components/DropdownButtomFormUpdates.dart';
import '../../controller/controlerPegawai/controllerPegawai.dart';
import '../../util/OptionDropDown.dart';
import '../../util/controlleranimasiloading/controlleranimasiprogressloading.dart';
import '../../util/shortpath.dart';

class EditPegawai extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const EditPegawai({super.key, required this.documentSnapshot});

  @override
  State<EditPegawai> createState() => _EditPegawaiState();
}

class _EditPegawaiState extends State<EditPegawai> {
  File? _selectedImage;

  File? _selectedImageKtp;

  final CollectionReference pegawai =
      FirebaseFirestore.instance.collection('pegawai');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  bool _isloading = false;

  final uploadImages = ControllerPegawai();

  final _formkey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _nama = TextEditingController();
  final _nip = MaskedTextController(mask: '00000000 000000 0 000');
  final _jabatan = TextEditingController();
  final _tmulaitugas = TextEditingController();
  final _tlahir = TextEditingController();
  final _agama = TextEditingController();
  final _telp = MaskedTextController(mask: '0000 0000 0000');
  final _alamat = TextEditingController();
  final _tempatlahir = TextEditingController();
  final _jumlahAnak = TextEditingController();

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
    _agama.text = documentSnapshot['agama'];
    _jabatan.text = documentSnapshot['jabatan'];
    _tmulaitugas.text = times1.toString();
    _tlahir.text = timers.toString();
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

  Future<void> pickImageKtp() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImageKtp = File(pickedImage.path);
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
                values: _jk,
              ),
              //tgl lahir
              DateTimeField(
                format: DateFormat('yyyy-MM-dd'),
                onShowPicker: (BuildContext context, DateTime? currentValue) {
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
                onShowPicker: (BuildContext context, DateTime? currentValue) {
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
              // agama
              TextField(
                keyboardType: TextInputType.text,
                controller: _agama,
                decoration: const InputDecoration(
                  labelText: 'Agama',
                ),
              ),
              // pendidikan terakhir
              DropdownButtonFormUpdates(
                labelTitle: "pendidikan terakhir",
                itemes: pendidikan_akhir.map((String dropDownStringItem) {
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
                padding: EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen),
                      ),
                      onPressed: pickImage,
                      child: Text('Ubah Foto Profil'),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        _selectedImage != null
                            ? 'foto sudah dipilih'
                            : shortenImageUpdate(
                                widget.documentSnapshot['imageUrl']),
                        style: TextStyle(
                          color: _selectedImage != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen),
                      ),
                      onPressed: pickImageKtp,
                      child: Text('Ubah Foto Ktp'),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        _selectedImageKtp != null
                            ? 'foto sudah dipilih'
                            : shortenImageUpdate(
                                widget.documentSnapshot['imageKtp']),
                        style: TextStyle(
                          color: _selectedImageKtp != null
                              ? Colors.green
                              : Colors.grey,
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
                  Expanded(
                    child: ElevatedButton(
                      child: _isloading
                          ? ColorfulLinearProgressIndicator() // Display loading indicator when loading
                          : Text('Update'),
                      onPressed: _isloading
                          ? null
                          : () async {
                              setState(() {
                                _isloading = true; // Set loading state to true
                              });
                              // condition update image
                              if (_selectedImage != null) {
                                await uploadImages.updateImage(_selectedImage!,
                                    widget.documentSnapshot.id);
                              } else if (_selectedImageKtp != null) {
                                await uploadImages.updateImageKtp(
                                    _selectedImageKtp!,
                                    widget.documentSnapshot.id);
                              }
                              final int no = int.parse(_id.text);
                              final String nama = _nama.text;
                              final String nip = _nip.text;
                              final String agama = _agama.text;
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
                                WriteBatch batch =
                                    FirebaseFirestore.instance.batch();
                                // Update the users collection
                                QuerySnapshot usersSnapshot = await users
                                    .where("uid",
                                        isEqualTo: widget.documentSnapshot.id)
                                    .get();
                                for (var doc in usersSnapshot.docs) {
                                  batch.update(doc.reference, {"nama": nama});
                                }
                                // Update the pegawai collection
                                batch.update(
                                  pegawai.doc(widget.documentSnapshot.id),
                                  {
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
                                    "agama": agama,
                                    "pendidikan_terakhir": peak,
                                    "status_pernikahan": stper,
                                    "jumlah_anak": jumlahanak,
                                    "telpon": telp,
                                  },
                                );
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
                                _agama.text = "";
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
                                        content:
                                            Text('Berhasil Memperbarui Data')));
                                await batch.commit();
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
      ),
    );
  }
}
