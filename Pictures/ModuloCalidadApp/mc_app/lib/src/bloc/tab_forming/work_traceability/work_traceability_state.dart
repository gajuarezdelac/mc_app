import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';

@immutable
abstract class WorkTraceabiltyState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialWorkTraceabiltyState extends WorkTraceabiltyState {}

class IsLoadingWorkTR extends WorkTraceabiltyState {}

class ErrorWorkTR extends WorkTraceabiltyState {
  final String error;

  ErrorWorkTR({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessGetWorkTR extends WorkTraceabiltyState {
  final List<WorkTraceability> worksT;

  SuccessGetWorkTR({@required this.worksT});

  @override
  List<Object> get props => [worksT];
}
