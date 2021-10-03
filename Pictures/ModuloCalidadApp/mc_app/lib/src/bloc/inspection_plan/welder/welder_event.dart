import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/add_welder_parms.dart';
import 'package:mc_app/src/models/params/get_information_welder_Param.dart';

@immutable
abstract class WelderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInformacionadicionalEvent extends WelderEvent {
  final GetInformationWelderParam params;

  GetInformacionadicionalEvent({this.params});

  @override
  List<Object> get props => [params];
}

class AddWelderPlanEvent extends WelderEvent {
  final AddWelderParams params;
  AddWelderPlanEvent({this.params});

  @override
  List<Object> get props => [params];
}

class AddTrazabilidadEvent extends WelderEvent {
  final List<SoldadorTrazabilidadRIA> params;

  AddTrazabilidadEvent({this.params});

  @override
  List<Object> get props => [params];
}

class GetWelderPlanEvent extends WelderEvent {
  final dynamic params;

  GetWelderPlanEvent({this.params});

  @override
  List<Object> get props => [params];
}
