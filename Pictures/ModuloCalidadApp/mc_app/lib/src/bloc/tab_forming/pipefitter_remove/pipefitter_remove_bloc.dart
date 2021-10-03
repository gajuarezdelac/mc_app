import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_remove/pipefitter_remove_event.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_remove/pipefitter_remove_state.dart';
import 'package:mc_app/src/repository/pipefitter_repository.dart';

class PipefitterRemoveBloc
    extends Bloc<PipefitterRemoveEvent, PipefitterRemoveState> {
  PipefitterRemoveBloc() : super(InitialPipefitterRemoveState());

  final _repository = PipefitterRepository();

  @override
  Stream<PipefitterRemoveState> mapEventToState(
      PipefitterRemoveEvent event) async* {
    if (event is PipefitterRemove) {
      yield IsRemovingPipefitter();

      try {
        int result = await _repository.deletePipefitter(
          employeeId: event.employeeId,
          jointId: event.jointId,
        );

        yield SuccessPipefitterRemove(result: result);
      } catch (e) {
        yield ErrorPipefitterRemove(error: e.toString());
      }
    }
  }
}
