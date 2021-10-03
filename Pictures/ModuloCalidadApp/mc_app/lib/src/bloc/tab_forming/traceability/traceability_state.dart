import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/traceability_model.dart';

@immutable
abstract class TraceabilityState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTraceabilityState extends TraceabilityState {}

// Estados para obtener una trazabilidad por su ID
class IsLoadingTraceabilityById extends TraceabilityState {}

class ErrorTraceabilityById extends TraceabilityState {
  final String errorMessage;

  ErrorTraceabilityById({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SuccessTraceabilityById extends TraceabilityState {
  final TraceabilityModel traceability;
  final bool isTraceabilityOne;

  SuccessTraceabilityById({
    @required this.traceability,
    @required this.isTraceabilityOne,
  });

  @override
  List<Object> get props => [traceability, isTraceabilityOne];
}

//Estados para obtener trazabilidad por el ID de la Junta
/*class IsLoadingTraceabilityOne extends TraceabilityState {}

class ErrorTraceabilityOne extends TraceabilityState {
  final String errorMessageByJoint;

  ErrorTraceabilityOne({@required this.errorMessageByJoint});

  @override
  List<Object> get props => [errorMessageByJoint];
}

class SuccessTraceabilityOne extends TraceabilityState {
  final TraceabilityByJointModel traceabilityOne;

  SuccessTraceabilityOne({@required this.traceabilityOne});

  @override
  List<Object> get props => [traceabilityOne];
}*/

//Estados para obtener trazabilidad por el ID de la Junta
/*class IsLoadingTraceabilityTwo extends TraceabilityState {}

class ErrorTraceabilityTwo extends TraceabilityState {
  final String errorMessageByJoint;

  ErrorTraceabilityTwo({@required this.errorMessageByJoint});

  @override
  List<Object> get props => [errorMessageByJoint];
}

class SuccessTraceabilityTwo extends TraceabilityState {
  final TraceabilityByJointModel traceabilityTwo;

  SuccessTraceabilityTwo({@required this.traceabilityTwo});

  @override
  List<Object> get props => [traceabilityTwo];
}*/
