import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';

@immutable
abstract class TraceabilityOneState {
  final String error;
  final TraceabilityByJointModel traceabilityOne;

  TraceabilityOneState({this.error, this.traceabilityOne});
}

class InitialTraceabilityOneState extends TraceabilityOneState {}

//Estados para obtener trazabilidad por el ID de la Junta
class IsLoadingTraceabilityOne extends TraceabilityOneState {}

class ErrorTraceabilityOne extends TraceabilityOneState {
  ErrorTraceabilityOne({@required String error}) : super(error: error);
}

class SuccessTraceabilityOne extends TraceabilityOneState {
  SuccessTraceabilityOne({@required TraceabilityByJointModel traceabilityOne})
      : super(traceabilityOne: traceabilityOne);
}
