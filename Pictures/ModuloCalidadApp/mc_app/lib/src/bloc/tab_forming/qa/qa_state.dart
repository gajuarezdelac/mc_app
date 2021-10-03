import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/employee_model.dart';

@immutable
abstract class QAState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialQAState extends QAState {}

class IsLoadingQA extends QAState {}

class ErrorQA extends QAState {
  final String error;

  ErrorQA({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessGetQA extends QAState {
  final EmployeeModel qa;

  SuccessGetQA({@required this.qa});

  @override
  List<Object> get props => [qa];
}
