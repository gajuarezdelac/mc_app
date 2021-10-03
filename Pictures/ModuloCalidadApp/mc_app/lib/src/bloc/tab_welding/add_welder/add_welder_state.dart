import 'package:equatable/equatable.dart';
import 'package:mc_app/src/models/empleado_soldador_not_valid_model.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';

@immutable
abstract class AddWelderState extends Equatable {
  final EmpleadoSoldadorNotValidModel addwelderModel;
  final EmpleadoSoldadorNotValidModel empleadoSoldadorNotValidModel;
  final AddWelderModelResponse addWelderModelResponse;

  final String message;

  AddWelderState(
      {this.addwelderModel,
      this.message,
      this.empleadoSoldadorNotValidModel,
      this.addWelderModelResponse});

  @override
  List<Object> get props => [];
}

class InitialAddWelderState extends AddWelderState {}

// Eventos para agregar un soldador con WPS valido
class IsLoadingAddWelderWPSValid extends AddWelderState {}

class ErrorAddWelderWPSValid extends AddWelderState {
  ErrorAddWelderWPSValid({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessAddWelderWPSValid extends AddWelderState {
  SuccessAddWelderWPSValid(
      {@required AddWelderModelResponse addWelderModelResponse})
      : super(addWelderModelResponse: addWelderModelResponse);
}

// Eventos para agregar un soldador con WPS no valido

class IsLoadingAddWelderWPSNotValid extends AddWelderState {}

class ErrorAddWeldingWPSNotValid extends AddWelderState {
  ErrorAddWeldingWPSNotValid({@required String errorMessage})
      : super(message: errorMessage);
}

class SucessAddWeldingWPSNotValid extends AddWelderState {
  SucessAddWeldingWPSNotValid(
      {@required EmpleadoSoldadorNotValidModel empleadoSoldadorNotValidModel})
      : super(empleadoSoldadorNotValidModel: empleadoSoldadorNotValidModel);
}
