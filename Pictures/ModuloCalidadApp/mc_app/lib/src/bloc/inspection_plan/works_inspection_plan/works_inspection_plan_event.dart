import 'package:flutter/cupertino.dart';

@immutable
abstract class WorksInspectionPlanEvent {
  final String contractId;

  WorksInspectionPlanEvent({this.contractId});
}

// event looking for Work by Contract
class GetWorksByIdInspectionPlan extends WorksInspectionPlanEvent {
  GetWorksByIdInspectionPlan({@required String contractId})
      : super(contractId: contractId);
}
