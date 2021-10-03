import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/evidence_fn/evidence_fn_event.dart';
import 'package:mc_app/src/bloc/tab_welding/evidence_fn/evidence_fn_state.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/repository/photographic_evidence_repository.dart';

class EvidenceFNWeldingBloc
    extends Bloc<EvidenceFNWeldingEvent, EvidenceFNWeldingState> {
  EvidenceFNWeldingBloc() : super(InitialEvidenceFNWeldingState());

  final _evidencePhotographicRepository = PhotographicEvidenceRepository();

  @override
  Stream<EvidenceFNWeldingState> mapEventToState(
      EvidenceFNWeldingEvent event) async* {
    if (event is GetEvidenceFNWelding) {
      yield IsLoadingEvidenceFNWelding();

      try {
        List<PhotographicEvidenceWeldingModel> lstPhotographics =
            await _evidencePhotographicRepository.getAllPhotographicsWelding(
                params: event.params);

        yield SuccessGetEvidenceFNsWelding(lstPhotographics: lstPhotographics);
      } catch (e) {
        yield ErrorEvidenceFNWelding(errorMessage: e.toString());
      }
    }

    if (event is AddEvidenceFNWelding) {
      yield IsLoadingEvidenceFNWelding();

      try {
        await _evidencePhotographicRepository.addPhotographicsWelding(
            data: event.data);

        yield SuccessCreateEvidenceFNsWelding();
      } catch (e) {
        yield ErrorEvidenceFNWelding(errorMessage: e.toString());
      }
    }

    if (event is DeleteEvidenceFNWelding) {
      yield IsLoadingEvidenceFNWelding();

      try {
        await _evidencePhotographicRepository.deletePhotographicsWelding(
            id: event.id);

        yield SuccessDeleteEvidenceFNsWelding();
      } catch (e) {
        yield ErrorEvidenceFNWelding(errorMessage: e.toString());
      }
    }
  }
}
