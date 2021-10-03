import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityOneEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetTraceabilityOne extends TraceabilityOneEvent {
  final String jointId;
  final bool isTraceabilityOne;

  GetTraceabilityOne({this.jointId, this.isTraceabilityOne});

  @override
  List<Object> get props => [jointId, isTraceabilityOne];
}
