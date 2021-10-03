import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';

@immutable
abstract class RptNonCompliantOutputState {
  final String errorMessage;
  final RptNonCompliantOutputModel rptNonCompliantOutput;

  RptNonCompliantOutputState({this.errorMessage, this.rptNonCompliantOutput});
}

class InitialRptNonCompliantOutputState extends RptNonCompliantOutputState {}

class IsLoadingRptNonCompliantOutput extends RptNonCompliantOutputState {}

class ErrorRptNonCompliantOutput extends RptNonCompliantOutputState {
  ErrorRptNonCompliantOutput({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetRptNonCompliantOutput extends RptNonCompliantOutputState {
  SuccessGetRptNonCompliantOutput(
      {@required RptNonCompliantOutputModel rptNonCompliantOutput})
      : super(rptNonCompliantOutput: rptNonCompliantOutput);
}
