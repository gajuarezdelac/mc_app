import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_reprogramation/dropdown_reprogramation_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_reprogramation/dropdown_reprogramation_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownReprogramationBloc
    extends Bloc<DropdownReprogramationEvent, DropDownReprogramationState> {
  DropDownReprogramationBloc() : super(InitialDropDownReprogramationState());

  final _reprogramationRepository = ActivitiesRepository();

  @override
  Stream<DropDownReprogramationState> mapEventToState(
      DropdownReprogramationEvent event) async* {
    if (event is GetReprogramation) {
      yield IsLoadingReprogramacion();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.workId == '' || event.workId == null)
          throw ('Detalles al obtener la reprogramación. ${event.workId}');
        List<ReprogramacionModel> reprogramationModel =
            await _reprogramationRepository.getReprogramtion(
                workId: event.workId);

        yield SuccessReprogramation(reprogramationModel: reprogramationModel);
      } catch (e) {
        yield ErrorReprogramation(errorMessage: e.toString());
      }
    }
  }
}
