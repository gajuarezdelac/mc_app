import 'package:flutter/material.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';

abstract class MaterialStagesDIPAState {
  List<MaterialStagesDIPAModel> data;

  final String message;

  MaterialStagesDIPAState({this.data, this.message});
}

class InitialMaterialStagesDIPAState extends MaterialStagesDIPAState {}

class IsLoadingMaterialStagesDIPA extends MaterialStagesDIPAState {}

class ErrorMaterialStagesDIPAState extends MaterialStagesDIPAState {
  ErrorMaterialStagesDIPAState({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessGetMaterialStagesDIPA extends MaterialStagesDIPAState {
  SuccessGetMaterialStagesDIPA({@required List<MaterialStagesDIPAModel> data})
  : super(data: data);
}

class SuccessInsUpdMaterialStagesDIPA extends MaterialStagesDIPAState {}