import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/front_dropdown_model.dart';

@immutable
abstract class DropDownFrontState {
  final List<FrontDropdownModel> fronts;
  final String message;

  DropDownFrontState({this.fronts, this.message});
}

class InitialDropDownFrontState extends DropDownFrontState {}

class IsLoadingFront extends DropDownFrontState {}

class ErrorFront extends DropDownFrontState {
  ErrorFront({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessFront extends DropDownFrontState {
  SuccessFront({@required List<FrontDropdownModel> fronts})
      : super(fronts: fronts);
}
