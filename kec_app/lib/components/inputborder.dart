import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFields extends StatelessWidget {
  TextFormFields({
  required this.controllers, 
  required this.labelTexts, 
  required this.keyboardtypes, 
  required this.validators,
  
  });

  final TextEditingController controllers;
  final String labelTexts;
  final TextInputType keyboardtypes;
  final String? Function(String?)? validators; 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllers,
      keyboardType: keyboardtypes,
      validator: validators,
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
