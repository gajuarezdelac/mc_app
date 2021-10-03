import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/add_welder/add_welder_event.dart';
import 'package:mc_app/src/bloc/tab_welding/add_welder/add_welder_state.dart';
import 'package:mc_app/src/models/empleado_soldador_not_valid_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:mc_app/src/repository/welding_tab_repository.dart';

class AddWelderBloc extends Bloc<AddWelderEvent, AddWelderState> {
  AddWelderBloc() : super(InitialAddWelderState());

  final _qualifyRegisterRepository = WeldingTabRepository();

  @override
  Stream<AddWelderState> mapEventToState(AddWelderEvent event) async* {
    // Agregamos el soldador con WPS valido.
    if (event is AddWelderWPSValid) {
      yield IsLoadingAddWelderWPSValid();

      try {
        AddWelderModelResponse addWelderModelResponse =
            await _qualifyRegisterRepository.addCardWelderWPSValid(
          params: event.addCardWelder,
        );
        yield SuccessAddWelderWPSValid(
            addWelderModelResponse: addWelderModelResponse);
      } catch (e) {
        yield ErrorAddWelderWPSValid(errorMessage: e.toString());
      }
    }

    // Agregamos el soldador con WPS no valido.
    if (event is AddWelderWPSNotValid) {
      yield IsLoadingAddWelderWPSNotValid();

      try {
        EmpleadoSoldadorNotValidModel empleadoSoldadorNotValidModel =
            await _qualifyRegisterRepository.addCardWelderWPSNotValid(
                params: event.addCardWelderNotValidParams);
        yield SucessAddWeldingWPSNotValid(
            empleadoSoldadorNotValidModel: empleadoSoldadorNotValidModel);
      } catch (e) {
        yield ErrorAddWeldingWPSNotValid(errorMessage: e.toString());
      }
    }
  }
}
