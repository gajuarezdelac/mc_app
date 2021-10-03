import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class GetPipefitters extends PipefitterEvent {
  final String jointId;

  GetPipefitters({@required this.jointId});

  @override
  List<Object> get props => [jointId];
}
