import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';

@immutable
abstract class DropDownPlainDetailState {
  final List<PlainDetailDropDownModel> plainDetails;
  final String message;

  DropDownPlainDetailState({this.plainDetails, this.message});
}

class InitialDropDownPlainDetailState extends DropDownPlainDetailState {}

class IsLoadingPlainDetails extends DropDownPlainDetailState {}

class ErrorPlainDetails extends DropDownPlainDetailState {
  ErrorPlainDetails({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessPlainDetails extends DropDownPlainDetailState {
  SuccessPlainDetails({@required List<PlainDetailDropDownModel> plainDetails})
      : super(plainDetails: plainDetails);
}
