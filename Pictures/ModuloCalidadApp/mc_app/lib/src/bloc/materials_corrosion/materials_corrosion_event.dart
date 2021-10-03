import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/get_materials_corrosion_params.dart';

@immutable
abstract class MaterialsCorrosionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento para obtener la trazabilidad uno por la JuntaId
class GetAllMaterialsCorrosion extends MaterialsCorrosionEvent {
  final GetMaterialsCorrisionParamsModel params;

  GetAllMaterialsCorrosion({this.params});

  @override
  List<Object> get props => [params];
}