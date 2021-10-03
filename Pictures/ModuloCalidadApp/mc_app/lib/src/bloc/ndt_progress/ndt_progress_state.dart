import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/ndt_progress_model.dart';

@immutable
abstract class NDTProgressState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialNDTProgressState extends NDTProgressState {}

class IsLoadingNDTProgress extends NDTProgressState {}

class ErrorNDTProgress extends NDTProgressState {
  final String error;

  ErrorNDTProgress({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessNDTProgress extends NDTProgressState {
  final List<NDTProgressModel> jointNDTProgress;

  SuccessNDTProgress({@required this.jointNDTProgress});

  @override
  List<Object> get props => [jointNDTProgress];
}
