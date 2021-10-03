import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

@immutable
abstract class EvidencePhotographicIPState {
  final String error;
  final List<PhotographicEvidenceIPModel> pics;

  EvidencePhotographicIPState({this.error, this.pics});
}

class InitialEvidenceFNOrDNState extends EvidencePhotographicIPState {}

class IsLoadingEvidenceFNOrDN extends EvidencePhotographicIPState {}

class ErrorEvidenceFNOrDN extends EvidencePhotographicIPState {
  ErrorEvidenceFNOrDN({@required String error}) : super(error: error);
}

class SuccessGetEvidenceFNsOrDNs extends EvidencePhotographicIPState {
  SuccessGetEvidenceFNsOrDNs({@required List<PhotographicEvidenceIPModel> pics})
      : super(pics: pics);
}

class SuccessCreateAllEvidenceFNsOrDNs extends EvidencePhotographicIPState {}

class SuccessDeleteEvidenceFNsOrDNs extends EvidencePhotographicIPState {}

//Temporal
class SuccessCreateEvidenceTemporalFNsOrDNs
    extends EvidencePhotographicIPState {
  final PhotographicEvidenceIPModel data;
  final List<PhotographicEvidenceIPModel> picsTemporales;

  SuccessCreateEvidenceTemporalFNsOrDNs(
      {@required this.data, @required this.picsTemporales});
}
