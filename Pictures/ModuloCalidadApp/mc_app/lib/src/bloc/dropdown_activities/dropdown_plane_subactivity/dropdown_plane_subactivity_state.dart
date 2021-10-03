import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownPlaneSubactivityState {
  final List<PlanoSubActividadModel> planeSubactivityModel;
  final String message;

  DropDownPlaneSubactivityState({
    this.planeSubactivityModel,
    this.message,
  });
}

class InitialDropDownPlaneSubactivityState
    extends DropDownPlaneSubactivityState {}

class IsLoadingPlaneSubactivity extends DropDownPlaneSubactivityState {}

class ErrorPlaneSubactivity extends DropDownPlaneSubactivityState {
  ErrorPlaneSubactivity({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessPlaneSubactivity extends DropDownPlaneSubactivityState {
  SuccessPlaneSubactivity(
      {@required List<PlanoSubActividadModel> planeSubactivityModel})
      : super(planeSubactivityModel: planeSubactivityModel);
}
