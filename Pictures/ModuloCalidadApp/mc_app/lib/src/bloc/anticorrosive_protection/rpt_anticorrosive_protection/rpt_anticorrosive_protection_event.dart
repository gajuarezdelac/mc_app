import 'package:flutter/material.dart';

@immutable
abstract class RptAnticorrosiveProtectionEvent {
  final String noRegistro;

  RptAnticorrosiveProtectionEvent({this.noRegistro});
}

class GetRptAP extends RptAnticorrosiveProtectionEvent {
  GetRptAP({
    @required String noRegistro,
  }) : super(noRegistro: noRegistro);
}
