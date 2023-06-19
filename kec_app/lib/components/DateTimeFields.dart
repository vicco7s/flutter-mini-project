
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFields extends StatelessWidget {
  DateTimeFields({ required this.tanggalText, required this.controllers, required this.validators});

  final String? tanggalText;
  final TextEditingController? controllers;
  final String? Function(DateTime?)? validators;

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
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
                  controller: controllers,
                  validator: validators,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.date_range_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // hintText: "Masukan Email",
                    fillColor: Colors.white70,
                    labelText: tanggalText,
                  ),
                );
  }
}
