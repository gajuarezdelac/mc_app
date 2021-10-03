import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';

@immutable
abstract class SpoolDetalleProteccionState {
  final String errorMessage;
  final List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion;

  SpoolDetalleProteccionState({this.errorMessage, this.lstSpoolDetalleProteccion});
}

class InitialSpoolDetalleProteccionState extends SpoolDetalleProteccionState {
    InitialSpoolDetalleProteccionState(
      {@required List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion})
      : super(lstSpoolDetalleProteccion: lstSpoolDetalleProteccion);
}

class IsLoadingSpoolDetalleProteccion extends SpoolDetalleProteccionState {}

class ErrorSpoolDetalleProteccion extends SpoolDetalleProteccionState {
  ErrorSpoolDetalleProteccion({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetSpoolDetalleProteccion extends SpoolDetalleProteccionState {
  SuccessGetSpoolDetalleProteccion(
      {@required List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion})
      : super(lstSpoolDetalleProteccion: lstSpoolDetalleProteccion);
}

