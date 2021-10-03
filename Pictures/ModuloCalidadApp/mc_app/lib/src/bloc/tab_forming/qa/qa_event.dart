import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class QAEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class GetQA extends QAEvent {
  final int employeeId;

  GetQA({@required this.employeeId});

  @override
  List<Object> get props => [employeeId];
}
