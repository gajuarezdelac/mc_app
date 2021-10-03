import 'package:flutter/material.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';

@immutable
abstract class CoatingAplicationState {
  final List<CoatingAplicationModel> data;
  final String message;

  CoatingAplicationState({this.data, this.message});
}

class InitialCoatingAplicationState extends CoatingAplicationState {}

class IsLoadingCoatingAplication extends CoatingAplicationState {}

class ErrorCoatingAplication extends CoatingAplicationState {
  ErrorCoatingAplication({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessCoatingAplication extends CoatingAplicationState {
  SuccessCoatingAplication({@required List<CoatingAplicationModel> data})
  : super(data: data);
}

class SuccessInsUpdCoatingAplication extends CoatingAplicationState {}