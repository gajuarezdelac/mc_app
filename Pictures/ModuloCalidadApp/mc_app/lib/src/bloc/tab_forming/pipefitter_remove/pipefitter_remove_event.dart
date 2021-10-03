import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterRemoveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class PipefitterRemove extends PipefitterRemoveEvent {
  final int employeeId;
  final String jointId;

  PipefitterRemove({@required this.employeeId, @required this.jointId});

  @override
  List<Object> get props => [employeeId, jointId];
}
