// ignore: must_be_immutable
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ButtonRwytPendidikan extends StatelessWidget {
  Function(String, DateTime, DateTime) tambahPendidikan;
  ButtonRwytPendidikan({
    super.key,
    required this.tambahPendidikan,
  });

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final controller = TextEditingController();
    final tahunmulai = TextEditingController();
    final tahunberakhir = TextEditingController();
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Pendidikan Baru'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "pendidikan Tidak Boleh Kosong !";
                  }
                  return null;
                },
              ),
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
                validator: (value) {
                  if ((value.toString().isEmpty) ||
                      (DateTime.tryParse(value.toString()) == null)) {
                    return "Tahun mulai bekerja tidak boleh kosong !";
                  }
                  return null;
                },
                controller: tahunmulai,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tahun Mulai',
                ),
              ),
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
                validator: (value) {
                  if ((value.toString().isEmpty) ||
                      (DateTime.tryParse(value.toString()) == null)) {
                    return "Tahun Berakhir bekerja tidak boleh kosong !";
                  }
                  return null;
                },
                controller: tahunberakhir,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tahun Berakhir',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    final pendidikanBaru = controller.text;
                    final tahunBaru = DateTime.parse(tahunmulai.text);
                    final tahunAkhir = DateTime.parse(tahunberakhir.text);
                    if (pendidikanBaru.isNotEmpty &&
                        tahunBaru != true &&
                        tahunAkhir != true) {
                      await tambahPendidikan(
                        pendidikanBaru,
                        tahunBaru,
                        tahunAkhir,
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Berhasil Ditambahkan')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Gagal Menambahkan Data')));
                  }
                },
                child: Text('Tambahkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonRwytPekerjaan extends StatelessWidget {
  Function(String, DateTime, DateTime) tambahPekerjaan;
  ButtonRwytPekerjaan({
    super.key,
    required this.tambahPekerjaan,
  });

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final controller = TextEditingController();
    final tahunmulai = TextEditingController();
    final tahunberakhir = TextEditingController();
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Posisi Pekerjaan'),
              ),
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
                validator: (value) {
                  if ((value.toString().isEmpty) ||
                      (DateTime.tryParse(value.toString()) == null)) {
                    return "Tahun mulai bekerja tidak boleh kosong !";
                  }
                  return null;
                },
                controller: tahunmulai,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tahun Mulai',
                ),
              ),
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
                validator: (value) {
                  if ((value.toString().isEmpty) ||
                      (DateTime.tryParse(value.toString()) == null)) {
                    return "Tahun Berakhir bekerja tidak boleh kosong !";
                  }
                  return null;
                },
                controller: tahunberakhir,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range_outlined),
                  labelText: 'Tahun Berakhir',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    final pekerjaanBaru = controller.text;
                    final tahunBaru = DateTime.parse(tahunmulai.text);
                    final tahunAkhir = DateTime.parse(tahunberakhir.text);
                    if (pekerjaanBaru.isNotEmpty && tahunBaru != true && tahunAkhir != true) {
                      await tambahPekerjaan(pekerjaanBaru, tahunBaru, tahunAkhir);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Berhasil Ditambahkan')));
                  }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Gagal Ditambahkan')));
                  }
                },
                child: Text('Tambahkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}