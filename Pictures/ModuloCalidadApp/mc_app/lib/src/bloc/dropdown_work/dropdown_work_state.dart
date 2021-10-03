import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';

@immutable
abstract class DropDownWorkState {
  final List<WorkDropDownModel> works;
  final String message;

  DropDownWorkState({this.works, this.message});
}

class InitialDropDownWorkState extends DropDownWorkState {}

class IsLoadingWorks extends DropDownWorkState {}

class ErrorWorks extends DropDownWorkState {
  ErrorWorks({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessWorks extends DropDownWorkState {
  SuccessWorks({@required List<WorkDropDownModel> works}) : super(works: works);
}
