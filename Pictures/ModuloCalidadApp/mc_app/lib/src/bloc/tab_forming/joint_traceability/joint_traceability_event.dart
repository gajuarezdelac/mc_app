import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/joint_traceability_params.dart';

@immutable
abstract class JointTraceabilityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener las juntas relacionadas a la trazabilidad
class GetJointTraceability extends JointTraceabilityEvent {
  final JointTraceabilityParams params;

  GetJointTraceability({@required this.params});

  @override
  List<Object> get props => [params];
}
