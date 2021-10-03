import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidenceFNState {
  final String error;
  final List<PhotographicEvidenceModel> pics;

  EvidenceFNState({this.error, this.pics});
}

class InitialEvidenceFNState extends EvidenceFNState {}

class IsLoadingEvidenceFN extends EvidenceFNState {}

class ErrorEvidenceFN extends EvidenceFNState {
  ErrorEvidenceFN({@required String error}) : super(error: error);
}

class SuccessGetEvidenceFNs extends EvidenceFNState {
  SuccessGetEvidenceFNs({@required List<PhotographicEvidenceModel> pics})
      : super(pics: pics);
}

class SuccessCreateAllEvidenceFNs extends EvidenceFNState {}

class SuccessDeleteEvidenceFNs extends EvidenceFNState {}

//Temporal
class SuccessCreateEvidenceTemporalFNs extends EvidenceFNState {
  final PhotographicEvidenceModel data;
  final List<PhotographicEvidenceModel> picsTemporales;

  SuccessCreateEvidenceTemporalFNs({@required this.data, @required this.picsTemporales});
}
