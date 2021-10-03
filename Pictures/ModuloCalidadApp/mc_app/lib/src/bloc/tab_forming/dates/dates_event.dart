import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/forming_cs_params.dart';

@immutable
abstract class DatesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para guardar las fechas
class SetDates extends DatesEvent {
  final FormingCSParams params;

  SetDates({@required this.params});

  @override
  List<Object> get props => [params];
}
