import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';

@immutable
abstract class CoatingAplicationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCoatingAplication extends CoatingAplicationEvent {
  final String noRegistro;
  GetCoatingAplication({this.noRegistro});
  
  List<Object> get props => [noRegistro];
}

class InsUpdCoatingAplication extends CoatingAplicationEvent {
  final List<CoatingAplicationModel> params;
  final String noRegistro;

  InsUpdCoatingAplication({this.params, this.noRegistro});

  List<Object> get props => [params, noRegistro];
}
