import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_plane_subactivity/dropdown_plane_subactivity_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_plane_subactivity/dropdown_plane_subactivity_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownPlaneSubactivityBloc
    extends Bloc<DropdownPlaneSubactivityEvent, DropDownPlaneSubactivityState> {
  DropDownPlaneSubactivityBloc()
      : super(InitialDropDownPlaneSubactivityState());

  final planeActivitieRepository = ActivitiesRepository();

  @override
  Stream<DropDownPlaneSubactivityState> mapEventToState(
      DropdownPlaneSubactivityEvent event) async* {
    if (event is GetPlaneSubactivity) {
      yield IsLoadingPlaneSubactivity();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener la especialidad. ${event.folioId}');
        List<PlanoSubActividadModel> planeSubactivityModel =
            await planeActivitieRepository.getPlaneSubactivity(
                contractId: event.contractId, folioId: event.folioId);

        yield SuccessPlaneSubactivity(
            planeSubactivityModel: planeSubactivityModel);
      } catch (e) {
        yield ErrorPlaneSubactivity(errorMessage: e.toString());
      }
    }
  }
}
