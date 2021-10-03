import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';

@immutable
abstract class RptMaterialsCorrosionState {
  final String errorMessage;
  final RptMaterialsCorrosionHeader materials;

  RptMaterialsCorrosionState({this.errorMessage, this.materials});
}

class InitialRptMaterialsCorrosionState extends RptMaterialsCorrosionState {}

class IsLoadingRptMaterialsCorrosion extends RptMaterialsCorrosionState {}

class ErrorRptMaterialsCorrosion extends RptMaterialsCorrosionState {
  ErrorRptMaterialsCorrosion({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetRptMaterialsCorrosion extends RptMaterialsCorrosionState {
  SuccessGetRptMaterialsCorrosion(
      {@required RptMaterialsCorrosionHeader materials})
      : super(materials: materials);
}
