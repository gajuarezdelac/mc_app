import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/stage_material_ipa/stage_material_ipa_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/stage_material_ipa/stage_material_ipa_state.dart';
import 'package:mc_app/src/models/stage_materials_ipa_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class StageMaterialIPABloc extends Bloc<StageMaterialIPAEvent, StageMaterialIPAState> {
  StageMaterialIPABloc() : super(InitialStageMaterialIPAState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<StageMaterialIPAState> mapEventToState(StageMaterialIPAEvent event) async* {
    if (event is GetStageMaterialIPA) {
      yield IsLoadingStageMaterialIPA();

      try {
        List<StageMaterialsIPAModel> data = await _anticorrosiveProtectionRepository.selStageMaterialsIPA(event.noRegistro);
      
        yield SuccessGetStageMaterialIPA(data: data);
      } catch (e) {
        yield ErrorStageMaterialIPA(errorMessage: e.toString());
      }
    }

    if (event is InsUpdStageMaterialIPA) {
      yield IsLoadingStageMaterialIPA();

      try {
        await _anticorrosiveProtectionRepository.insUpdStagesMaterialIPA(event.params);

        yield SuccessInsUpdStageMaterialIPA();
      } catch (e) {
        yield ErrorStageMaterialIPA(errorMessage: e.toString());
      }
    }
  }
}