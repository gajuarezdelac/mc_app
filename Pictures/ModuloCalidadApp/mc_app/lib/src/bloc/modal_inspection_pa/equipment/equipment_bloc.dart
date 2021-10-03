import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/equipment/equipment_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/equipment/equipment_state.dart';
import 'package:mc_app/src/models/equipment_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  EquipmentBloc() : super(InitialEquipmentState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<EquipmentState> mapEventToState(EquipmentEvent event) async* {
    if (event is GetEquipment) {
      yield IsLoadingEquipment();

      try {
        List<EquipmentModel> data =
            await _anticorrosiveProtectionRepository.selEquipment(event.noRegistro);

        yield SuccessEquipment(
            data: data);
      } catch (e) {
        yield ErrorEquipment(errorMessage: e.toString());
      }
    }

    if (event is InsUpdEquipment) {
      yield IsLoadingEquipment();

      try {
        await _anticorrosiveProtectionRepository.insUpdEquipment(event.noRegistro, event.params);

        yield SuccessInsUpdEquipment();
      } catch (e) {
        yield ErrorEquipment(errorMessage: e.toString());
      }
    }
  }
}