import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterAddState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialPipefitterAddState extends PipefitterAddState {}

// Estados para obtener los tuberos del conformado
class IsAddingPipefitter extends PipefitterAddState {}

class ErrorPipefitterAdd extends PipefitterAddState {
  final String error;

  ErrorPipefitterAdd({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessPipefitterAdd extends PipefitterAddState {
  final int result;

  SuccessPipefitterAdd({@required this.result});

  @override
  List<Object> get props => [result];
}
