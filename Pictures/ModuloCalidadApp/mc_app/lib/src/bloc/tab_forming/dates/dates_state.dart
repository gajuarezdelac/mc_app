import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DatesState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialDatesState extends DatesState {}

// Estados para obtener los tuberos del conformado
class IsLoadingDates extends DatesState {}

class ErrorDates extends DatesState {
  final String error;

  ErrorDates({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessDates extends DatesState {
  final int result;
  final String message;
  final String action;

  SuccessDates({
    @required this.result,
    @required this.message,
    @required this.action,
  });

  @override
  List<Object> get props => [result, message, action];
}
