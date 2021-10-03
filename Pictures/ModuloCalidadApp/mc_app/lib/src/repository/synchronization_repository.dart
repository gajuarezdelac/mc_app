import 'package:mc_app/src/data/dao/synchronization_dao.dart';
import 'package:mc_app/src/models/synchronization_model.dart';

class SynchronizationRepository {
  final syncDao = SynchronizationDao();

  Future getSynchronizations({String query}) => syncDao.fetchAllSynchronizations();
  Future getLastSynchronization({String query}) => syncDao.fetchLastSynchronization();
  Future insertSynchronization({SynchronizationModel sync}) => syncDao.insertSynchronization(sync);
  Future updateSynchronization({SynchronizationModel sync}) => syncDao.updateSynchronization(sync);
}