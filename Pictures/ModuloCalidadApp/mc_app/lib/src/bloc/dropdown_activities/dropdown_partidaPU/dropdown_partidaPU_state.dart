import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownPartidaPUState {
  final List<PartidaPUModel> partidaPU;
  final String message;

  DropDownPartidaPUState({
    this.partidaPU,
    this.message,
  });
}

class InitialDropDownPartidaPUState extends DropDownPartidaPUState {}

class IsLoadingPartidaPU extends DropDownPartidaPUState {}

class ErrorPartidaPU extends DropDownPartidaPUState {
  ErrorPartidaPU({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessPartidaPU extends DropDownPartidaPUState {
  SuccessPartidaPU({@required List<PartidaPUModel> partidaPU})
      : super(partidaPU: partidaPU);
}
