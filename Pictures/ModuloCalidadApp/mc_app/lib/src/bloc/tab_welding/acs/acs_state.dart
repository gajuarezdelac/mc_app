import 'package:flutter/material.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';

@immutable
abstract class ACSState {
  final List<AcceptanceCriteriaWeldingModel> listACS;
  final String message;

  ACSState({this.listACS, this.message});
}

class InitialACState extends ACSState {}

// Soldadura
class IsLoadingACS extends ACSState {}

class ErrorACS extends ACSState {
  ErrorACS({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessACS extends ACSState {
  SuccessACS({@required List<AcceptanceCriteriaWeldingModel> listACS})
      : super(listACS: listACS);
}
