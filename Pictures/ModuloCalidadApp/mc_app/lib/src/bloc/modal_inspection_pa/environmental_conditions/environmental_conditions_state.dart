import 'package:flutter/material.dart';
import 'package:mc_app/src/models/environmental_conditions_model.dart';

@immutable
abstract class EnvironmentalConditionsState {
  final List<EnvironmentalConditionsModel> data;
  final String message;

  EnvironmentalConditionsState({this.data, this.message});
}

class InitialEnvironmentalConditionsState extends EnvironmentalConditionsState {}

class IsLoadingEnvironmentalConditions extends EnvironmentalConditionsState {}

class ErrorEnvironmentalConditions extends EnvironmentalConditionsState {
  ErrorEnvironmentalConditions({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessGetEnvironmentalConditions extends EnvironmentalConditionsState {
  SuccessGetEnvironmentalConditions({@required List<EnvironmentalConditionsModel> data})
  : super(data: data);
}

class SuccessInsUpdEnvironmentalConditions extends EnvironmentalConditionsState {}