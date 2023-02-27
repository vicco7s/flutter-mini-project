import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kec_app/page/agenda/Suratmasuk/FormSuratMasuk.dart';

class SpeedDialFloating extends StatelessWidget {
  const SpeedDialFloating({
    Key? key,
    this.onPress,
    this.animatedIcons, this.childs, this.ontap,
  }) : super(key: key);

  final Function()? onPress;
  final AnimatedIconData? animatedIcons;
  final Widget? childs;
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: animatedIcons,
      backgroundColor: Colors.blue,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      onPress: ontap,
    );
  }
}
