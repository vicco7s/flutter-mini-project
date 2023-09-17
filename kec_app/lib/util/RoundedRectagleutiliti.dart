
import 'package:flutter/cupertino.dart';

RoundedRectangleBorder RoundedRectangleBorders() {
    return const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
    ));
  }