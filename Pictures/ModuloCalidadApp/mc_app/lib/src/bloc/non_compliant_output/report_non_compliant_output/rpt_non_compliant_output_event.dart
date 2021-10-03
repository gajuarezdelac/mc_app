import 'package:flutter/material.dart';

@immutable
abstract class RptNonCompliantOutputEvent {
  final String salidaNoConformeId;

  RptNonCompliantOutputEvent({this.salidaNoConformeId});
}

class GetRptNonCompliantOutput extends RptNonCompliantOutputEvent {
  GetRptNonCompliantOutput({@required String salidaNoConformeId})
      : super(salidaNoConformeId: salidaNoConformeId);
}
