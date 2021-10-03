import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicState {
  final String errorMessage;
  final List<PhotographicEvidenceModel> lstPhotographics;
  final List<PhotographicEvidenceModel> lstPhotographicsV2;
  final List<UpdateIdModel> updateIds;

  EvidencePhotographicState({this.errorMessage, this.lstPhotographics, this.lstPhotographicsV2, this.updateIds});
}

class InitialEvidencePhotographicState extends EvidencePhotographicState {}

class IsLoadingEvidencePhotographic extends EvidencePhotographicState {}

class ErrorEvidencePhotographic extends EvidencePhotographicState {
  ErrorEvidencePhotographic({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetEvidencePhotographics extends EvidencePhotographicState {
  SuccessGetEvidencePhotographics(
      {@required List<PhotographicEvidenceModel> lstPhotographics})
      : super(lstPhotographics: lstPhotographics);
}

class SuccessCreateEvidencePhotographics extends EvidencePhotographicState {}

class SuccessDeleteEvidencePhotographics extends EvidencePhotographicState {}

class SuccessGetEvidencePhotographicsV2 extends EvidencePhotographicState {
  SuccessGetEvidencePhotographicsV2(
    {@required List<PhotographicEvidenceModel> lstPhotographics})
    : super (lstPhotographicsV2: lstPhotographics);
}

class SuccessInsUpdEvidencePhotographicsV2 extends EvidencePhotographicState {
  SuccessInsUpdEvidencePhotographicsV2(
    {@required List<UpdateIdModel> list})
    : super (updateIds: list);
}
