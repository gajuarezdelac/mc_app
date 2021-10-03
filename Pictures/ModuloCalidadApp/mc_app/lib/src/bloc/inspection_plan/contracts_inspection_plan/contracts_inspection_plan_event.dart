import 'package:flutter/cupertino.dart';

@immutable
abstract class ContractsInspectionPlanEvent {
  final String selectDropdown;

  ContractsInspectionPlanEvent({this.selectDropdown});
}

// event looking for contracts
class GetContractsInspectionPlan extends ContractsInspectionPlanEvent {}
