import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';

@immutable
abstract class RptAntiCorrosiveProtectionState {
  final String errorMessage;
  final RptAPModel rptAPModel;

  RptAntiCorrosiveProtectionState({this.errorMessage, this.rptAPModel});
}

class InitialGetRptAPState extends RptAntiCorrosiveProtectionState {}

class IsLoadingGetRptAP extends RptAntiCorrosiveProtectionState {}

class ErrorGetRptAP extends RptAntiCorrosiveProtectionState {
  ErrorGetRptAP({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetRptAP extends RptAntiCorrosiveProtectionState {
  SuccessGetRptAP({@required RptAPModel rptAPModel})
      : super(rptAPModel: rptAPModel);
}
