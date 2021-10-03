import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_system/dropdown_system_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_system/dropdown_system_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownSystemBloc
    extends Bloc<DropdownSystemEvent, DropDownSystemState> {
  DropDownSystemBloc() : super(InitialDropDownSystemState());

  final systemRepository = ActivitiesRepository();

  @override
  Stream<DropDownSystemState> mapEventToState(
      DropdownSystemEvent event) async* {
    if (event is GetSystem) {
      yield IsLoadingSystem();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener la especialidad. ${event.folioId}');
        List<SistemaModel> systemModel = await systemRepository.getSystem(
            folioId: event.folioId, contractId: event.contractId);

        yield SuccessSystem(systemModel: systemModel);
      } catch (e) {
        yield ErrorSystem(errorMessage: e.toString());
      }
    }
  }
}
