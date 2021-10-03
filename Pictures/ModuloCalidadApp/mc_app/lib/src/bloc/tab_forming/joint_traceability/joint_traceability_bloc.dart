import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/joint_traceability/joint_traceability_event.dart';
import 'package:mc_app/src/bloc/tab_forming/joint_traceability/joint_traceability_state.dart';
import 'package:mc_app/src/models/joint_traceability_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class JointTraceabilityBloc
    extends Bloc<JointTraceabilityEvent, JointTraceabilityState> {
  JointTraceabilityBloc() : super(InitialJointTraceabilityState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<JointTraceabilityState> mapEventToState(
      JointTraceabilityEvent event) async* {
    if (event is GetJointTraceability) {
      yield IsLoadingJointTraceability();

      try {
        List<JointTraceabilityModel> joints = await _traceabilityRepository
            .getJointsTraceability(params: event.params);

        yield SuccessJointTraceability(
          joints: joints,
          traceabilityId: event.params.traceabilityId,
          isTraceabilityOne: event.params.isTraceabilityOne,
        );
      } catch (e) {
        yield ErrorJointTraceability(error: e.toString());
      }
    }
  }
}
