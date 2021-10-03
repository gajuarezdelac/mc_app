import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/relate_joint/relate_joint_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/relate_joint/relate_joint_state.dart';
import 'package:mc_app/src/repository/activities_repository.dart';
import 'package:mc_app/src/models/relate_activity_model.dart';

class RelateJointBloc extends Bloc<RelateJointEvent, RelateJointState> {
  RelateJointBloc() : super(InitialRelateJointState());

  final _relateJointRepository = ActivitiesRepository();

  @override
  Stream<RelateJointState> mapEventToState(RelateJointEvent event) async* {
    if (event is PutRelateJoint) {
      yield IsLoadingRelateJoint();
      try {
        RelateActivityModel relateActivity;
        int messgeSuccess = await _relateJointRepository.updateJointActivity(
            siteId: event.siteId,
            propuestaTecnicaId: event.propuestaTecnicaId,
            actividadId: event.actividadId,
            subActividadId: event.subActividadId,
            juntaId: event.juntaId);

        if (messgeSuccess > 0) {
          relateActivity = new RelateActivityModel();
          relateActivity.siteId = event.siteId;
          relateActivity.propuestaTecnicaId =
              event.propuestaTecnicaId.toString();
          relateActivity.actividadId = event.actividadId.toString();
          relateActivity.subActividadId = event.subActividadId.toString();
          relateActivity.juntaId = event.juntaId;
        }

        yield SuccessRelateJoint(relateActivity: relateActivity);
      } catch (e) {
        yield ErrorRelateJoint(messageError: e.toString());
      }
    }
  }
}
