import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_client_activity/dropdown_client_activity_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_client_activity/dropdown_client_activity_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownClientActivityBloc
    extends Bloc<DropdownClientActivityEvent, DropDownClientActivityState> {
  DropDownClientActivityBloc() : super(InitialDropDownClientActivityState());

  final clientActivityRepository = ActivitiesRepository();

  @override
  Stream<DropDownClientActivityState> mapEventToState(
      DropdownClientActivityEvent event) async* {
    if (event is GetClienActivity) {
      yield IsLoadingClientActivity();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' ||
            event.contractId == null && event.workId == '' ||
            event.workId == null)
          throw ('Detalles al obtener la actividad. ${event.workId}');
        List<ActividadClienteModel> activityClientModel =
            await clientActivityRepository.getClientActivitie(
                contractId: event.contractId, workId: event.workId);

        yield SuccessClientActivity(activityClientModel: activityClientModel);
      } catch (e) {
        yield ErrorClientActivity(errorMessage: e.toString());
      }
    }
  }
}
