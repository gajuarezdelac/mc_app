import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_partidaPU/dropdown_partidaPU_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_partidaPU/dropdown_partidaPU_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownPartidaPUBloc
    extends Bloc<DropdownPartidaPUEvent, DropDownPartidaPUState> {
  DropDownPartidaPUBloc() : super(InitialDropDownPartidaPUState());

  final _partidaPURepository = ActivitiesRepository();

  @override
  Stream<DropDownPartidaPUState> mapEventToState(
      DropdownPartidaPUEvent event) async* {
    if (event is GetPartidaPU) {
      yield IsLoadingPartidaPU();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener la Partida PU.');
        List<PartidaPUModel> partidaPU = await _partidaPURepository
            .getPartidaPU(contractId: event.contractId);

        yield SuccessPartidaPU(partidaPU: partidaPU);
      } catch (e) {
        yield ErrorPartidaPU(errorMessage: e.toString());
      }
    }
  }
}
