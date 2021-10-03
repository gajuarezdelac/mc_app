import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/repository/photographic_evidence_repository.dart';

import 'evidence_photographic_event.dart';
import 'evidence_photographic_state.dart';

class EvidencePhotographicBloc
    extends Bloc<EvidencePhotographicEvent, EvidencePhotographicState> {
  EvidencePhotographicBloc() : super(InitialEvidencePhotographicState());

  final _evidencePhotographicRepository = PhotographicEvidenceRepository();

  @override
  Stream<EvidencePhotographicState> mapEventToState(
      EvidencePhotographicEvent event) async* {
    if (event is GetEvidencePhotographic) {
      yield IsLoadingEvidencePhotographic();

      try {
        List<PhotographicEvidenceModel> lstPhotographics =
            await _evidencePhotographicRepository.getAllPhotographics(
                params: event.params);

        yield SuccessGetEvidencePhotographics(
            lstPhotographics: lstPhotographics);
      } catch (e) {
        yield ErrorEvidencePhotographic(errorMessage: e.toString());
      }
    }

    if (event is AddEvidencePhotographic) {
      yield IsLoadingEvidencePhotographic();

      try {
        await _evidencePhotographicRepository.addPhotographics(
            data: event.data);

        yield SuccessCreateEvidencePhotographics();
      } catch (e) {
        yield ErrorEvidencePhotographic(errorMessage: e.toString());
      }
    }

    if (event is DeleteEvidencePhotographic) {
      yield IsLoadingEvidencePhotographic();

      try {
        await _evidencePhotographicRepository.deletePhotographics(id: event.id);

        yield SuccessDeleteEvidencePhotographics();
      } catch (e) {
        yield ErrorEvidencePhotographic(errorMessage: e.toString());
      }
    }

    if (event is GetEvidencePhotographicV2) {
      yield IsLoadingEvidencePhotographic();

      try {
        List<PhotographicEvidenceModel> lstPhotographics =
            await _evidencePhotographicRepository.getAllPhotographicsV2(
                params: event.params);

        yield SuccessGetEvidencePhotographicsV2(
            lstPhotographics: lstPhotographics);
      } catch (e) {
        yield ErrorEvidencePhotographic(errorMessage: e.toString());
      }
    }

    if (event is InsUpdEvidencePhotographicV2) {
      yield IsLoadingEvidencePhotographic();

      try {
        List<UpdateIdModel> list =
            await _evidencePhotographicRepository.insUpdPhotographicsV2(
                params: event.params,
                identificadorComun: event.identificadorComun,
                tablaComun: event.tablaComun);

        yield SuccessInsUpdEvidencePhotographicsV2(list: list);
      } catch (e) {
        yield ErrorEvidencePhotographic(errorMessage: e.toString());
      }
    }
  }
}
