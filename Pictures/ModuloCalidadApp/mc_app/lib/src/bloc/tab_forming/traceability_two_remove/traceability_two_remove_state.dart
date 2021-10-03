import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityTwoRemoveState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceabilityTwoRemoveState extends TraceabilityTwoRemoveState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsDeletingTraceabilityTwoRemove extends TraceabilityTwoRemoveState {}

class ErrorTraceabilityTwoRemove extends TraceabilityTwoRemoveState {
  final String error;

  ErrorTraceabilityTwoRemove({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessTraceabilityTwoRemove extends TraceabilityTwoRemoveState {
  final int result;

  SuccessTraceabilityTwoRemove({@required this.result});

  @override
  List<Object> get props => [result];
}
