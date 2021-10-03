import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidenceFNWeldingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEvidenceFNWelding extends EvidenceFNWeldingEvent {
  final PhotographicEvidenceWeldingParamsModel params;

  GetEvidenceFNWelding({this.params});

  @override
  List<Object> get props => [params];
}

class AddEvidenceFNWelding extends EvidenceFNWeldingEvent {
  final PhotographicEvidenceWeldingModel data;

  AddEvidenceFNWelding({this.data});

  @override
  List<Object> get props => [data];
}

class DeleteEvidenceFNWelding extends EvidenceFNWeldingEvent {
  final String id;

  DeleteEvidenceFNWelding({this.id});

  @override
  List<Object> get props => [id];
}
