import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/traceability_delete_params_model.dart';

@immutable
abstract class TraceabilityOneRemoveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class DeleteTraceabilityOne extends TraceabilityOneRemoveEvent {
  final TraceabilityDeleteParamsModel params;

  DeleteTraceabilityOne({@required this.params});

  @override
  List<Object> get props => [params];
}
