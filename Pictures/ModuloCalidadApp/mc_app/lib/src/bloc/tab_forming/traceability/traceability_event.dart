import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener una trazabilidad por su ID
class GetTraceabilityById extends TraceabilityEvent {
  final String traceabilityId;
  final bool isTraceabilityOne;

  GetTraceabilityById({this.traceabilityId, this.isTraceabilityOne});

  @override
  List<Object> get props => [traceabilityId, isTraceabilityOne];
}

// Evento para obtener la trazabilidad uno por la JuntaId
/*class GetTraceabilityOne extends TraceabilityEvent {
  final String jointId;
  final bool isTraceabilityOne;

  GetTraceabilityOne({this.jointId, this.isTraceabilityOne});

  @override
  List<Object> get props => [jointId, isTraceabilityOne];
}*/

// Evento para obtener la trazabilidad dos por la JuntaId
/*class GetTraceabilityTwo extends TraceabilityEvent {
  final String jointId;
  final bool isTraceabilityOne;

  GetTraceabilityTwo({this.jointId, this.isTraceabilityOne});

  @override
  List<Object> get props => [jointId, isTraceabilityOne];
}*/
