import 'package:mc_app/src/data/dao/contract_dao.dart';

class ContractRepository {
  final contractDao = ContractDao();

  Future getContracts() => contractDao.fetchAllContracts();

  Future getContractsCS() async => contractDao.fetchContractsCS();
}
