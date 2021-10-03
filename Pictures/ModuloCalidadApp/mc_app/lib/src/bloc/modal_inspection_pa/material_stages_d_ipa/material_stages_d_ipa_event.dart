import 'package:equatable/equatable.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';

abstract class MaterialStagesDIPAEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMaterialStagesDIPA extends MaterialStagesDIPAEvent {
  final String noRegistro;

  GetMaterialStagesDIPA({this.noRegistro});

  List<Object> get props => [noRegistro];
}

class InsUpdMaterialStagesDIPA extends MaterialStagesDIPAEvent {
  final List<MaterialStagesDIPAModel> params;

  InsUpdMaterialStagesDIPA({this.params});

  List<Object> get props => [params];
}