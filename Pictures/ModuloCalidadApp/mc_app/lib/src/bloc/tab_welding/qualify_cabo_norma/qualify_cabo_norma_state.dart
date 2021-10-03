import 'package:flutter/material.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/qualify_norm_model.dart';
import 'package:mc_app/src/models/requireChangeMaterial.dart';
import 'package:mc_app/src/models/user_off_model.dart';

@immutable
abstract class QualifyCaboNormState {
  // Params
  final String messageError;
  final int rowsAffected;
  final QAWeldingUserModel qaWeldingUserModel;
  final String folioSoldadura;
  final QualifyNormModel qualifyNormModel;
  final RequireChangeMaterialResponse requireChangeMaterialResponse;
  final List<AcceptanceCriteriaWeldingModel> listACS;

  QualifyCaboNormState(
      {this.messageError,
      this.rowsAffected,
      this.qaWeldingUserModel,
      this.qualifyNormModel,
      this.folioSoldadura,
      this.requireChangeMaterialResponse,
      this.listACS});
}

class InitialQualifyCaboNormState extends QualifyCaboNormState {}

// Se califica dentro y fuera de norma.

class IsLoadingQualifyNorm extends QualifyCaboNormState {}

class ErrorQualifyNorma extends QualifyCaboNormState {
  ErrorQualifyNorma({@required String errorMessage})
      : super(messageError: errorMessage);
}

class SuccessQualifyNorma extends QualifyCaboNormState {
  SuccessQualifyNorma({@required QualifyNormModel qualifyNormModel})
      : super(qualifyNormModel: qualifyNormModel);
}

// Se requiere cambio de material

class IsloadingChangeMaterial extends QualifyCaboNormState {}

class ErrorChangeMaterial extends QualifyCaboNormState {
  ErrorChangeMaterial({@required String errorMessage})
      : super(messageError: errorMessage);
}

class SucessChangeMaterial extends QualifyCaboNormState {
  SucessChangeMaterial(
      {@required RequireChangeMaterialResponse requireChangeMaterialResponse})
      : super(requireChangeMaterialResponse: requireChangeMaterialResponse);
}

class IsLoadingGetQAUser extends QualifyCaboNormState {}

class ErrorGetQAUser extends QualifyCaboNormState {
  ErrorGetQAUser({@required String errorMessage})
      : super(messageError: errorMessage);
}

class SucessGetQAUser extends QualifyCaboNormState {
  SucessGetQAUser({@required QAWeldingUserModel qaWeldingUserModel})
      : super(qaWeldingUserModel: qaWeldingUserModel);
}
