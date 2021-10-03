import 'package:flutter/material.dart';
import 'package:mc_app/src/models/coating_system_model.dart';

@immutable
abstract class CoatingSystemState {
  final List<CoatingSystemModel> data;
  final String message;

  CoatingSystemState({this.data, this.message});
}

class InitialCoatingSystemState extends CoatingSystemState {}

class IsLoadingCoatingSystem extends CoatingSystemState {}

class ErrorCoatingSystem extends CoatingSystemState {
  ErrorCoatingSystem({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessCoatingSystem extends CoatingSystemState {
  SuccessCoatingSystem({@required List<CoatingSystemModel> data})
  : super(data: data);
}