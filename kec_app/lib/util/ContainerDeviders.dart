
import 'package:flutter/material.dart';

Container Containers() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15), // Mengatur padding horizontal
    child: Divider(thickness: 0.5, color: Colors.black),
  );
}

TextStyle TextStyleTitles() => TextStyle(color: Colors.deepPurple,fontSize: 11);
TextStyle TextStyleSubtitles() => TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple);