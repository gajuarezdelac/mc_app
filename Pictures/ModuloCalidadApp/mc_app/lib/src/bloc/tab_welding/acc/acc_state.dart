import 'package:flutter/material.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';

@immutable
abstract class ACCState {
  final List<AcceptanceCriteriaconformadoModel> listACC;
  final String message;

  ACCState({this.listACC, this.message});
}

class InitialACCtate extends ACCState {}

// Conformado
class IsLoadingACC extends ACCState {}

class ErrorACC extends ACCState {
  ErrorACC({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessACC extends ACCState {
  SuccessACC({@required List<AcceptanceCriteriaconformadoModel> listACC})
      : super(listACC: listACC);
}
