import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/joint_dao.dart';
import 'package:mc_app/src/models/params/forming_cs_params.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';

class WeldingRepository {
  final jointDao = JointDao();

  Future getJointsWC({
    String plainDetailId,
    int frontId,
    String state,
    bool clear,
  }) =>
      jointDao.fetchJointsWC(
        plainDetailId,
        frontId,
        state,
        clear,
      );

  Future saveFormingCS({@required FormingCSParams params}) =>
      jointDao.saveFormingCS(params);

  Future updateWeldingDetail(
          {@required List<UpdateWeldingDetailParams> params}) =>
      jointDao.updateWeldingDetail(params);
}
