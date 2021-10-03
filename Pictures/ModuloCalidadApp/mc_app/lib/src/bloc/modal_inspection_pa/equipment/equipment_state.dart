
import 'package:flutter/material.dart';
import 'package:mc_app/src/models/equipment_model.dart';

@immutable
abstract class EquipmentState {
  final List<EquipmentModel> data;
  final String message;

  EquipmentState({this.data, this.message});
}

class InitialEquipmentState extends EquipmentState {}

class IsLoadingEquipment extends EquipmentState {}

class ErrorEquipment extends EquipmentState {
  ErrorEquipment({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessEquipment extends EquipmentState {
  SuccessEquipment({@required List<EquipmentModel> data})
  : super(data: data);
}

class SuccessInsUpdEquipment extends EquipmentState {}