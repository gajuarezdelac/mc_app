import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterSignEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class PipefitterSign extends PipefitterSignEvent {
  final int employeeId;
  final String jointId;

  PipefitterSign({@required this.employeeId, @required this.jointId});

  @override
  List<Object> get props => [employeeId, jointId];
}
