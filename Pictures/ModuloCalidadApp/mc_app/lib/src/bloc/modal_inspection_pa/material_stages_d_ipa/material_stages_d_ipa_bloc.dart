import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/material_stages_d_ipa/material_stages_d_ipa_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/material_stages_d_ipa/material_stages_d_ipa_state.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class MaterialStagesDIPABloc extends Bloc<MaterialStagesDIPAEvent, MaterialStagesDIPAState> {
  MaterialStagesDIPABloc() : super(InitialMaterialStagesDIPAState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<MaterialStagesDIPAState> mapEventToState(MaterialStagesDIPAEvent event) async* {
    if (event is GetMaterialStagesDIPA) {
      yield IsLoadingMaterialStagesDIPA();

      try {
        List<MaterialStagesDIPAModel> data = await _anticorrosiveProtectionRepository.selMaterialStagesDIPA(event.noRegistro);

        yield SuccessGetMaterialStagesDIPA(data: data);
      } catch (e) {
        yield ErrorMaterialStagesDIPAState(errorMessage: e.toString());
      }
    }

    if (event is InsUpdMaterialStagesDIPA) {
      yield IsLoadingMaterialStagesDIPA();

      try {
        await _anticorrosiveProtectionRepository.insUpdMaterialsStagesDIPA(event.params);

        yield SuccessInsUpdMaterialStagesDIPA();
      } catch (e) {
        yield ErrorMaterialStagesDIPAState(errorMessage: e.toString());
      }
    }
  }
}