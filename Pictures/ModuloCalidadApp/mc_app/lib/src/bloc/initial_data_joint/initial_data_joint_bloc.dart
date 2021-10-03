import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/initial_data_joint/initial_data_joint_event.dart';
import 'package:mc_app/src/bloc/initial_data_joint/initial_data_joint_state_dart.dart';
import 'package:mc_app/src/models/initial_data_joint_model.dart';
import 'package:mc_app/src/repository/activity_joint_repository.dart';

class InitialDataJointBloc
    extends Bloc<InitialDataJointEvent, InitialDataJointState> {
  InitialDataJointBloc() : super(InitialJoinDatatState());

  final _initialDataJointRepository = ActivitJointRepository();

  @override
  Stream<InitialDataJointState> mapEventToState(
      InitialDataJointEvent event) async* {
    if (event is GetInitialDataJoint) {
      yield IsLoadingInitialDataJoint();

      try {
        InitialDataJointModel initialDataJointModel =
            await _initialDataJointRepository.getInitialDataJoint(
                juntaId: event.juntaId);

        yield SuccessInitialDataJoint(
            initialDataJointModel: initialDataJointModel);
      } catch (e) {
        yield ErrorInitialDataJoint(errorMessage: e.toString());
      }
    }
  }
}
