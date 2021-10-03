import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/employee_model.dart';

@immutable
abstract class OverseerState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialOverseerState extends OverseerState {}

class IsLoadingOverseer extends OverseerState {}

class ErrorOverseer extends OverseerState {
  final String error;

  ErrorOverseer({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessGetOverseer extends OverseerState {
  final EmployeeModel overseer;

  SuccessGetOverseer({@required this.overseer});

  @override
  List<Object> get props => [overseer];
}

@immutable
abstract class EmployeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialEmployeeState extends EmployeeState {}

class IsLoadingEmployee extends EmployeeState {}

class ErrorEmployee extends EmployeeState {
  final String error;

  ErrorEmployee({@required this.error});

  @override
  List<Object> get props => [error];
}

class SuccessEmployee extends EmployeeState {
  final EmployeeModel employee;

  SuccessEmployee({@required this.employee});

  @override
  List<Object> get props => [employee];
}

class SuccessEmployeeMakes extends EmployeeState {
  final EmployeeModel employee;

  SuccessEmployeeMakes({@required this.employee});

  @override
  List<Object> get props => [employee];
}

class SuccessEmployeeAuth extends EmployeeState {
  final EmployeeModel employee;

  SuccessEmployeeAuth({@required this.employee});

  @override
  List<Object> get props => [employee];
}