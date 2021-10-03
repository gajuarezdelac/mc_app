import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/anticorrosive_ipa/anticorrosive_ipa_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/anticorrosive_ipa/anticorrosive_ipa_state.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class InfoGeneralBloc extends Bloc<InfoGeneralEvent, InfoGeneralState> {
  InfoGeneralBloc() : super(InitialInfoGeneralState());

  final _anticorrosiveProtectionRepository =
      AnticorrosiveProtectionRepository();

  @override
  Stream<InfoGeneralState> mapEventToState(InfoGeneralEvent event) async* {
    if (event is GetInfoGeneral) {
      yield IsLoadingInfoGeneral();

      try {
        AnticorrosiveIPAModel anticorrosiveIPAModel =
            await _anticorrosiveProtectionRepository
                .selInfoGeneral(event.noRegistro);

        yield SuccessInfoGeneral(anticorrosiveIPAModel: anticorrosiveIPAModel);
      } catch (e) {
        yield ErrorInfoGeneral(errorMessage: e.toString());
      }
    }

    if (event is InsUpdInfoGeneral) {
      yield IsLoadingInfoGeneral();

      try {
        await _anticorrosiveProtectionRepository.insUpdInfoGeneral(
            event.noRegistro, event.anticorrosiveIPAModel);

        yield SuccessInsUpdInfoGeneral();
      } catch (e) {
        yield ErrorInfoGeneral(errorMessage: e.toString());
      }
    }
  }
}
