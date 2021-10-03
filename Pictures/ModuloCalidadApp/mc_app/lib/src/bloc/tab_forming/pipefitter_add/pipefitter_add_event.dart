import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class PipefitterAdd extends PipefitterAddEvent {
  final int card;
  final String jointId;

  PipefitterAdd({@required this.card, @required this.jointId});

  @override
  List<Object> get props => [card, jointId];
}
