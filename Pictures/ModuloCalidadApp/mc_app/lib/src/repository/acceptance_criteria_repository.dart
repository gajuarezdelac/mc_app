import 'package:mc_app/src/data/dao/acceptance_criteria_dao.dart';

class AcceptanceCriteriaRepository {
  final AcceptanceCriteriaDao acceptanceCriteriaDao = AcceptanceCriteriaDao();

  Future fetchCAS() => acceptanceCriteriaDao.getCriterioAceptacionSoldadura();

  Future fetchCAC() => acceptanceCriteriaDao.getCriterioAceptacionConformado();
}
