import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class TableActivitiesIPState {
  final List<InspectionPlanDModel> inspectionPlanDModel;
  final String message;

  TableActivitiesIPState({this.message, this.inspectionPlanDModel});
}

class InitialTableActivitiesIPState extends TableActivitiesIPState {}

class IsLoadingTableActivitiesIP extends TableActivitiesIPState {}

class ErrorTableActivitiesIP extends TableActivitiesIPState {
  ErrorTableActivitiesIP({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessTableActivitiesIP extends TableActivitiesIPState {
  SuccessTableActivitiesIP(
      {@required List<InspectionPlanDModel> inspectionPlanDModel})
      : super(inspectionPlanDModel: inspectionPlanDModel);
}
