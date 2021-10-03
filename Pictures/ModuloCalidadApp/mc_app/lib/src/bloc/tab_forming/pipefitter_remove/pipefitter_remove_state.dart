import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PipefitterRemoveState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialPipefitterRemoveState extends PipefitterRemoveState {}

// Estados para obtener los tuberos del conformado
class IsRemovingPipefitter extends PipefitterRemoveState {}

class ErrorPipefitterRemove extends PipefitterRemoveState {
  final String error;

  ErrorPipefitterRemove({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessPipefitterRemove extends PipefitterRemoveState {
  final int result;

  SuccessPipefitterRemove({@required this.result});

  @override
  List<Object> get props => [result];
}
