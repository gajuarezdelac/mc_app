import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/acc/acc_event.dart';
import 'package:mc_app/src/bloc/tab_welding/acc/acc_state.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/repository/acceptance_criteria_repository.dart';

class ACCBloc extends Bloc<ACCStateEvent, ACCState> {
  ACCBloc() : super(InitialACCtate());

  final _acceptanceRepository = AcceptanceCriteriaRepository();

  @override
  Stream<ACCState> mapEventToState(ACCStateEvent event) async* {
    // Loading!!

    if (event is GetACC) {
      yield IsLoadingACC();

      try {
        List<AcceptanceCriteriaconformadoModel> listACC =
            await _acceptanceRepository.fetchCAC();

        yield SuccessACC(listACC: listACC);
      } catch (e) {
        yield ErrorACC(errorMessage: e.toString());
      }
    }
  }
}
