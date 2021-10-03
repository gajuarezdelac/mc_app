import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter/pipefitter_event.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter/pipefitter_state.dart';
import 'package:mc_app/src/models/pipefitter_model.dart';
import 'package:mc_app/src/repository/pipefitter_repository.dart';

class PipefitterBloc extends Bloc<PipefitterEvent, PipefitterState> {
  PipefitterBloc() : super(InitialPipefittersState());

  final _repository = PipefitterRepository();

  @override
  Stream<PipefitterState> mapEventToState(PipefitterEvent event) async* {
    if (event is GetPipefitters) {
      yield IsLoadingPipefitters();

      try {
        List<PipefitterModel> pipefitters =
            await _repository.fetchPipefitters(jointId: event.jointId);

        yield SuccessPipefitters(pipefitters: pipefitters);
      } catch (e) {
        yield ErrorPipefitters(error: e.toString());
      }
    }
  }
}
