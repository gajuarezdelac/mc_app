import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TraceabilityTwoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad dos por la JuntaId
class GetTraceabilityTwo extends TraceabilityTwoEvent {
  final String jointId;
  final bool isTraceabilityOne;

  GetTraceabilityTwo({this.jointId, this.isTraceabilityOne});

  @override
  List<Object> get props => [jointId, isTraceabilityOne];
}
