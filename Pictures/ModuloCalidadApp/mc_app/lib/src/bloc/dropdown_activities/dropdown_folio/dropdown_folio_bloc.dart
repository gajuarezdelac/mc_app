import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_folio/dropdown_folio_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_folio/dropdown_folio_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownFolioBloc extends Bloc<DropdownFolioEvent, DropDownFolioState> {
  DropDownFolioBloc() : super(InitialDropDownFolioState());

  final folioRepository = ActivitiesRepository();

  @override
  Stream<DropDownFolioState> mapEventToState(DropdownFolioEvent event) async* {
    if (event is GetFolio) {
      yield IsLoadingFolio();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' ||
            event.contractId == null && event.obraId == '' ||
            event.obraId == null)
          throw ('Detalles al obtener folio. ${event.obraId}');
        List<FolioDropdownModel> folioModel = await folioRepository.getFolio(
            contractId: event.contractId,
            workId: event.obraId,
            site: event.site);

        yield SuccessFolio(folioModel: folioModel);
      } catch (e) {
        yield ErrorFolio(errorMessage: e.toString());
      }
    }
  }
}
