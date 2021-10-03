import 'package:flutter/material.dart';

@immutable
abstract class PermissionEvent {
  final int ficha;

  PermissionEvent({this.ficha});
}

class GetPermission extends PermissionEvent {
  GetPermission({@required int ficha}) : super(ficha: ficha);
}
