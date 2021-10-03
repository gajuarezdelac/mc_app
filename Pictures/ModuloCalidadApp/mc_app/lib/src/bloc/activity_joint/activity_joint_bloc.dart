import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/activity_joint/activity_joint_event.dart';
import 'package:mc_app/src/bloc/activity_joint/activity_joint_state.dart';
import 'package:mc_app/src/models/activity_joint_model.dart';
import 'package:mc_app/src/repository/activity_joint_repository.dart';

class JointActivityBloc extends Bloc<ActivityJointEvent, ActivityJointState> {
  JointActivityBloc() : super(InitialActivityJoint());

  final _activityJointRepository = ActivitJointRepository();

  @override
  Stream<ActivityJointState> mapEventToState(ActivityJointEvent event) async* {
    if (event is GetJointActivity) {
      yield IsLoadingActivityJoint();

      try {
        ActivityJointModel activityJointModel =
            await _activityJointRepository.getActivityByJoint(
          siteId: event.siteId,
          actividadId: event.actividadId,
          propuestaTecnicaId: event.propuestaTecnicaId,
          subActividadId: event.subActividadId,
        );

        yield SuccessActivityJoint(activityJointModel: activityJointModel);
      } catch (e) {
        yield ErrorActivityJoint(errorMessage: e.toString());
      }
    }
  }
}
