import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';

@immutable
abstract class TraceabilityTwoState {
  final String error;
  final TraceabilityByJointModel traceabilityTwo;

  TraceabilityTwoState({this.error, this.traceabilityTwo});
}

class InitialTraceabilityTwoState extends TraceabilityTwoState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsLoadingTraceabilityTwo extends TraceabilityTwoState {}

class ErrorTraceabilityTwo extends TraceabilityTwoState {
  ErrorTraceabilityTwo({@required String error}) : super(error: error);
}

class SuccessTraceabilityTwo extends TraceabilityTwoState {
  SuccessTraceabilityTwo({@required TraceabilityByJointModel traceabilityTwo})
      : super(traceabilityTwo: traceabilityTwo);
}
