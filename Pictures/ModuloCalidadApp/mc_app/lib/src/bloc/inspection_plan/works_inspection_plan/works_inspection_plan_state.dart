import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class WorksInspectionPlanState {
  final List<WorksInspectionPlanModel> listWorksInspectionPlan;
  final String message;

  WorksInspectionPlanState({
    this.listWorksInspectionPlan,
    this.message,
  });
}

class InitialWorksInspectionPlanState extends WorksInspectionPlanState {}

// Obras
class IsLoadingWorksInspectionPlan extends WorksInspectionPlanState {}

class ErrorWorksInspectionPlan extends WorksInspectionPlanState {
  ErrorWorksInspectionPlan({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessWorksInspectionPlan extends WorksInspectionPlanState {
  SuccessWorksInspectionPlan(
      {@required List<WorksInspectionPlanModel> listWorksInspectionPlan})
      : super(listWorksInspectionPlan: listWorksInspectionPlan);
}

// Lista
