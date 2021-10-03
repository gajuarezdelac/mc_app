import 'package:flutter/material.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';

@immutable
abstract class InfoGeneralState {
  final AnticorrosiveIPAModel anticorrosiveIPAModel;
  final String message;

  InfoGeneralState({this.anticorrosiveIPAModel, this.message});
}

class InitialInfoGeneralState extends InfoGeneralState {}

class IsLoadingInfoGeneral extends InfoGeneralState {}

class ErrorInfoGeneral extends InfoGeneralState {
  ErrorInfoGeneral({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessInfoGeneral extends InfoGeneralState {
  SuccessInfoGeneral({@required AnticorrosiveIPAModel anticorrosiveIPAModel})
  : super(anticorrosiveIPAModel: anticorrosiveIPAModel);
}

class SuccessInsUpdInfoGeneral extends InfoGeneralState {}