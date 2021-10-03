import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/traceability_params_model.dart';

@immutable
abstract class TraceabilityTwoAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class AddTraceabilityTwo extends TraceabilityTwoAddEvent {
  final TraceabilityParamsModel params;

  AddTraceabilityTwo({@required this.params});

  @override
  List<Object> get props => [params];
}
