import 'bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/repository/contract_repository.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';

class DropDownContractBloc
    extends Bloc<DropDownContractEvent, DropDownContractState> {
  DropDownContractBloc() : super(InitialDropDownContractState());

  final _contractRepository = ContractRepository();

  @override
  Stream<DropDownContractState> mapEventToState(
      DropDownContractEvent event) async* {
    if (event is GetContracts) {
      yield IsLoadingContract();

      try {
        List<ContractDropdownModel> contracts =
            await _contractRepository.getContracts();

        yield SuccessContract(contracts: contracts);
      } catch (e) {
        yield ErrorContract(errorMessage: e.toString());
      }
    }
  }
}
