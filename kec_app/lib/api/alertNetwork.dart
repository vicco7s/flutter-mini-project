

import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tidak Ada Koneksi Internet",
              style: TextStyle(fontSize: 20),
            ),
            // Tambahkan tombol atau tindakan lain jika diperlukan
          ],
        ),
      ),
    );
  }
}