

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/page/Dashboard%20user/surat/formsuratbatalPJD.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';

class SuratbatalPjDinas extends StatefulWidget {
  const SuratbatalPjDinas({super.key});

  @override
  State<SuratbatalPjDinas> createState() => _SuratbatalPjDinasState();
}

class _SuratbatalPjDinasState extends State<SuratbatalPjDinas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Batal PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Text("No Data")
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () => Navigator.of(context).push(CupertinoPageRoute(builder: ((context) => FormSuratBatalPJD()))),
      ),
    );
  }
}