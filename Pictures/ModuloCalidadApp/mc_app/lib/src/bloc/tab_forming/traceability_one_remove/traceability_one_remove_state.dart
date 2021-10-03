import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityOneRemoveState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceabilityOneRemoveState extends TraceabilityOneRemoveState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsDeletingTraceabilityOneRemove extends TraceabilityOneRemoveState {}

class ErrorTraceabilityOneRemove extends TraceabilityOneRemoveState {
  final String error;

  ErrorTraceabilityOneRemove({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessTraceabilityOneRemove extends TraceabilityOneRemoveState {
  final int result;

  SuccessTraceabilityOneRemove({@required this.result});

  @override
  List<Object> get props => [result];
}
