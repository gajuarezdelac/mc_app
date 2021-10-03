import 'package:mc_app/src/data/dao/activity_joint_dao.dart';
import 'package:mc_app/src/data/dao/initial_data_joint_dao.dart';

class ActivitJointRepository {
  final activityJointDao = ActivityJointDao();
  final jointInitialDataDao = InitialDataJointDao();

  Future getActivityByJoint(
          {String siteId,
          double propuestaTecnicaId,
          double actividadId,
          int subActividadId}) =>
      activityJointDao.fetchActivityByJoint(
        siteId,
        propuestaTecnicaId,
        actividadId,
        subActividadId,
      );

  Future getInitialDataJoint({String juntaId}) =>
      jointInitialDataDao.fetchInitialDataJoint(juntaId);
}
