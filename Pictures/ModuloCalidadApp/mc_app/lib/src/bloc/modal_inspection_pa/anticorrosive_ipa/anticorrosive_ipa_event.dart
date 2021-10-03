import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';

@immutable
abstract class InfoGeneralEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class GetInfoGeneral extends InfoGeneralEvent {
  final String noRegistro;

  GetInfoGeneral({this.noRegistro});

  List<Object> get props => [noRegistro];
}

class InsUpdInfoGeneral extends InfoGeneralEvent {
  final String noRegistro;
  final AnticorrosiveIPAModel anticorrosiveIPAModel;

  InsUpdInfoGeneral({this.anticorrosiveIPAModel, this.noRegistro});

  List<Object> get props => [anticorrosiveIPAModel];
}