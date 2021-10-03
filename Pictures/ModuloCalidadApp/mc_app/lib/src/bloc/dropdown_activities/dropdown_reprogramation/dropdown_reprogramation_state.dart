import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownReprogramationState {
  final List<ReprogramacionModel> reprogramationModel;
  final String message;

  DropDownReprogramationState({
    this.reprogramationModel,
    this.message,
  });
}

class InitialDropDownReprogramationState extends DropDownReprogramationState {}

class IsLoadingReprogramacion extends DropDownReprogramationState {}

class ErrorReprogramation extends DropDownReprogramationState {
  ErrorReprogramation({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessReprogramation extends DropDownReprogramationState {
  SuccessReprogramation(
      {@required List<ReprogramacionModel> reprogramationModel})
      : super(reprogramationModel: reprogramationModel);
}
