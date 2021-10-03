import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/traceability_delete_params_model.dart';

@immutable
abstract class TraceabilityTwoRemoveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class DeleteTraceabilityTwo extends TraceabilityTwoRemoveEvent {
  final TraceabilityDeleteParamsModel params;

  DeleteTraceabilityTwo({@required this.params});

  @override
  List<Object> get props => [params];
}
