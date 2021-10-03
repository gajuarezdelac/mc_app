import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidenceFNEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetEvidenceFN extends EvidenceFNEvent {
  final List<PhotographicEvidenceModel> temporales;
  final PhotographicEvidenceParamsModel params;
  final bool load;

  GetEvidenceFN({this.params, this.temporales, this.load});

  @override
  List<Object> get props => [params];
}

class AddAllEvidenceAFN extends EvidenceFNEvent {
  final List<PhotographicEvidenceModel> data;
  final List<PhotographicEvidenceModel> deletePhoto;

  AddAllEvidenceAFN({this.data, this.deletePhoto});

  @override
  List<Object> get props => [data];
}

class DeleteEvidenceFN extends EvidenceFNEvent {
  final String id;

  DeleteEvidenceFN({this.id});

  @override
  List<Object> get props => [id];
}


//Temporal 
class AddEvidenceFNTemporal extends EvidenceFNEvent {
  final PhotographicEvidenceModel data;
  final List<PhotographicEvidenceModel> temporales;

  AddEvidenceFNTemporal({this.data, this.temporales});

  @override
  List<Object> get props => [data];
}
