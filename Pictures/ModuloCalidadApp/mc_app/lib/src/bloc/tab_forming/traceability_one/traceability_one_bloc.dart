import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one/traceability_one_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability_one/traceability_one_state.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityOneBloc
    extends Bloc<TraceabilityOneEvent, TraceabilityOneState> {
  TraceabilityOneBloc() : super(InitialTraceabilityOneState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<TraceabilityOneState> mapEventToState(
      TraceabilityOneEvent event) async* {
    if (event is GetTraceabilityOne) {
      yield IsLoadingTraceabilityOne();

      try {
        TraceabilityByJointModel traceabilityOne =
            await _traceabilityRepository.fetchTraceabilityByJoint(
          jointId: event.jointId,
          isTraceabilityOne: event.isTraceabilityOne,
        );

        yield SuccessTraceabilityOne(traceabilityOne: traceabilityOne);
      } catch (e) {
        yield ErrorTraceabilityOne(error: e.toString());
      }
    }
  }
}
