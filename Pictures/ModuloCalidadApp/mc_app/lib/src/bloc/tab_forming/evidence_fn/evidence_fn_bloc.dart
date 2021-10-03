import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/evidence_fn/evidence_fn_event.dart';
import 'package:mc_app/src/bloc/tab_forming/evidence_fn/evidence_fn_state.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/repository/photographic_evidence_repository.dart';

class EvidenceFNBloc extends Bloc<EvidenceFNEvent, EvidenceFNState> {
  EvidenceFNBloc() : super(InitialEvidenceFNState());

  final _evidenceFNRepository = PhotographicEvidenceRepository();

  @override
  Stream<EvidenceFNState> mapEventToState(EvidenceFNEvent event) async* {
    if (event is GetEvidenceFN) {
      yield IsLoadingEvidenceFN();

      try {
        List<PhotographicEvidenceModel> pics = [];

        if(event.load){
         pics = await _evidenceFNRepository
            .getAllPhotographics(params: event.params);
        }

        event.temporales.forEach((elem) {
             pics.add(new PhotographicEvidenceModel(fotoId: elem.fotoId, content: elem.content, contentType: elem.contentType, nombre: elem.nombre, nombreTabla: elem.nombreTabla, identificadorTabla: elem.identificadorTabla, siteModificacion: elem.siteModificacion,regBorrado: elem.regBorrado, thumbnail: elem.thumbnail,fechaModificacion: elem.fechaModificacion));
         });

        yield SuccessGetEvidenceFNs(pics: pics);
      } catch (e) {
        yield ErrorEvidenceFN(error: e.toString());
      }
    }

    if (event is AddAllEvidenceAFN) {
      yield IsLoadingEvidenceFN();

      try {
        await _evidenceFNRepository.addAllPhotographics(data: event.data, delete: event.deletePhoto);

        yield SuccessCreateAllEvidenceFNs();
      } catch (e) {
        yield ErrorEvidenceFN(error: e.toString());
      }
    }

    if (event is DeleteEvidenceFN) {
      yield IsLoadingEvidenceFN();

      try {
        await _evidenceFNRepository.deletePhotographics(id: event.id);

        yield SuccessDeleteEvidenceFNs();
      } catch (e) {
        yield ErrorEvidenceFN(error: e.toString());
      }
    }

    //Temporal
      if (event is AddEvidenceFNTemporal) {
      yield IsLoadingEvidenceFN();

      try {
        // await _evidenceFNRepository.addPhotographics(data: event.data);

        yield SuccessCreateEvidenceTemporalFNs(data: event.data, picsTemporales: event.temporales);
      } catch (e) {
        yield ErrorEvidenceFN(error: e.toString());
      }
    }
  }
}
