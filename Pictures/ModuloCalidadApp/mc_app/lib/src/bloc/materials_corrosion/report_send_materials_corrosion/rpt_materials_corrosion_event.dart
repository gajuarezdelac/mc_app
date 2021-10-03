import 'package:flutter/material.dart';

@immutable
abstract class RptMaterialsCorrosionEvent {
  final String noEnvio;

  RptMaterialsCorrosionEvent({this.noEnvio});
}

class GetRptMaterialsCorosion extends RptMaterialsCorrosionEvent {
  GetRptMaterialsCorosion({@required String noEnvio}) : super(noEnvio: noEnvio);
}
