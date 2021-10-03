import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/evidence_photographic_welding/evidence_photographic_welding_event.dart';
import 'package:mc_app/src/bloc/tab_welding/evidence_photographic_welding/evidence_photographic_welding_state.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/repository/photographic_evidence_repository.dart';

class EvidencePhotographicWeldingBloc extends Bloc<
    EvidencePhotographicWeldingEvent, EvidencePhotographicWeldingState> {
  EvidencePhotographicWeldingBloc()
      : super(InitialEvidencePhotographicWeldingState());

  final _evidencePhotographicRepository = PhotographicEvidenceRepository();

  @override
  Stream<EvidencePhotographicWeldingState> mapEventToState(
      EvidencePhotographicWeldingEvent event) async* {
    if (event is GetEvidencePhotographicWelding) {
      yield IsLoadingEvidencePhotographicWelding();

      try {
        List<PhotographicEvidenceWeldingModel> lstPhotographics =
            await _evidencePhotographicRepository.getAllEvidenceWelders(
                params: event.params);

        yield SuccessGetEvidencePhotographicsWelding(
            lstPhotographics: lstPhotographics);
      } catch (e) {
        yield ErrorEvidencePhotographicWelding(errorMessage: e.toString());
      }
    }

    if (event is AddEvidencePhotographicWelding) {
      yield IsLoadingEvidencePhotographicWelding();

      try {
        await _evidencePhotographicRepository.addPhotographicsWelding(
            data: event.data);

        yield SuccessCreateEvidencePhotographicsWelding();
      } catch (e) {
        yield ErrorEvidencePhotographicWelding(errorMessage: e.toString());
      }
    }

    if (event is DeleteEvidencePhotographicWelding) {
      yield IsLoadingEvidencePhotographicWelding();

      try {
        await _evidencePhotographicRepository.deletePhotographicsWelding(
            id: event.id);

        yield SuccessDeleteEvidencePhotographicsWelding();
      } catch (e) {
        yield ErrorEvidencePhotographicWelding(errorMessage: e.toString());
      }
    }
  }
}
