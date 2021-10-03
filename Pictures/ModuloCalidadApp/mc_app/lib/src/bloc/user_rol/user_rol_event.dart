import 'package:flutter/material.dart';

@immutable
abstract class UserRolEvent {
  final int ficha;

  UserRolEvent({this.ficha});
}

class GetInfoUserRol extends UserRolEvent {
  GetInfoUserRol({@required int ficha}) : super(ficha: ficha);
}
