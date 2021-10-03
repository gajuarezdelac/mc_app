import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class OverseerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class GetOverseer extends OverseerEvent {
  final int employeeId;

  GetOverseer({@required this.employeeId});

  @override
  List<Object> get props => [employeeId];
}

@immutable
abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener a los tuberos del Conformado
class GetEmployeeByFicha extends EmployeeEvent {
  final int ficha;

  GetEmployeeByFicha({@required this.ficha});

  @override
  List<Object> get props => [ficha];
}

// Evento para obtener al que realiza la disposición
class GetEmployeeMakesByFicha extends EmployeeEvent {
  final int ficha;

  GetEmployeeMakesByFicha({@required this.ficha});

  @override
  List<Object> get props => [ficha];
}

// Evento para obtener al que autoriza la disposición
class GetEmployeeAuthByFicha extends EmployeeEvent {
  final int ficha;

  GetEmployeeAuthByFicha({@required this.ficha});

  @override
  List<Object> get props => [ficha];
}
