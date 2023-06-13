import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerUser/controllerSuratBatal.dart';
import 'package:kec_app/model/UserService/suratbatalservice.dart';

class FormSuratBatalPJD extends StatefulWidget {
  const FormSuratBatalPJD({super.key});

  @override
  State<FormSuratBatalPJD> createState() => _FormSuratBatalPJDState();
}

class _FormSuratBatalPJDState extends State<FormSuratBatalPJD> {
  final _formkey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _tanggalSurat = TextEditingController();
  final _tanggalPerjalananDinas = TextEditingController();
  final _alasan = TextEditingController();

  String _status = "Proses";
  String _keterangan = "----";

  final dataSuratbatal = ControllerSuratBatal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Input Surat Batal PJD'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormFields(
                  controllers: _nama,
                  labelTexts: 'Nama',
                  keyboardtypes: TextInputType.text,
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Nama Tidak Boleh Kosong !";
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
                  onShowPicker: (BuildContext context, DateTime? currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                  controller: _tanggalSurat,
                  validator: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal surat Tidak Boleh Kosong !";
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
                    labelText: 'Tanggal Surat',
                  ),
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
                  onShowPicker: (BuildContext context, DateTime? currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                  controller: _tanggalPerjalananDinas,
                  validator: (value) {
                    if ((value.toString().isEmpty) ||
                        (DateTime.tryParse(value.toString()) == null)) {
                      return "Tanggal  Tidak Boleh Kosong !";
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
                    labelText: 'Tanggal Perjalanan Dinas',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormFields(
                  controllers: _alasan,
                  labelTexts: 'Alasan',
                  keyboardtypes: TextInputType.multiline,
                  maxlines: 5,
                  validators: (value) {
                    if (value!.isEmpty) {
                      return "Alasan Tidak Boleh Kosong !";
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      final suratBatal = SuratBatal(
                        nama: _nama.text,
                        tanggal_surat: DateTime.parse(_tanggalSurat.text),
                        tanggal_perjalanan:
                            DateTime.parse(_tanggalPerjalananDinas.text),
                        alasan: _alasan.text,
                        status: _status,
                        keterangan: _keterangan,
                      );
                      dataSuratbatal.createInputSuratBatal(suratBatal);
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
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
