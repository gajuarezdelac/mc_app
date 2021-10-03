import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class RptInspectionState {
  final RptInspectionPlanModel rptInspectionPlanModel;
  final RptRIAModel riaModel;
  final String message;
  final String riaId;

  RptInspectionState({
    this.riaId,
    this.rptInspectionPlanModel,
    this.riaModel,
    this.message,
  });
}

class InitialRptInspectionState extends RptInspectionState {}

class IsLoadingRptRIAInspection extends RptInspectionState {}

class ErrorRptRIAInspection extends RptInspectionState {
  ErrorRptRIAInspection({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessRptRIAInspection extends RptInspectionState {
  SuccessRptRIAInspection({@required RptRIAModel riaModel})
      : super(riaModel: riaModel);
}

class IsLoadingRptIP extends RptInspectionState {}

class ErrorRptIP extends RptInspectionState {
  ErrorRptIP({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessRptIP extends RptInspectionState {
  SuccessRptIP({@required RptInspectionPlanModel rptInspectionPlanModel})
      : super(rptInspectionPlanModel: rptInspectionPlanModel);
}

// Actualización del reporte RIA
class IsLoadingInsRptRIA extends RptInspectionState {}

class ErrorInsRptRIA extends RptInspectionState {
  ErrorInsRptRIA({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessInsRptRIA extends RptInspectionState {
  SuccessInsRptRIA({@required String riaId}) : super(riaId: riaId);
}
