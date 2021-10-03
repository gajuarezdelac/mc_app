import 'package:flutter/material.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicWeldingState {
  final String errorMessage;
  final List<PhotographicEvidenceWeldingModel> lstPhotographics;

  EvidencePhotographicWeldingState({
    this.errorMessage,
    this.lstPhotographics,
  });
}

class InitialEvidencePhotographicWeldingState
    extends EvidencePhotographicWeldingState {}

class IsLoadingEvidencePhotographicWelding
    extends EvidencePhotographicWeldingState {}

class ErrorEvidencePhotographicWelding
    extends EvidencePhotographicWeldingState {
  ErrorEvidencePhotographicWelding({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetEvidencePhotographicsWelding
    extends EvidencePhotographicWeldingState {
  SuccessGetEvidencePhotographicsWelding(
      {@required List<PhotographicEvidenceWeldingModel> lstPhotographics})
      : super(lstPhotographics: lstPhotographics);
}

class SuccessCreateEvidencePhotographicsWelding
    extends EvidencePhotographicWeldingState {}

class SuccessDeleteEvidencePhotographicsWelding
    extends EvidencePhotographicWeldingState {}
