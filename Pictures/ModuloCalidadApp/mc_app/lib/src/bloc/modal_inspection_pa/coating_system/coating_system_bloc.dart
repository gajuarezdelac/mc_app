import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_system/coating_system_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_system/coating_system_state.dart';
import 'package:mc_app/src/models/coating_system_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class CoatingSystemBloc extends Bloc<CoatingSystemEvent, CoatingSystemState> {
  CoatingSystemBloc() : super(InitialCoatingSystemState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<CoatingSystemState> mapEventToState(CoatingSystemEvent event) async* {
    if (event is GetStagesCoatingSystem) {
      yield IsLoadingCoatingSystem();

      try {
        List<CoatingSystemModel> data =
            await _anticorrosiveProtectionRepository.selStagesCoatingSystem(event.noRegistro);

        yield SuccessCoatingSystem(
            data: data);
      } catch (e) {
        yield ErrorCoatingSystem(errorMessage: e.toString());
      }
    }
  }
}