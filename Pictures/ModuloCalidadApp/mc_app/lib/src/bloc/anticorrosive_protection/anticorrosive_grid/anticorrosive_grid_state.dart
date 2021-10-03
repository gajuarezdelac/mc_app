import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';

@immutable
abstract class AnticorrosiveGridState {
  final List<AnticorrosiveProtectionModel> data;
  final String error;

  AnticorrosiveGridState({this.data, this.error});
}

class InitialGetAntiItemsState extends AnticorrosiveGridState {}

class IsLoadingAntiItems extends AnticorrosiveGridState {}

class ErrorAntiItems extends AnticorrosiveGridState {
  ErrorAntiItems({@required String error}) : super(error: error);
}

class SuccessAntiItems extends AnticorrosiveGridState {
  SuccessAntiItems({@required List<AnticorrosiveProtectionModel> data})
      : super(data: data);
}
