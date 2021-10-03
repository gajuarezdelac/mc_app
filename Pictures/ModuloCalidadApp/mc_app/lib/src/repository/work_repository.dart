import 'package:mc_app/src/data/dao/work_dao.dart';

class WorkRepository {
  final workDao = WorkDao();

  Future getWorksById({String contractId}) =>
      workDao.fetchWorksById(contractId);

  Future getWorkCS({String contractId}) => workDao.fetchWorksCS(contractId);
}
