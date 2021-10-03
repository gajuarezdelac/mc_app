import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/internal_departure_model.dart';

@immutable
abstract class InternalDepartureState {
  final List<InternalDepartureModel> internalDepartureModel;
  final String message;

  InternalDepartureState({this.internalDepartureModel, this.message});
}

class InitialInternalDepartureState extends InternalDepartureState {}

class IsLoadingInternalDeparture extends InternalDepartureState {}

class ErrorInternalDeparture extends InternalDepartureState {
  ErrorInternalDeparture({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessInternalDeparture extends InternalDepartureState {
  SuccessInternalDeparture(
      {@required List<InternalDepartureModel> internalDepartureModel})
      : super(internalDepartureModel: internalDepartureModel);
}
