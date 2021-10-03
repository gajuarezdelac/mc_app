import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class ActivitiesInspectionPlanState {
  final InspectionPlanHeaderModel inspectionPlanHeaderModel;
  final String message;

  ActivitiesInspectionPlanState({this.inspectionPlanHeaderModel, this.message});
}

class InitialActivitiesInspectionPlanState
    extends ActivitiesInspectionPlanState {}

// Eventos para la cabecera

class IsLoadingHeaderInspectionPlan extends ActivitiesInspectionPlanState {}

class ErrorHeaderInspectionPlan extends ActivitiesInspectionPlanState {
  ErrorHeaderInspectionPlan({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessHeaderInspectionPlan extends ActivitiesInspectionPlanState {
  SuccessHeaderInspectionPlan(
      {@required InspectionPlanHeaderModel inspectionPlanHeaderModel})
      : super(inspectionPlanHeaderModel: inspectionPlanHeaderModel);
}
