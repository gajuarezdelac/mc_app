import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownClientActivityState {
  final List<ActividadClienteModel> activityClientModel;
  final String message;

  DropDownClientActivityState({
    this.activityClientModel,
    this.message,
  });
}

class InitialDropDownClientActivityState extends DropDownClientActivityState {}

class IsLoadingClientActivity extends DropDownClientActivityState {}

class ErrorClientActivity extends DropDownClientActivityState {
  ErrorClientActivity({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessClientActivity extends DropDownClientActivityState {
  SuccessClientActivity(
      {@required List<ActividadClienteModel> activityClientModel})
      : super(activityClientModel: activityClientModel);
}
