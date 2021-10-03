import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/equipment_model.dart';

@immutable
abstract class EquipmentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEquipment extends EquipmentEvent {
  final String noRegistro;

  GetEquipment({this.noRegistro});
  
  List<Object> get props => [noRegistro];
}

class InsUpdEquipment extends EquipmentEvent {
  final String noRegistro;
  final List<EquipmentModel> params;

  InsUpdEquipment({this.noRegistro, this.params});

  List<Object> get props => [noRegistro, params];
}
