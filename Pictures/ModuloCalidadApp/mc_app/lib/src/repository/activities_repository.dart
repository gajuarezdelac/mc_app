import 'package:mc_app/src/data/dao/activities_dao.dart';

class ActivitiesRepository {
  final activitiesDao = ActivitiesDao();

  Future updateJointActivity(
          {String siteId,
          double propuestaTecnicaId,
          double actividadId,
          int subActividadId,
          String juntaId}) =>
      activitiesDao.relateActivity(
        siteId,
        propuestaTecnicaId,
        actividadId,
        subActividadId,
        juntaId,
      );

  // Nos ayuda a recuperar la partida interna
  Future getInternalDeparture({
    String siteId,
    String contractId,
    String workId,
  }) =>
      activitiesDao.fetchInternalDeparture(siteId, contractId, workId);
  //Nos recupera el estatus
  Future getStatus({String query}) => activitiesDao.fetchAllEstatus();
  //Nos recupera el anexo
  Future getAnexo({String query}) => activitiesDao.fetchAnexo();
  //Nos recupera la partida PU
  Future getPartidaPU({String contractId}) =>
      activitiesDao.fetchPartidaPU(contractId);
  //Nos recupera el id primavera
  Future getPrimaveraId({String contratoId, String obraId}) =>
      activitiesDao.fetchPrimaveraId(contratoId, obraId);
  //Nos recupera el folio
  Future getFolio({String contractId, String workId, String site}) =>
      activitiesDao.fetchFolioByParams(contractId, workId, site);

  Future getEspecialidad({String contractId, int folioId}) =>
      activitiesDao.fetchEspecialidad(contractId, folioId);

  Future getSystem({String contractId, int folioId}) =>
      activitiesDao.fetchSistema(contractId, folioId);

  Future getPlaneSubactivity({String contractId, int folioId}) =>
      activitiesDao.fetchPlanoSubActividad(contractId, folioId);

  Future getClientActivitie({String contractId, String workId}) =>
      activitiesDao.fetchActividadCliente(contractId, workId);

  Future getReprogramtion({String workId}) =>
      activitiesDao.fetchReprogramacion(workId);

  Future getTableActivity({
    String contratoId,
    String obraId,
    String folio,
    String especialidad,
    String fechaInicio,
    String reprogramacionOT,
    String fechaFin,
    int frenteId,
    String sistema,
    String plano,
    String anexo,
    String partidaPU,
    String primaveraId,
    String noActividadCliente,
    String estatusId,
    String partidaFilter,
  }) =>
      activitiesDao.fetchActividades(
        contratoId,
        obraId,
        folio,
        especialidad,
        fechaInicio,
        reprogramacionOT,
        fechaFin,
        frenteId,
        sistema,
        plano,
        anexo,
        partidaPU,
        primaveraId,
        noActividadCliente,
        estatusId,
        partidaFilter,
      );
}
