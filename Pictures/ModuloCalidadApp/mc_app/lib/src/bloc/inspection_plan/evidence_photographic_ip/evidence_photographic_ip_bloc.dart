import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/evidence_photographic_ip/evidence_photographic_ip_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/evidence_photographic_ip/evidence_photographic_ip_state.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/repository/photographic_evidence_repository.dart';

class EvidencePhotographicIPBloc
    extends Bloc<EvidencePhotographicIPvent, EvidencePhotographicIPState> {
  EvidencePhotographicIPBloc() : super(InitialEvidenceFNOrDNState());

  final _evidenceFNRepository = PhotographicEvidenceRepository();

  @override
  Stream<EvidencePhotographicIPState> mapEventToState(
      EvidencePhotographicIPvent event) async* {
    if (event is GetEvidenceFNOrDN) {
      yield IsLoadingEvidenceFNOrDN();

      try {
        List<PhotographicEvidenceIPModel> pics = [];

        if (event.load) {
          pics = await _evidenceFNRepository.getAllPhotographicsIP(
              params: event.params);
        }

        event.temporales.forEach((elem) {
          pics.add(new PhotographicEvidenceIPModel(
              fotoId: elem.fotoId,
              content: elem.content,
              contentType: elem.contentType,
              nombre: elem.nombre,
              nombreTabla: elem.nombreTabla,
              identificadorTabla: elem.identificadorTabla,
              siteModificacion: elem.siteModificacion,
              regBorrado: elem.regBorrado,
              thumbnail: elem.thumbnail,
              fechaModificacion: elem.fechaModificacion));
        });

        yield SuccessGetEvidenceFNsOrDNs(pics: pics);
      } catch (e) {
        yield ErrorEvidenceFNOrDN(error: e.toString());
      }
    }

    if (event is AddAllEvidenceAFNOrDN) {
      yield IsLoadingEvidenceFNOrDN();

      try {
        await _evidenceFNRepository.addAllPhotographicsIP(
            data: event.data, delete: event.deletePhoto);

        yield SuccessCreateAllEvidenceFNsOrDNs();
      } catch (e) {
        yield ErrorEvidenceFNOrDN(error: e.toString());
      }
    }

    if (event is DeleteEvidenceFNOrDN) {
      yield IsLoadingEvidenceFNOrDN();

      try {
        await _evidenceFNRepository.deletePhotographics(id: event.id);

        yield SuccessDeleteEvidenceFNsOrDNs();
      } catch (e) {
        yield ErrorEvidenceFNOrDN(error: e.toString());
      }
    }

    //Temporal
    if (event is AddEvidenceFNOrDNTemporal) {
      yield IsLoadingEvidenceFNOrDN();

      try {
        // await _evidenceFNRepository.addPhotographics(data: event.data);

        yield SuccessCreateEvidenceTemporalFNsOrDNs(
            data: event.data, picsTemporales: event.temporales);
      } catch (e) {
        yield ErrorEvidenceFNOrDN(error: e.toString());
      }
    }
  }
}
