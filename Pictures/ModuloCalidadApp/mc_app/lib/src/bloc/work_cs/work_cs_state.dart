import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';

@immutable
abstract class WorkCSState {
  final List<WorkDropDownModel> works;
  final String error;

  WorkCSState({this.works, this.error});
}

class InitialWorkCSState extends WorkCSState {}

class IsLoadingWorkCS extends WorkCSState {}

class ErrorWorkCS extends WorkCSState {
  ErrorWorkCS({@required String error}) : super(error: error);
}

class SuccessWorkCS extends WorkCSState {
  SuccessWorkCS({@required List<WorkDropDownModel> works})
      : super(works: works);
}
