import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/environmental_conditions_params.dart';

@immutable
abstract class EnvironmentalConditionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEnvironmentalConditions extends EnvironmentalConditionsEvent {
  final String noRegistro;

  GetEnvironmentalConditions({this.noRegistro});

  List<Object> get props => [noRegistro];
}

class InsUpdEnvironmentalConditions extends EnvironmentalConditionsEvent {
  final String noRegistro;
  final List<EnvironmentalConditionsParams> param;

  InsUpdEnvironmentalConditions({this.noRegistro, this.param});

  List<Object> get props => [noRegistro, param];
}