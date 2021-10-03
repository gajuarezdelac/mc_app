import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showNotificationSnackBar(BuildContext _context,
    {String title,
    String mensaje,
    Icon icon,
    int secondsDuration,
    Color colorBarIndicator,
    double borde}) {
  Future.delayed(Duration.zero, () {
    if (title == "") {
      Flushbar(
        margin: EdgeInsets.all(8),
        icon: icon,
        duration: Duration(seconds: secondsDuration),
        leftBarIndicatorColor: colorBarIndicator,
        borderRadius: borde,
        message: mensaje,
      )..show(_context);
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        icon: icon,
        duration: Duration(seconds: secondsDuration),
        leftBarIndicatorColor: colorBarIndicator,
        borderRadius: borde,
        title: title,
        message: mensaje,
      )..show(_context);
    }
  });
}

Flushbar showNotificationSnackBarHide(BuildContext _context,
    {String title,
    String mensaje,
    Icon icon,
    int secondsDuration,
    Color colorBarIndicator,
    double borde}) {

    if (title == "") {
     return Flushbar(
        margin: EdgeInsets.all(8),
        icon: icon,
        duration: Duration(seconds: secondsDuration),
        leftBarIndicatorColor: colorBarIndicator,
        borderRadius: borde,
        message: mensaje,
      );
    } else {
    return  Flushbar(
        margin: EdgeInsets.all(8),
        icon: icon,
        duration: Duration(seconds: secondsDuration),
        leftBarIndicatorColor: colorBarIndicator,
        borderRadius: borde,
        title: title,
        message: mensaje,
      );
    }
    }
