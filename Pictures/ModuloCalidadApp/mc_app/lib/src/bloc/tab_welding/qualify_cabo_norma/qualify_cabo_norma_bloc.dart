import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/tab_welding/qualify_cabo_norma/qualify_cabo_norma_event.dart';
import 'package:mc_app/src/bloc/tab_welding/qualify_cabo_norma/qualify_cabo_norma_state.dart';
import 'package:mc_app/src/models/qualify_norm_model.dart';
import 'package:mc_app/src/models/requireChangeMaterial.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/repository/welding_tab_repository.dart';

class QualifyCaboNormBloc
    extends Bloc<QualifyCaboNormEvent, QualifyCaboNormState> {
  QualifyCaboNormBloc() : super(InitialQualifyCaboNormState());

  final _qualifyRegisterRepository = WeldingTabRepository();

  @override
  Stream<QualifyCaboNormState> mapEventToState(
      QualifyCaboNormEvent event) async* {
    // Realizamos la carga inicial del panel
    if (event is QualifyCaboNorm) {
      yield IsLoadingQualifyNorm();

      try {
        QualifyNormModel qualifyNormModel =
            await _qualifyRegisterRepository.qualifyCaboNorm(
                folioSoldadura: event.folioSoldadura,
                inspectorCCAId: event.inspectorCCAId,
                norma: event.norma,
                motivoFN: event.motivoFN,
                juntaId: event.juntaId,
                listACS: event.listACS,
                nombreTabla: event.nombreTabla);
        yield SuccessQualifyNorma(qualifyNormModel: qualifyNormModel);
      } catch (e) {
        yield ErrorQualifyNorma(errorMessage: e.toString());
      }
    }

    if (event is ChangeMaterial) {
      yield IsloadingChangeMaterial();

      try {
        RequireChangeMaterialResponse requireChangeMaterialResponse =
            await _qualifyRegisterRepository.changeMaterial(
                params: event.params);
        yield SucessChangeMaterial(
            requireChangeMaterialResponse: requireChangeMaterialResponse);
      } catch (e) {
        yield ErrorChangeMaterial(errorMessage: e.toString());
      }
    }

    if (event is GetQAUser) {
      yield IsLoadingGetQAUser();
      try {
        QAWeldingUserModel qaWeldingUserModel =
            await _qualifyRegisterRepository.fetchQAUser(ficha: event.ficha);
        yield SucessGetQAUser(qaWeldingUserModel: qaWeldingUserModel);
      } catch (e) {
        yield ErrorGetQAUser(errorMessage: e.toString());
      }
    }
  }
}
