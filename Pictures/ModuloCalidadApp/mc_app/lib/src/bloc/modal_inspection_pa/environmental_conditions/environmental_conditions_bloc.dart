import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/environmental_conditions/environmental_conditions_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/environmental_conditions/environmental_conditions_state.dart';
import 'package:mc_app/src/models/environmental_conditions_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class EnvironmentalConditionsBloc
    extends Bloc<EnvironmentalConditionsEvent, EnvironmentalConditionsState> {
  EnvironmentalConditionsBloc() : super(InitialEnvironmentalConditionsState());

  final _anticorrosiveProtectionRepository =
      AnticorrosiveProtectionRepository();

  @override
  Stream<EnvironmentalConditionsState> mapEventToState(
      EnvironmentalConditionsEvent event) async* {
    if (event is GetEnvironmentalConditions) {
      yield IsLoadingEnvironmentalConditions();

      try {
        List<EnvironmentalConditionsModel> data =
            await _anticorrosiveProtectionRepository
                .selEnvironmentalConditions(event.noRegistro);

        yield SuccessGetEnvironmentalConditions(data: data);
      } catch (e) {
        yield ErrorEnvironmentalConditions(errorMessage: e.toString());
      }
    }

    if (event is InsUpdEnvironmentalConditions) {
      yield IsLoadingEnvironmentalConditions();

      try {
        await _anticorrosiveProtectionRepository.insUpdEnvironmentalConditions(
            event.noRegistro, event.param);

        yield SuccessInsUpdEnvironmentalConditions();
      } catch (e) {
        yield ErrorEnvironmentalConditions(errorMessage: e.toString());
      }
    }
  }
}
