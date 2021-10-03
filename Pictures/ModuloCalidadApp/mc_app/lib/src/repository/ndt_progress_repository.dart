import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/ndt_progress_dao.dart';

class NDTProgressRepository {
  final jointNDTProgress = NDTProgressDao();

  Future getNDTProgress({@required String jointId}) =>
      jointNDTProgress.fetchNDTJointProgress(jointId);
}
