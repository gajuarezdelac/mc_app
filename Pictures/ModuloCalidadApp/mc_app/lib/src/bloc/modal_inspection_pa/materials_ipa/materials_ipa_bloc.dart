import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/materials_ipa/materials_ipa_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/materials_ipa/materials_ipa_state.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class MaterialsIPABloc extends Bloc<MaterialsIPAEvent, MaterialsIPAState> {
  MaterialsIPABloc() : super(InitialMaterialsIPAState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<MaterialsIPAState> mapEventToState(MaterialsIPAEvent event) async* {
    if (event is GetMaterialsIPA) {
      yield IsLoadingMaterialsIPA();

      try {
        List<MaterialsTableIPAModel> data = await _anticorrosiveProtectionRepository.selMaterialsByRecordNo(event.noRegistro);

        yield SuccessGetMaterialsIPA(data: data);
      } catch (e) {
        yield ErrorMaterialsIPAState(errorMessage: e.toString());
      }
    }

    if (event is InsUpdMaterialsIPA) {
      yield IsLoadingMaterialsIPA();

      try {
        await _anticorrosiveProtectionRepository.insUpdMaterialsIPA(event.params, event.noRegistro);

        yield SuccessInsUpdMaterialsIPA();
      } catch (e) {
        yield ErrorMaterialsIPAState(errorMessage: e.toString());
      }
    }
  }
}