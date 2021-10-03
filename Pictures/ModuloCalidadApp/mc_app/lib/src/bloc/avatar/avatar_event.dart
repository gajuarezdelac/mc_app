import 'package:flutter/material.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';

@immutable
abstract class AvatarEvent {
  final UserAvatarModel userAvatarModel;
  final String ficha;

  AvatarEvent({this.userAvatarModel, this.ficha});
}

class GetInfoAvatar extends AvatarEvent {
  GetInfoAvatar({String ficha}) : super(ficha: ficha);
}
