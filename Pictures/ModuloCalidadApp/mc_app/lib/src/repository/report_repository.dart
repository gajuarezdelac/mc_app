import 'package:flutter/material.dart';
import 'package:mc_app/src/data/dao/report_dao.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

class ReportRepository {
  final reportDao = ReportDao();

  Future getEnvioMaterialesCorrosionCabecera({String noEnvio}) =>
      reportDao.envioMaterialesCorrosionCabecera(noEnvio);

  Future getRptSalidaNoConforme({String salidaNoConformeId}) =>
      reportDao.salidaNoConforme(salidaNoConformeId);

  Future getRptPlanInspeccion({@required String noPlanInspeccion}) =>
      reportDao.planDeInspeccion(noPlanInspeccion);

  Future getRptRIAIP({@required String riaId}) => reportDao.rptRIA(riaId);

  Future getRiaId({
    @required String noPlanInspeccion,
    @required int tipo,
    @required List<InspectionPlanDModel> list,
  }) =>
      reportDao.rptInsRIA(noPlanInspeccion, tipo, list);

  Future getRptPrueba() => reportDao.rptPruebaFoto();

  Future getRptAPA({String noRegistro}) =>
      reportDao.rptProteccionAnticorrosiva(noRegistro);
}
