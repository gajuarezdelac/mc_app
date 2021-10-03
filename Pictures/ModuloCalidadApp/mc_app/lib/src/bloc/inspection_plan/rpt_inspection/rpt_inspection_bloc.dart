import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/rpt_inspection/rpt_inspection_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/rpt_inspection/rpt_inspection_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/report_repository.dart';

class RptInspectionBloc extends Bloc<RptInspectionEvent, RptInspectionState> {
  RptInspectionBloc() : super(InitialRptInspectionState());

  final repository = ReportRepository();

  @override
  Stream<RptInspectionState> mapEventToState(RptInspectionEvent event) async* {
    // Cabecera

    if (event is CreateRptRIA) {
      yield IsLoadingRptRIAInspection();

      try {
        RptRIAModel riaModel = await repository.getRptRIAIP(riaId: event.riaId);

        yield SuccessRptRIAInspection(riaModel: riaModel);
      } catch (e) {
        yield ErrorRptRIAInspection(errorMessage: e.toString());
      }
    }
    //
    if (event is CreateRptIP) {
      yield IsLoadingRptIP();

      try {
        RptInspectionPlanModel rptInspectionPlanModel = await repository
            .getRptPlanInspeccion(noPlanInspeccion: event.noPlanInspeccion);

        yield SuccessRptIP(rptInspectionPlanModel: rptInspectionPlanModel);
      } catch (e) {
        yield ErrorRptIP(errorMessage: e.toString());
      }
    }

    if (event is GetRptId) {
      yield IsLoadingInsRptRIA();

      try {
        String riaId = await repository.getRiaId(
            noPlanInspeccion: event.noPlanInspeccion,
            tipo: event.tipo,
            list: event.list);

        yield SuccessInsRptRIA(riaId: riaId);
      } catch (e) {
        yield ErrorInsRptRIA(errorMessage: e.toString());
      }
    }
  }
}
