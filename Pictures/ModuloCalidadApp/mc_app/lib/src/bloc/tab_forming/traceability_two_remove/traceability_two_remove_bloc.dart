import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two_remove/traceability_two_remove_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two_remove/traceability_two_remove_state.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityTwoRemoveBloc
    extends Bloc<TraceabilityTwoRemoveEvent, TraceabilityTwoRemoveState> {
  TraceabilityTwoRemoveBloc() : super(InitialTraceabilityTwoRemoveState());

  final _repository = TraceabilityRepository();

  @override
  Stream<TraceabilityTwoRemoveState> mapEventToState(
      TraceabilityTwoRemoveEvent event) async* {
    if (event is DeleteTraceabilityTwo) {
      yield IsDeletingTraceabilityTwoRemove();

      try {
        int result = await _repository.deleteTraceability(params: event.params);

        yield SuccessTraceabilityTwoRemove(result: result);
      } catch (e) {
        yield ErrorTraceabilityTwoRemove(error: e.toString());
      }
    }
  }
}
