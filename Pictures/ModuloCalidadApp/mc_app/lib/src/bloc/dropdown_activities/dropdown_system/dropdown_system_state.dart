import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownSystemState {
  final List<SistemaModel> systemModel;
  final String message;

  DropDownSystemState({
    this.systemModel,
    this.message,
  });
}

class InitialDropDownSystemState extends DropDownSystemState {}

class IsLoadingSystem extends DropDownSystemState {}

class ErrorSystem extends DropDownSystemState {
  ErrorSystem({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessSystem extends DropDownSystemState {
  SuccessSystem({@required List<SistemaModel> systemModel})
      : super(systemModel: systemModel);
}
