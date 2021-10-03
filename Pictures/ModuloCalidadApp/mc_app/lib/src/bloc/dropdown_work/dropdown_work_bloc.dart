import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/repository/work_repository.dart';
import 'package:mc_app/src/bloc/dropdown_work/dropdown_work_event.dart';
import 'package:mc_app/src/bloc/dropdown_work/dropdown_work_state.dart';

class DropDownWorkBloc extends Bloc<DropDownWorkEvent, DropDownWorkState> {
  DropDownWorkBloc() : super(InitialDropDownWorkState());

  final _workRepository = WorkRepository();

  @override
  Stream<DropDownWorkState> mapEventToState(DropDownWorkEvent event) async* {
    if (event is GetWorksById) {
      yield IsLoadingWorks();

      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener el Contrato seleccionado.');

        List<WorkDropDownModel> works =
            await _workRepository.getWorksById(contractId: event.contractId);

        yield SuccessWorks(works: works);
      } catch (e) {
        yield ErrorWorks(errorMessage: e.toString());
      }
    }
  }
}
