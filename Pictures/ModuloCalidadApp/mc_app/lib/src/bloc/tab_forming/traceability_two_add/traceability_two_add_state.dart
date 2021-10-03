import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityTwoAddState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceabilityTwoAddState extends TraceabilityTwoAddState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsAddingTraceabilityTwo extends TraceabilityTwoAddState {}

class ErrorTraceabilityTwoAdd extends TraceabilityTwoAddState {
  final String error;

  ErrorTraceabilityTwoAdd({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessTraceabilityTwoAdd extends TraceabilityTwoAddState {
  final int result;

  SuccessTraceabilityTwoAdd({@required this.result});

  @override
  List<Object> get props => [result];
}
