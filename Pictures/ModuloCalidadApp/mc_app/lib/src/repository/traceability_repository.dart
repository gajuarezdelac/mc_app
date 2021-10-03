import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/traceability_dao.dart';
import 'package:mc_app/src/models/params/joint_traceability_params.dart';
import 'package:mc_app/src/models/params/traceability_delete_params_model.dart';
import 'package:mc_app/src/models/params/traceability_params_model.dart';

class TraceabilityRepository {
  final traceabilityDao = TraceabilityDao();

  Future fetchTraceabilityById({@required String traceabilityId}) =>
      traceabilityDao.fetchTraceabilityById(traceabilityId);

  Future fetchTraceabilityByJoint(
          {@required String jointId, @required bool isTraceabilityOne}) =>
      traceabilityDao.fetchTraceabilityByJoint(jointId, isTraceabilityOne);

  Future deleteTraceability({@required TraceabilityDeleteParamsModel params}) =>
      traceabilityDao.deleteVolume(params);

  Future addTraceability({@required TraceabilityParamsModel params}) =>
      traceabilityDao.setVolume(params);

  Future getJointsTraceability({@required JointTraceabilityParams params}) =>
      traceabilityDao.getJointsTraceability(params);

  Future fetchWorkTraceabilty({@required String contradoId}) =>
      traceabilityDao.fetchWorkTraceabilty(contradoId);

  Future getExistingElement({@required String idElementoExistente}) =>
      traceabilityDao.getExistingElement(idElementoExistente);
}
