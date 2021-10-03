import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/acs/acs_event.dart';
import 'package:mc_app/src/bloc/tab_welding/acs/acs_state.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/repository/acceptance_criteria_repository.dart';

class ACSBloc extends Bloc<ACSStateEvent, ACSState> {
  ACSBloc() : super(InitialACState());

  final _acceptanceRepository = AcceptanceCriteriaRepository();

  @override
  Stream<ACSState> mapEventToState(ACSStateEvent event) async* {
    // Loading!!

    if (event is GetACS) {
      yield IsLoadingACS();

      try {
        List<AcceptanceCriteriaWeldingModel> listACS =
            await _acceptanceRepository.fetchCAS();

        yield SuccessACS(listACS: listACS);
      } catch (e) {
        yield ErrorACS(errorMessage: e.toString());
      }
    }
  }
}
