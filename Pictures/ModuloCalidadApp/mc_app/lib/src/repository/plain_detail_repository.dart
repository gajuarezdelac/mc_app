import 'package:mc_app/src/data/dao/plain_detail_dao.dart';

class PlainDetailRepository {
  final plainDetailDao = PlainDetailDao();

  Future getPlainDetails({String workId}) =>
      plainDetailDao.fetchPlainDetails(workId);

  Future getPlanCS({String workId}) => plainDetailDao.fetchPlanCS(workId);
}
