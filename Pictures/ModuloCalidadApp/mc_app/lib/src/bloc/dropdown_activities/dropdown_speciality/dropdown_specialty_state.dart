import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownSpecialtyState {
  final List<EspecialidadModel> specialtyModel;
  final String message;

  DropDownSpecialtyState({
    this.specialtyModel,
    this.message,
  });
}

class InitialDropDownspecialtyState extends DropDownSpecialtyState {}

class IsLoadingSpecialty extends DropDownSpecialtyState {}

class ErrorSpecialty extends DropDownSpecialtyState {
  ErrorSpecialty({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessSpecialty extends DropDownSpecialtyState {
  SuccessSpecialty({@required List<EspecialidadModel> specialtyModel})
      : super(specialtyModel: specialtyModel);
}
