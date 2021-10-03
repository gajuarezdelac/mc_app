import 'package:mc_app/src/data/dao/joint_dao.dart';
import 'package:mc_app/src/data/dao/machine_welding_dao.dart';
import 'package:mc_app/src/data/dao/overseer_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/panel_register_soldier_dao.dart';
import 'package:mc_app/src/data/dao/welder_dao.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/params/add_card_welder_not_valid_params.dart';
import 'package:mc_app/src/models/params/require_change_material_model.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';
import 'package:mc_app/src/models/params/add_card_welder_params.dart';

class WeldingTabRepository {
  final weldingTabDao = WeldingTabDao();
  final welderDao = WelderDao();
  final overseerDao = OverseerDao();
  final machineWeldingDao = MachineWeldingDao();
  final jointDao = JointDao();

  // Nos permite recuperar el registro de los soldadores.
  Future fetchRegisterSoldier({String jointId}) =>
      weldingTabDao.fetchRegisterWelding(jointId);

  // Consulta para añadir un soldador
  Future addCardWelderWPSValid({@required AddCardWelderParams params}) =>
      welderDao.addFichaSoldador(params);

  // Añadimos la maquina de soldar.
  Future addMachineWelding(
          {String noSerie, String folioSoldadura, int aceptVigencia}) =>
      machineWeldingDao.fetchMachineWelding(
          noSerie, folioSoldadura, aceptVigencia);

  // Añadimos la maquina de soldar.
  Future fetchMachineWeldingV2({String noSerie, String folioSoldadura}) =>
      machineWeldingDao.fetchMachineWeldingV2(noSerie, folioSoldadura);

  Future addMachineWeldingV2({String idEquipo, String folioSoldadura}) =>
      machineWeldingDao.addMachineWeldingV2(idEquipo, folioSoldadura);

  // Nos remueva la maquina de soldar.
  Future removeWeldingMachine({String folioSoldadura}) =>
      machineWeldingDao.removeWeldingMachine(folioSoldadura);

  // Califica dentro o fuera de norma
  Future qualifyCaboNorm(
          {String folioSoldadura,
          int inspectorCCAId,
          String norma,
          String motivoFN,
          String juntaId,
          List<AcceptanceCriteriaWeldingModel> listACS,
          String nombreTabla}) =>
      overseerDao.qualifyCaboNorm(folioSoldadura, inspectorCCAId, norma,
          motivoFN, juntaId, listACS, nombreTabla);

  // Nos libera el cabo sobrestante
  Future releaseCaboOfWelding({int employeeId, String weldingId}) =>
      overseerDao.releaseCaboOfWelding(employeeId, weldingId);

  // Firma del soldador manualmente
  Future addWelderSignature({String folioSoldadura}) =>
      welderDao.addWelderSignature(folioSoldadura);

  // Nos elimina el soldador y todas sus actividades consigo.
  Future removeWelderFromWeldingActivities(
          {String folioSoldadura,
          String registroSoldaduraId,
          String cuadranteSoldaduraId,
          String zonaSoldaduraId}) =>
      weldingTabDao.removeWelderActivity(
        folioSoldadura,
        registroSoldaduraId,
        cuadranteSoldaduraId,
        zonaSoldaduraId,
      );

  // Permite agregar una ficha de Soldador no valida
  Future addCardWelderWPSNotValid(
          {@required AddCardWelderNotValidParams params}) =>
      welderDao.addCardWelderWPSNotValid(params);

  // Permite el cambio de material

  Future changeMaterial({@required RequireChangeMaterialModel params}) =>
      jointDao.requiresChangeMaterial(params);

  // Nos actualiza el registro de la soldadura

  Future updateWeldingDetail(
          {@required List<UpdateWeldingDetailParams> params}) =>
      jointDao.updateWeldingDetail(params);

  Future fetchQAUser({@required int ficha}) => weldingTabDao.getUserQA(ficha);
}
