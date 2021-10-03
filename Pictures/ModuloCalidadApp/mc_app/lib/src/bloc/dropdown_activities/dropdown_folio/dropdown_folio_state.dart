import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownFolioState {
  final List<FolioDropdownModel> folioModel;
  final String message;

  DropDownFolioState({
    this.folioModel,
    this.message,
  });
}

class InitialDropDownFolioState extends DropDownFolioState {}

class IsLoadingFolio extends DropDownFolioState {}

class ErrorFolio extends DropDownFolioState {
  ErrorFolio({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessFolio extends DropDownFolioState {
  SuccessFolio({@required List<FolioDropdownModel> folioModel})
      : super(folioModel: folioModel);
}
