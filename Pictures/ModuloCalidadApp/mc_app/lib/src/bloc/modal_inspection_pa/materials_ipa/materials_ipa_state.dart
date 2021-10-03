import 'package:flutter/material.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';

abstract class MaterialsIPAState {
  List<MaterialsTableIPAModel> data;
  final String message;

  MaterialsIPAState({this.data, this.message});
}

class InitialMaterialsIPAState extends MaterialsIPAState {}

class IsLoadingMaterialsIPA extends MaterialsIPAState {}

class ErrorMaterialsIPAState extends MaterialsIPAState {
  ErrorMaterialsIPAState({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessGetMaterialsIPA extends MaterialsIPAState {
  SuccessGetMaterialsIPA({@required List<MaterialsTableIPAModel> data})
  : super(data: data);
}

class SuccessInsUpdMaterialsIPA extends MaterialsIPAState {}