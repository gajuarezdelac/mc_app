import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/user_permission_model.dart';

class InspectionPlanParams {
  UserPermissionModel userPermissionModel;
  String contractSelection;
  String workSelection;
  ContractsInspectionPlanModel contractsInspectionPlanModel;
  WorksInspectionPlanModel worksInspectionPlanModel;
  InspectionPlanCModel inspectionPlanCModel;

  InspectionPlanParams({
    this.userPermissionModel,
    this.contractSelection,
    this.contractsInspectionPlanModel,
    this.inspectionPlanCModel,
    this.workSelection,
    this.worksInspectionPlanModel,
  });
}

class RegisterInspectionPlanParams {
  InspectionPlanParams inspectionPlanParams;
  InspectionPlanHeaderModel inspectionPlanHeaderModel;
  InspectionPlanDModel inspectionPlanDModel;

  RegisterInspectionPlanParams({
    this.inspectionPlanDModel,
    this.inspectionPlanHeaderModel,
    this.inspectionPlanParams,
  });
}
