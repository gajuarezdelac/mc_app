import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class ContractsInspectionPlanState {
  final List<ContractsInspectionPlanModel> listContractsInspectionPlan;
  final String message;

  ContractsInspectionPlanState({
    this.listContractsInspectionPlan,
    this.message,
  });
}

class InitialContractsInspectionPlanState extends ContractsInspectionPlanState {
}

// Contratos
class IsLoadingContractInspectionPlan extends ContractsInspectionPlanState {}

class ErrorContractInspectionPlan extends ContractsInspectionPlanState {
  ErrorContractInspectionPlan({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessContractInspectionPlan extends ContractsInspectionPlanState {
  SuccessContractInspectionPlan(
      {@required
          List<ContractsInspectionPlanModel> listContractsInspectionPlanModel})
      : super(listContractsInspectionPlan: listContractsInspectionPlanModel);
}
