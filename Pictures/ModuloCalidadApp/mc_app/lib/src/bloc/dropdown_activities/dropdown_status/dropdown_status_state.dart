import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownStatusState {
  final List<EstatusIdModel> estatus;
  final String selectedStatus;
  final String message;

  DropDownStatusState({
    this.estatus,
    this.selectedStatus,
    this.message,
  });
}

class InitialDropDownStatusState extends DropDownStatusState {}

class IsLoadingStatus extends DropDownStatusState {}

class ErrorStatus extends DropDownStatusState {
  ErrorStatus({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessStatus extends DropDownStatusState {
  SuccessStatus({@required List<EstatusIdModel> estatus})
      : super(estatus: estatus);
}
