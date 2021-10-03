import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownAnexoState {
  final List<AnexoModel> anexo;
  final String selectedAnexo;
  final String message;

  DropDownAnexoState({
    this.anexo,
    this.selectedAnexo,
    this.message,
  });
}

class InitialDropDownAnexoState extends DropDownAnexoState {}

class IsLoadingAnexo extends DropDownAnexoState {}

class ErrorAnexo extends DropDownAnexoState {
  ErrorAnexo({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessAnexo extends DropDownAnexoState {
  SuccessAnexo({@required List<AnexoModel> anexo}) : super(anexo: anexo);
}
