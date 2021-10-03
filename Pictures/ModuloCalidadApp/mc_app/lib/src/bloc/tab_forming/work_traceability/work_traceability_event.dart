import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class WorkTraceabilityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class GetWorkTR extends WorkTraceabilityEvent {
  final String contratoId;

  GetWorkTR({@required this.contratoId});

  @override
  List<Object> get props => [contratoId];
}
