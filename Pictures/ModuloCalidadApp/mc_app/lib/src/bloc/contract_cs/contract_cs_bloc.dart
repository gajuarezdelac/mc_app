import 'bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/repository/contract_repository.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';

class ContractCSBloc extends Bloc<ContractCSEvent, ContractCSState> {
  ContractCSBloc() : super(InitialContractCSState());

  final _contractRepository = ContractRepository();

  @override
  Stream<ContractCSState> mapEventToState(ContractCSEvent event) async* {
    if (event is GetContractsCS) {
      yield IsLoadingContractCS();

      try {
        List<ContractCSDropdownModel> contracts =
            await _contractRepository.getContractsCS();

        yield SuccessContractCS(contracts: contracts);
      } catch (e) {
        yield ErrorContractCS(error: e.toString());
      }
    }
  }
}
