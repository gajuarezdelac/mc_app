import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetEvidencePhotographic extends EvidencePhotographicEvent {
  final PhotographicEvidenceParamsModel params;

  GetEvidencePhotographic({this.params});

  @override
  List<Object> get props => [params];
}

class GetEvidencePhotographicV2 extends EvidencePhotographicEvent {
  final PhotographicEvidenceParamsModel params;

  GetEvidencePhotographicV2({this.params});

  @override
  List<Object> get props => [params];
}

class AddEvidencePhotographic extends EvidencePhotographicEvent {
  final PhotographicEvidenceModel data;

  AddEvidencePhotographic({this.data});

  @override
  List<Object> get props => [data];
}

class DeleteEvidencePhotographic extends EvidencePhotographicEvent {
  final String id;

  DeleteEvidencePhotographic({this.id});

  @override
  List<Object> get props => [id];
}

class InsUpdEvidencePhotographicV2 extends EvidencePhotographicEvent {
  final List<PhotographicEvidenceModel> params;
  final String identificadorComun;
  final String tablaComun;

  InsUpdEvidencePhotographicV2({this.params, this.identificadorComun, this.tablaComun});

  @override
  List<Object> get props => [params, identificadorComun, tablaComun];
}