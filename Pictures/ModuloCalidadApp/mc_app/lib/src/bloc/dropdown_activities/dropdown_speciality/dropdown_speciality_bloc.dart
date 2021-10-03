import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_speciality/dropdown_specialty_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_speciality/dropdown_specialty_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownSpecialityBloc
    extends Bloc<DropdownSpecialtyEvent, DropDownSpecialtyState> {
  DropDownSpecialityBloc() : super(InitialDropDownspecialtyState());

  final specialtyRepository = ActivitiesRepository();

  @override
  Stream<DropDownSpecialtyState> mapEventToState(
      DropdownSpecialtyEvent event) async* {
    if (event is GetSpeciality) {
      yield IsLoadingSpecialty();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener la especialidad. ${event.folioId}');
        List<EspecialidadModel> specialtyModel =
            await specialtyRepository.getEspecialidad(
                contractId: event.contractId, folioId: event.folioId);

        yield SuccessSpecialty(specialtyModel: specialtyModel);
      } catch (e) {
        yield ErrorSpecialty(errorMessage: e.toString());
      }
    }
  }
}
