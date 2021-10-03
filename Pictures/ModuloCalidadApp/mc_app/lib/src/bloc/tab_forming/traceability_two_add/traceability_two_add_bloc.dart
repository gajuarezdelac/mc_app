import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two_add/traceability_two_add_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two_add/traceability_two_add_state.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityTwoAddBloc
    extends Bloc<TraceabilityTwoAddEvent, TraceabilityTwoAddState> {
  TraceabilityTwoAddBloc() : super(InitialTraceabilityTwoAddState());

  final _repository = TraceabilityRepository();

  @override
  Stream<TraceabilityTwoAddState> mapEventToState(
      TraceabilityTwoAddEvent event) async* {
    if (event is AddTraceabilityTwo) {
      yield IsAddingTraceabilityTwo();

      try {
        int result = await _repository.addTraceability(params: event.params);

        yield SuccessTraceabilityTwoAdd(result: result);
      } catch (e) {
        yield ErrorTraceabilityTwoAdd(error: e.toString());
      }
    }
  }
}
