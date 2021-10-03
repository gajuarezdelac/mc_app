import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';

@immutable
abstract class RptPruebaState {
  final String errorMessage;
  final List<RptPrueba> listRptPrueba;

  RptPruebaState({this.errorMessage, this.listRptPrueba});
}

class InitialRptPruebaState extends RptPruebaState {}

class IsLoadingRptPrueba extends RptPruebaState {}

class ErrorRptPrueba extends RptPruebaState {
  ErrorRptPrueba({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetRptPrueba extends RptPruebaState {
  SuccessGetRptPrueba({@required List<RptPrueba> listRptPrueba})
      : super(listRptPrueba: listRptPrueba);
}
