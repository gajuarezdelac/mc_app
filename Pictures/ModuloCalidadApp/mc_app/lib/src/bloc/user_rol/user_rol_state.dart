import 'package:flutter/material.dart';
import 'package:mc_app/src/models/user_off_model.dart';

@immutable
abstract class UserRolState {
  final UserGeneral userGeneral;
  final String message;

  UserRolState({this.userGeneral, this.message});
}

class InitialUserRolState extends UserRolState {}

class IsLoadingGetUserRol extends UserRolState {}

class ErrorGetUserRol extends UserRolState {
  ErrorGetUserRol({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessGetUserRol extends UserRolState {
  SuccessGetUserRol({@required UserGeneral userGeneral})
      : super(userGeneral: userGeneral);
}
