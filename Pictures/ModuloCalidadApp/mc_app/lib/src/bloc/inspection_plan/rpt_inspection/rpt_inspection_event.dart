import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class RptInspectionEvent {
  final String riaId;
  final String noPlanInspeccion;
  final int tipo;
  final List<InspectionPlanDModel> list;

  RptInspectionEvent({this.list, this.tipo, this.riaId, this.noPlanInspeccion});
}

class CreateRptRIA extends RptInspectionEvent {
  CreateRptRIA({@required String riaId}) : super(riaId: riaId);
}

class CreateRptIP extends RptInspectionEvent {
  CreateRptIP({@required String noPlanInspeccion})
      : super(noPlanInspeccion: noPlanInspeccion);
}

class GetRptId extends RptInspectionEvent {
  GetRptId({
    @required String noPlanInspeccion,
    @required int tipo,
    @required List<InspectionPlanDModel> list,
  }) : super(noPlanInspeccion: noPlanInspeccion, tipo: tipo, list: list);
}
