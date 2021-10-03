import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/evidence_welder_card_params.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicWeldingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEvidencePhotographicWelding extends EvidencePhotographicWeldingEvent {
  final EvidenceWelderCardParams params;

  GetEvidencePhotographicWelding({this.params});

  @override
  List<Object> get props => [params];
}

class AddEvidencePhotographicWelding extends EvidencePhotographicWeldingEvent {
  final PhotographicEvidenceWeldingModel data;

  AddEvidencePhotographicWelding({this.data});

  @override
  List<Object> get props => [data];
}

class DeleteEvidencePhotographicWelding
    extends EvidencePhotographicWeldingEvent {
  final String id;

  DeleteEvidencePhotographicWelding({this.id});

  @override
  List<Object> get props => [id];
}
