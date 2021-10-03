import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/repository/pipefitter_repository.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_add/pipefitter_add_event.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_add/pipefitter_add_state.dart';

class PipefitterAddBloc extends Bloc<PipefitterAddEvent, PipefitterAddState> {
  PipefitterAddBloc() : super(InitialPipefitterAddState());

  final _repository = PipefitterRepository();

  @override
  Stream<PipefitterAddState> mapEventToState(PipefitterAddEvent event) async* {
    if (event is PipefitterAdd) {
      yield IsAddingPipefitter();

      try {
        int result = await _repository.addPipefitter(
          card: event.card,
          jointId: event.jointId,
        );

        yield SuccessPipefitterAdd(result: result);
      } catch (e) {
        yield ErrorPipefitterAdd(error: e.toString());
      }
    }
  }
}
