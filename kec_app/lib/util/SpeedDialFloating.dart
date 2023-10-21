import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialFloating extends StatelessWidget {
  const SpeedDialFloating({
    Key? key,
    this.animatedIcons,
    this.childs,
    this.ontap,
    this.icons, this.backColors,
  }) : super(key: key);

  final AnimatedIconData? animatedIcons;
  final Widget? childs;
  final Function()? ontap;
  final IconData? icons;
  final Color? backColors;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: animatedIcons,
      backgroundColor: backColors,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      onPress: ontap,
      icon: icons,
      
    );
  }
}
