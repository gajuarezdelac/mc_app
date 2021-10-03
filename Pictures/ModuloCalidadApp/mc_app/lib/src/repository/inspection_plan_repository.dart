import 'package:flutter/material.dart';
import 'package:mc_app/src/data/dao/inspection_plan_dao.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/add_welder_parms.dart';
import 'package:mc_app/src/models/params/get_information_welder_Param.dart';

class InspectionPlanRepository {
  // Instancia de la clase que almacena nuestras consultas
  InspectionPlanDao insepcctionPlanDao = InspectionPlanDao();

  // Search Contract
  Future getContractsInspectionPlan() =>
      insepcctionPlanDao.fetchAllContractsInsepcctionPlan();

  // Serch Work by Contract
  Future getWorkByContractInspectionPlan({@required String contractId}) =>
      insepcctionPlanDao.fetchWorksByIdInsepcctionPlan(contractId);

  // List of activities

  Future getListPlansInspection(
          {@required String contractId,
          @required String workId,
          @required bool clear}) =>
      insepcctionPlanDao.fetchPlansInspecctionC(
        contractId,
        workId,
        clear,
      );

  // Activities by Inspection Plan
  Future getHeaderActivitiesByInspectionPlan(
          {@required String noPlanInspection}) =>
      insepcctionPlanDao.fetchInspectionPlanHeader(noPlanInspection);

  // Table Activities By Inspection Plan
  Future getATablectivitiesByInspectionPlan(
          {@required String noInspectionPlan}) =>
      insepcctionPlanDao.fetchPlansInspecctionD(noInspectionPlan);

  Future getTableMaterialRegisterIP({
    @required String noPlanInspeccion,
    @required String siteId,
    @required dynamic propuestaTecnicaId,
    @required dynamic actividadId,
    @required dynamic subActividadId,
    @required dynamic reprogramacionOTId,
  }) =>
      insepcctionPlanDao.fechtListMaterialsbyActivity(noPlanInspeccion, siteId,
          propuestaTecnicaId, actividadId, subActividadId, reprogramacionOTId);

  Future getInformacionadicional(
          {@required GetInformationWelderParam params}) =>
      insepcctionPlanDao.fetchInformacionadicional(params);

  Future addWelderGeneral({@required AddWelderParams params}) =>
      insepcctionPlanDao.insUpdInspeccionActividadSoldador(params);

  Future addTrazabilidadGeneral(
          {@required List<SoldadorTrazabilidadRIA> params}) =>
      insepcctionPlanDao.insUpdSoldadorTrazabilidad(params);

  Future getWelderPlan({@required dynamic noFicha}) =>
      insepcctionPlanDao.fetchWelderPlan(noFicha);

  Future insUpdReporteInspeccionActividad({
    @required String noPlanInspection,
    @required String siteId,
    @required dynamic propuestaTecnicaId,
    @required dynamic actividadId,
    @required dynamic subActividadId,
    @required dynamic reprogramacionOTId,
    @required String materialId,
    @required String idTrazabilidad,
    @required int resultado,
    @required int incluirReporte,
    @required String comentarios,
  }) =>
      insepcctionPlanDao.insUpdReporteInspeccionActividad(
          noPlanInspection,
          siteId,
          propuestaTecnicaId,
          actividadId,
          subActividadId,
          reprogramacionOTId,
          materialId,
          idTrazabilidad,
          resultado,
          incluirReporte,
          comentarios);
}
