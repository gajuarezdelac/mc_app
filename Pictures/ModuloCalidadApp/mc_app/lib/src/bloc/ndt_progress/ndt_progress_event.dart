import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NDTProgressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener el progreso de las solicitudes de PND
// de la junta
class GetNDTProgress extends NDTProgressEvent {
  final String jointId;

  GetNDTProgress({@required this.jointId});

  @override
  List<Object> get props => [jointId];
}
