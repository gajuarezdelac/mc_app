import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one_remove/traceability_one_remove_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one_remove/traceability_one_remove_state.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityOneRemoveBloc
    extends Bloc<TraceabilityOneRemoveEvent, TraceabilityOneRemoveState> {
  TraceabilityOneRemoveBloc() : super(InitialTraceabilityOneRemoveState());

  final _repository = TraceabilityRepository();

  @override
  Stream<TraceabilityOneRemoveState> mapEventToState(
      TraceabilityOneRemoveEvent event) async* {
    if (event is DeleteTraceabilityOne) {
      yield IsDeletingTraceabilityOneRemove();

      try {
        int result = await _repository.deleteTraceability(params: event.params);

        yield SuccessTraceabilityOneRemove(result: result);
      } catch (e) {
        yield ErrorTraceabilityOneRemove(error: e.toString());
      }
    }
  }
}
