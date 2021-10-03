import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/anticorrosive_protection_header_model.dart';

@immutable
abstract class HeaderState {
  final String error;
  final AnticorrosiveProtectionHeaderModel anticorrosiveProtectionHeaderModel;

  HeaderState({this.error, this.anticorrosiveProtectionHeaderModel});
}

class InitialHeaderState extends HeaderState {}

class IsLoadingHeader extends HeaderState {}

class ErrorHeader extends HeaderState {
  ErrorHeader({@required String error}) : super(error: error);
}

class SuccessHeader extends HeaderState {
  SuccessHeader({@required AnticorrosiveProtectionHeaderModel anticorrosiveProtectionHeaderModel})
      : super(anticorrosiveProtectionHeaderModel: anticorrosiveProtectionHeaderModel);
}