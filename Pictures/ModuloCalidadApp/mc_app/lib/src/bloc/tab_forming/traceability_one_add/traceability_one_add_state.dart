import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityOneAddState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceabilityOneAddState extends TraceabilityOneAddState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsAddingTraceabilityOne extends TraceabilityOneAddState {}

class ErrorTraceabilityOneAdd extends TraceabilityOneAddState {
  final String error;

  ErrorTraceabilityOneAdd({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessTraceabilityOneAdd extends TraceabilityOneAddState {
  final int result;

  SuccessTraceabilityOneAdd({@required this.result});

  @override
  List<Object> get props => [result];
}
