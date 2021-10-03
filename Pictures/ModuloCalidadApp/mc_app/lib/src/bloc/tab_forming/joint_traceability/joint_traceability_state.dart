import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/joint_traceability_model.dart';

@immutable
abstract class JointTraceabilityState {
  final String error;
  final String traceabilityId;
  final bool isTraceabilityOne;
  final List<JointTraceabilityModel> joints;

  JointTraceabilityState({
    this.error,
    this.traceabilityId,
    this.isTraceabilityOne,
    this.joints,
  });
}

class InitialJointTraceabilityState extends JointTraceabilityState {}

// Estados para obtener las juntas relacionadas a una trazabilidad
class IsLoadingJointTraceability extends JointTraceabilityState {}

class ErrorJointTraceability extends JointTraceabilityState {
  ErrorJointTraceability({@required String error}) : super(error: error);
}

class SuccessJointTraceability extends JointTraceabilityState {
  SuccessJointTraceability({
    @required List<JointTraceabilityModel> joints,
    @required String traceabilityId,
    @required bool isTraceabilityOne,
  }) : super(
          joints: joints,
          traceabilityId: traceabilityId,
          isTraceabilityOne: isTraceabilityOne,
        );
}
