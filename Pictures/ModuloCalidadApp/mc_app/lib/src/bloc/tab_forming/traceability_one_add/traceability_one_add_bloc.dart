import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one_add/traceability_one_add_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one_add/traceability_one_add_state.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityOneAddBloc
    extends Bloc<TraceabilityOneAddEvent, TraceabilityOneAddState> {
  TraceabilityOneAddBloc() : super(InitialTraceabilityOneAddState());

  final _repository = TraceabilityRepository();

  @override
  Stream<TraceabilityOneAddState> mapEventToState(
      TraceabilityOneAddEvent event) async* {
    if (event is AddTraceabilityOne) {
      yield IsAddingTraceabilityOne();

      try {
        int result = await _repository.addTraceability(params: event.params);

        yield SuccessTraceabilityOneAdd(result: result);
      } catch (e) {
        yield ErrorTraceabilityOneAdd(error: e.toString());
      }
    }
  }
}
