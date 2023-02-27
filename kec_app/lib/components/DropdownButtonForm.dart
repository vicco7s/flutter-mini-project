import 'package:flutter/material.dart';

class DropdownButtonForms extends StatelessWidget {
  DropdownButtonForms({
    this.itemes,
    this.onchage,
    this.labelTitle, this.validators, this.values,
  });

  final List<DropdownMenuItem<String>>? itemes;
  final void Function(String?)? onchage;
  final String? labelTitle;
  final String? Function(String?)? validators;
  final String? values;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        iconEnabledColor: Colors.black,
        focusColor: Colors.black,
        items: itemes,
        value: values,
        onChanged: onchage,
        // value: _currentItemSelected,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          // hintText: "Masukan Email",
          fillColor: Colors.white70,
          labelText: labelTitle,
        ),
        validator: validators,
    );
  }
}
