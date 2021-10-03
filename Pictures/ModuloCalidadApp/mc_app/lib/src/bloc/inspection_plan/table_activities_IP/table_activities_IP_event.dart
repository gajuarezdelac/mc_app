import 'package:flutter/cupertino.dart';

@immutable
abstract class TableActivitiesIPEvent {
  final noInspectionPlan;

  TableActivitiesIPEvent({this.noInspectionPlan});
}

class GetTableInspectionPlan extends TableActivitiesIPEvent {
  GetTableInspectionPlan({@required String noInspectionPlan})
      : super(noInspectionPlan: noInspectionPlan);
}
