import 'package:mc_app/src/models/stage_materials_ipa_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class StageMaterialIPAState {
  final List<StageMaterialsIPAModel> data;
  final String message;

  StageMaterialIPAState({this.data, this.message});
}

class InitialStageMaterialIPAState extends StageMaterialIPAState {}

class IsLoadingStageMaterialIPA extends StageMaterialIPAState {}

class ErrorStageMaterialIPA extends StageMaterialIPAState {
  ErrorStageMaterialIPA({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessGetStageMaterialIPA extends StageMaterialIPAState {
  SuccessGetStageMaterialIPA({@required List<StageMaterialsIPAModel> data})
  : super(data: data);
}

class SuccessInsUpdStageMaterialIPA extends StageMaterialIPAState {}