import 'package:flutter/material.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';

@immutable
abstract class AvatarState {
  final UserAvatarModel userAvatarModel;
  final String message;

  AvatarState({this.userAvatarModel, this.message});
}

class InitialAvatarState extends AvatarState {}

class IsLoading extends AvatarState {}

class Error extends AvatarState {
  Error({@required String errorMessage}) : super(message: errorMessage);
}

class Success extends AvatarState {
  Success({@required UserAvatarModel userAvatarModel})
      : super(userAvatarModel: userAvatarModel);
}
