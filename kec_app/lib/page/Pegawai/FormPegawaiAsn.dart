import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/controller/controllerPegawai.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:intl/intl.dart';

class FormPegawaiAsn extends StatefulWidget {
  const FormPegawaiAsn({super.key});

  @override
  State<FormPegawaiAsn> createState() => _FormPegawaiAsnState();
}

class _FormPegawaiAsnState extends State<FormPegawaiAsn> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _nip = TextEditingController();
  final TextEditingController _jabatan = TextEditingController();
  final TextEditingController _tmulaitugas = TextEditingController();
  final TextEditingController _tlahir = TextEditingController();
  final TextEditingController _telp = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tempatlahir = TextEditingController();
  final TextEditingController _jumlahAnak = TextEditingController();
  
  final dataPegawai = ControllerPegawai();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text('Masukan Data Pegawai Asn'),
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
                          firstDate: DateTime(2000),
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
                          firstDate: DateTime(2000),
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
                      top: 10.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: TextFormFields(
                      controllers: _jabatan,
                      labelTexts: 'Jabatan',
                      keyboardtypes: TextInputType.text,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "Jabatan Tidak Boleh Kosong !";
                        }
                        return null;
                      },
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
                      labelTitle: "Status Perkawinan",
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
                      keyboardtypes: TextInputType.number,
                      validators: (value) {
                        if (value!.isEmpty) {
                          return "telp Tidak Boleh Kosong !";
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final inputAsn = InputAsn(
                          nama: _nama.text,
                          nip: int.parse(_nip.text),
                          pangkat: pakat,
                          golongan: gol,
                          jabatan: _jabatan.text,
                          status: stas, 
                          jenis_kelamin: jk, 
                          alamat: _alamat.text, 
                          jumlah_anak: int.parse(_jumlahAnak.text), 
                          pendidikan_terakhir: pendidikan_ak, 
                          status_perkawinan: sperkawinan, 
                          tanggal_mulai_tugas: DateTime.parse(_tmulaitugas.text), 
                          tempat_lahir: _tempatlahir.text, 
                          tgl_lahir: DateTime.parse(_tlahir.text), 
                          telp: int.parse(_telp.text),
                        );
                        dataPegawai.createInputSurel(inputAsn);
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
