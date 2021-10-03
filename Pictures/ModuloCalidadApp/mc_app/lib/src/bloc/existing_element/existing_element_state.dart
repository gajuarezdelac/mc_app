import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/existing_element_model.dart';

@immutable
abstract class ExistingElementState {
  final List<ExistingElementModel> existingElement;
  final String message;

  ExistingElementState({this.existingElement, this.message});
}

class InitialExistingElementState extends ExistingElementState {}

class IsLoadingExistingElement extends ExistingElementState {}

class ErrorExistingElement extends ExistingElementState {
  ErrorExistingElement({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessExistingElement extends ExistingElementState {
  SuccessExistingElement({@required List<ExistingElementModel> existingElement}) : super(existingElement: existingElement);
}
