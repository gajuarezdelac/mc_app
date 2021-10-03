import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/models/stage_materials_ipa_model.dart';

@immutable
abstract class StageMaterialIPAEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetStageMaterialIPA extends StageMaterialIPAEvent {
  final String noRegistro;

  GetStageMaterialIPA({this.noRegistro});

  List<Object> get props => [noRegistro];
}

class InsUpdStageMaterialIPA extends StageMaterialIPAEvent {
  final List<StageMaterialsIPAModel> params;

  InsUpdStageMaterialIPA({this.params});

  List<Object> get props => [params];
}