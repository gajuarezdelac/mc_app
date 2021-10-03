import 'package:flutter/material.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidenceFNWeldingState {
  final String errorMessage;
  final List<PhotographicEvidenceWeldingModel> lstPhotographics;

  EvidenceFNWeldingState({
    this.errorMessage,
    this.lstPhotographics,
  });
}

class InitialEvidenceFNWeldingState extends EvidenceFNWeldingState {}

class IsLoadingEvidenceFNWelding extends EvidenceFNWeldingState {}

class ErrorEvidenceFNWelding extends EvidenceFNWeldingState {
  ErrorEvidenceFNWelding({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetEvidenceFNsWelding extends EvidenceFNWeldingState {
  SuccessGetEvidenceFNsWelding(
      {@required List<PhotographicEvidenceWeldingModel> lstPhotographics})
      : super(lstPhotographics: lstPhotographics);
}

class SuccessCreateEvidenceFNsWelding extends EvidenceFNWeldingState {}

class SuccessDeleteEvidenceFNsWelding extends EvidenceFNWeldingState {}
