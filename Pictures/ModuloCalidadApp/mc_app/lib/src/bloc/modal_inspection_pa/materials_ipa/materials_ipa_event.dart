import 'package:equatable/equatable.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';

abstract class MaterialsIPAEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMaterialsIPA extends MaterialsIPAEvent {
  final String noRegistro;

  GetMaterialsIPA({this.noRegistro});

  List<Object> get props => [noRegistro];
}

class InsUpdMaterialsIPA extends MaterialsIPAEvent {
  final List<MaterialsTableIPAModel> params;
  final String noRegistro;

  InsUpdMaterialsIPA({this.params, this.noRegistro});

  List<Object> get props => [params, noRegistro];
}