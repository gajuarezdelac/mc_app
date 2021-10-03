import 'package:mc_app/src/data/dao/photographic_evidence_dao.dart';
import 'package:mc_app/src/models/params/evidence_welder_card_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

class PhotographicEvidenceRepository {
  // conformed
  final photographicEvidenceDao = PhotographicEvidenceDao();

  Future getAllPhotographics({PhotographicEvidenceParamsModel params}) =>
      photographicEvidenceDao.fetchGetAllPhotographics(params);

  Future deletePhotographics({String id}) =>
      photographicEvidenceDao.fetchDeletePhotographics(id);

  Future addPhotographics({PhotographicEvidenceModel data}) =>
      photographicEvidenceDao.fetchAddPhotographics(data);

  Future addAllPhotographics(
          {List<PhotographicEvidenceModel> data,
          List<PhotographicEvidenceModel> delete}) =>
      photographicEvidenceDao.fetchAddAllPhotographics(data, delete);

  // Welding evidence

  Future getAllPhotographicsWelding(
          {PhotographicEvidenceWeldingParamsModel params}) =>
      photographicEvidenceDao.fetchGetAllPhotographicsWelding(params);

  Future getAllEvidenceWelders({EvidenceWelderCardParams params}) =>
      photographicEvidenceDao.getAllEvidenceWelders(params);

  Future deletePhotographicsWelding({String id}) =>
      photographicEvidenceDao.fetchDeletePhotographicsWelding(id);

  Future addPhotographicsWelding({PhotographicEvidenceWeldingModel data}) =>
      photographicEvidenceDao.fetchAddPhotographicsWelding(data);

  // Inspection Plan Evidence

  Future getAllPhotographicsIP({PhotographicEvidenceIPParamsModel params}) =>
      photographicEvidenceDao.fetchGetAllPhotographicsIP(params);

  Future deletePhotographicsIP({String id}) =>
      photographicEvidenceDao.fetchDeletePhotographicsIP(id);

  Future addPhotographicsIP({PhotographicEvidenceIPModel data}) =>
      photographicEvidenceDao.fetchAddPhotographicsIP(data);

  Future addAllPhotographicsIP(
          {List<PhotographicEvidenceIPModel> data,
          List<PhotographicEvidenceIPModel> delete}) =>
      photographicEvidenceDao.fetchAddAllPhotographicsIP(data, delete);

  //Protección anticorrosiva

  Future getAllPhotographicsV2({PhotographicEvidenceParamsModel params}) =>
      photographicEvidenceDao.fetchGetAllPhotographicsV2(params);

  Future insUpdPhotographicsV2(
          {List<PhotographicEvidenceModel> params,
          String identificadorComun,
          String tablaComun}) =>
      photographicEvidenceDao.insUpdEvidencePhotographicV2(
          params, identificadorComun, tablaComun);
}
