import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
// import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
import 'package:mc_app/src/repository/non_compliant_output_repository.dart';
import 'contracts_snc_event.dart';
import 'contracts_snc_state.dart';

class ContractsSNCOutputBloc
    extends Bloc<ContractsSNCEvent, ContractsSNCState> {
  ContractsSNCOutputBloc() : super(InitialContractsSNCState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<ContractsSNCState> mapEventToState(ContractsSNCEvent event) async* {
    if (event is FetchContractsSNC) {
      yield InitialContractsSNCState();

      try {
        List<ContractDropdownModelSNC> list =
            await _ncoRepository.fetchContractsSNC(bandeja: event.bandeja);

        yield SuccessContractsSNC(contractModelList: list);
      } catch (e) {
        print(e);
        yield ErrorContractsSNC(error: e.toString());
      }
    }
  }
}
