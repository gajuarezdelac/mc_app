import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability/traceability_event.dart';
import 'package:mc_app/src/bloc/tab_forming/traceability/traceability_state.dart';
import 'package:mc_app/src/models/traceability_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class TraceabilityBloc extends Bloc<TraceabilityEvent, TraceabilityState> {
  TraceabilityBloc() : super(InitialTraceabilityState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<TraceabilityState> mapEventToState(TraceabilityEvent event) async* {
    if (event is GetTraceabilityById) {
      yield IsLoadingTraceabilityById();

      try {
        TraceabilityModel traceability = await _traceabilityRepository
            .fetchTraceabilityById(traceabilityId: event.traceabilityId);

        yield SuccessTraceabilityById(
          traceability: traceability,
          isTraceabilityOne: event.isTraceabilityOne,
        );
      } catch (e) {
        yield ErrorTraceabilityById(errorMessage: e.toString());
      }
    }
    /*else if (event is GetTraceabilityOne) {
      yield IsLoadingTraceabilityOne();

      try {
        TraceabilityByJointModel traceabilityOne =
            await _traceabilityRepository.fetchTraceabilityByJoint(
          jointId: event.jointId,
          isTraceabilityOne: event.isTraceabilityOne,
        );

        yield SuccessTraceabilityOne(traceabilityOne: traceabilityOne);
      } catch (e) {
        yield ErrorTraceabilityOne(errorMessageByJoint: e.toString());
      }
    } else if (event is GetTraceabilityTwo) {
      yield IsLoadingTraceabilityTwo();

      try {
        TraceabilityByJointModel traceabilityTwo =
            await _traceabilityRepository.fetchTraceabilityByJoint(
          jointId: event.jointId,
          isTraceabilityOne: event.isTraceabilityOne,
        );

        yield SuccessTraceabilityTwo(traceabilityTwo: traceabilityTwo);
      } catch (e) {
        yield ErrorTraceabilityTwo(errorMessageByJoint: e.toString());
      }
    }*/
  }
}
