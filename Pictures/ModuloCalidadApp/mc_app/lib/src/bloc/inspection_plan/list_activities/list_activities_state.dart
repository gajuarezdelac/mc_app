import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class ListActivitiesState {
  final List<InspectionPlanCModel> list;
  final String message;
  final bool clear;

  ListActivitiesState({
    this.list,
    this.message,
    this.clear,
  });
}

class InitialListActivitiesState extends ListActivitiesState {}

// Obras
class IsLoadingListActivities extends ListActivitiesState {}

class ErrorListActivities extends ListActivitiesState {
  ErrorListActivities({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessListActivities extends ListActivitiesState {
  SuccessListActivities(
      {@required List<InspectionPlanCModel> list, @required clear})
      : super(list: list, clear: clear);
}

// Lista
