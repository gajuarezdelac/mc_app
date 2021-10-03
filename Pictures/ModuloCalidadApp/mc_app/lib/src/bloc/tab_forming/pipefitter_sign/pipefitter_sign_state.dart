import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterSignState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialPipefitterSignState extends PipefitterSignState {}

// Estados para obtener los tuberos del conformado
class IsSigningPipefitter extends PipefitterSignState {}

class ErrorPipefitterSign extends PipefitterSignState {
  final String error;

  ErrorPipefitterSign({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessPipefitterSign extends PipefitterSignState {
  final int result;

  SuccessPipefitterSign({@required this.result});

  @override
  List<Object> get props => [result];
}
