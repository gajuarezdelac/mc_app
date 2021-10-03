import 'package:flutter/material.dart';
import 'package:mc_app/src/models/user_permission_model.dart';

@immutable
abstract class PermissionState {
  final UserPermissionModel permissions;
  final String error;

  PermissionState({this.permissions, this.error});
}

class InitialPermissionState extends PermissionState {}

class IsLoadingGetPermission extends PermissionState {}

class ErrorGetPermission extends PermissionState {
  ErrorGetPermission({@required String error}) : super(error: error);
}

class SuccessGetPermission extends PermissionState {
  SuccessGetPermission({@required UserPermissionModel permissions})
      : super(permissions: permissions);
}
