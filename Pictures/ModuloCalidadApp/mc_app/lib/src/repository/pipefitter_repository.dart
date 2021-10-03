import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/pipefitter_dao.dart';

class PipefitterRepository {
  final pipefitterDao = PipefitterDao();

  Future deletePipefitter({
    @required int employeeId,
    @required String jointId,
  }) =>
      pipefitterDao.deletePipefitter(employeeId, jointId);

  Future signPipefitter({
    @required int employeeId,
    @required String jointId,
  }) =>
      pipefitterDao.signPipefitter(employeeId, jointId);

  Future addPipefitter({
    @required int card,
    @required String jointId,
  }) =>
      pipefitterDao.addPipefitter(card, jointId);

  Future fetchPipefitters({@required String jointId}) =>
      pipefitterDao.getPipefitters(jointId);
}
