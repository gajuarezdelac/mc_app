import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two/traceability_two_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_two/traceability_two_state.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityTwoBloc
    extends Bloc<TraceabilityTwoEvent, TraceabilityTwoState> {
  TraceabilityTwoBloc() : super(InitialTraceabilityTwoState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<TraceabilityTwoState> mapEventToState(
      TraceabilityTwoEvent event) async* {
    if (event is GetTraceabilityTwo) {
      yield IsLoadingTraceabilityTwo();

      try {
        TraceabilityByJointModel traceabilityTwo =
            await _traceabilityRepository.fetchTraceabilityByJoint(
          jointId: event.jointId,
          isTraceabilityOne: event.isTraceabilityOne,
        );

        yield SuccessTraceabilityTwo(traceabilityTwo: traceabilityTwo);
      } catch (e) {
        yield ErrorTraceabilityTwo(error: e.toString());
      }
    }
  }
}
