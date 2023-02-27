import 'package:flutter/material.dart';

class DropdownButtonFormUpdates extends StatelessWidget {
  DropdownButtonFormUpdates({
    this.itemes,
    this.onchage,
    this.labelTitle, this.values,
  });

  final List<DropdownMenuItem<String>>? itemes;
  final void Function(String?)? onchage;
  final String? labelTitle;
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
        decoration: InputDecoration(
          labelText: labelTitle,
        ),
    );
  }
}