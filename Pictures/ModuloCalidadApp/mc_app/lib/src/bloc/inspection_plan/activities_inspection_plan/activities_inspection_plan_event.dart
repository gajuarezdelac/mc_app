import 'package:flutter/cupertino.dart';

@immutable
abstract class ActivitiesInspectionPlanEvent {
  final noInspectionPlan;

  ActivitiesInspectionPlanEvent({this.noInspectionPlan});
}

class GetHeaderInspectionPlan extends ActivitiesInspectionPlanEvent {
  GetHeaderInspectionPlan({@required String noInspectionPlan})
      : super(noInspectionPlan: noInspectionPlan);
}
