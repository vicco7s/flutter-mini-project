import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratBatal/suratbatalCamat.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratPengganti/ListSuratPengganticamat.dart';

class DrawerCamatHome extends StatelessWidget {
  const DrawerCamatHome({
    super.key, required this.currentUser,
  });

  final FirebaseAuth currentUser;
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: DrawerHeader(
                  decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  color: Colors.blue,
                ),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text('Hallo,'+ ' ' + "Bapak Camat"),
                    subtitle: Text('Selamat Datang'),
                    onTap: () {
                      
                    },
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.send_outlined),
              title: Text('Surat menolak pejalanan dinas'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SuratBatalCamat()));
              },
            ),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('Data Surat Peganti Perjalanan Dinas'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ListSuratPenggantiCamat()));
              },
            ),
          ],
        ),

        ListTile(
          leading: Text('Powered By Uniska'),
        ),
        
        ],
      ),
    );
  }
}
