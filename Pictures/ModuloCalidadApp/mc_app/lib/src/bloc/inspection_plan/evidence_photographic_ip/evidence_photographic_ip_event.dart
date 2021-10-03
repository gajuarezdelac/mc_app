import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicIPvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetEvidenceFNOrDN extends EvidencePhotographicIPvent {
  final List<PhotographicEvidenceIPModel> temporales;
  final PhotographicEvidenceIPParamsModel params;
  final bool load;

  GetEvidenceFNOrDN({this.params, this.temporales, this.load});

  @override
  List<Object> get props => [params];
}

class AddAllEvidenceAFNOrDN extends EvidencePhotographicIPvent {
  final List<PhotographicEvidenceIPModel> data;
  final List<PhotographicEvidenceIPModel> deletePhoto;

  AddAllEvidenceAFNOrDN({this.data, this.deletePhoto});

  @override
  List<Object> get props => [data];
}

class DeleteEvidenceFNOrDN extends EvidencePhotographicIPvent {
  final String id;

  DeleteEvidenceFNOrDN({this.id});

  @override
  List<Object> get props => [id];
}

//Temporal
class AddEvidenceFNOrDNTemporal extends EvidencePhotographicIPvent {
  final PhotographicEvidenceIPModel data;
  final List<PhotographicEvidenceIPModel> temporales;

  AddEvidenceFNOrDNTemporal({this.data, this.temporales});

  @override
  List<Object> get props => [data];
}
