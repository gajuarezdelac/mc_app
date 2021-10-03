import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/pipefitter_model.dart';

@immutable
abstract class PipefitterState {
  final String error;
  final List<PipefitterModel> pipefitters;

  PipefitterState({this.error, this.pipefitters});
}

class InitialPipefittersState extends PipefitterState {}

// Estados para obtener los tuberos del conformado
class IsLoadingPipefitters extends PipefitterState {}

class ErrorPipefitters extends PipefitterState {
  ErrorPipefitters({@required String error}) : super(error: error);
}

class SuccessPipefitters extends PipefitterState {
  SuccessPipefitters({@required List<PipefitterModel> pipefitters})
      : super(pipefitters: pipefitters);
}
