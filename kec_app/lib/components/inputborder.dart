import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFields extends StatelessWidget {
  TextFormFields({super.key, 
    required this.controllers,
    required this.labelTexts,
    required this.keyboardtypes,
    this.validators,
    this.onChangeds,
    this.enableds,
  });

  final TextEditingController controllers;
  final String labelTexts;
  final TextInputType keyboardtypes;
  final String? Function(String?)? validators;
  void Function(String)? onChangeds;
  final bool? enableds;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllers,
      keyboardType: keyboardtypes,
      validator: validators,
      onChanged: onChangeds,
      enabled: enableds,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500]),
        // hintText: "Masukan Email",
        fillColor: Colors.white70,
        labelText: labelTexts,
      ),
    );
  }
}
