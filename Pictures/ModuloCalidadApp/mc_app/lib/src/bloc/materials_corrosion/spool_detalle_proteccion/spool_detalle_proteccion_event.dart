import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SpoolDetalleProteccionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetAllSpoolDetalleProteccion extends SpoolDetalleProteccionEvent {
  final String noEnvio;
  final bool isReport;

  GetAllSpoolDetalleProteccion({this.noEnvio, this.isReport});

  @override
  List<Object> get props => [noEnvio, isReport];
}
