import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';

@immutable
abstract class DropDownPrimaveIdState {
  final List<PrimaveraIdModel> primaveraModel;
  final String message;

  DropDownPrimaveIdState({
    this.primaveraModel,
    this.message,
  });
}

class InitialDropDownPrimaveraIdState extends DropDownPrimaveIdState {}

class IsLoadingPrimaveraId extends DropDownPrimaveIdState {}

class ErrorPrimaveraId extends DropDownPrimaveIdState {
  ErrorPrimaveraId({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessPrimaveraId extends DropDownPrimaveIdState {
  SuccessPrimaveraId({@required List<PrimaveraIdModel> primaveraModel})
      : super(primaveraModel: primaveraModel);
}
