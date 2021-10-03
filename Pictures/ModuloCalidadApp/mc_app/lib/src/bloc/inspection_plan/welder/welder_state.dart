import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class WelderState {
  final List<InformacionadicionalModel> informationWelder;
  final FetchWelderModel welder;
  final String message;

  WelderState({this.informationWelder, this.message, this.welder});
}

class InitialWelderState extends WelderState {}

class IsLoadingInformacionadicional extends WelderState {}

class IsLoadingAddWelder extends WelderState {}

class IsLoadingAddTrazabilidad extends WelderState {}

class IsLoadingGetWelderPlan extends WelderState {}

class ErrorWelder extends WelderState {
  ErrorWelder({@required String errorMessage}) : super(message: errorMessage);
}

class ErrorGetInformationAditional extends WelderState {
  ErrorGetInformationAditional({@required String errorMessage})
      : super(message: errorMessage);
}

class ErrorGetWelderPlan extends WelderState {
  ErrorGetWelderPlan({@required String errorMessage})
      : super(message: errorMessage);
}

class ErrorSaveWelderGeneral extends WelderState {
  ErrorSaveWelderGeneral({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessGetInformacionadicional extends WelderState {
  SuccessGetInformacionadicional(
      {@required List<InformacionadicionalModel> information})
      : super(informationWelder: information);
}

class SuccessGetWelderPlan extends WelderState {
  SuccessGetWelderPlan({@required FetchWelderModel welder})
      : super(welder: welder);
}

class SuccessAddWelder extends WelderState {
  final List<ResponseSaveWelder> success;
  SuccessAddWelder({this.success});
}

class SuccessAddTrazabilidad extends WelderState {
  final int response;
  SuccessAddTrazabilidad({this.response});
}
