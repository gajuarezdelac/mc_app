import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/models/params/disposition_description_params.dart';
import 'package:mc_app/src/models/params/evaluation_snc_params.dart';
// import 'package:mc_app/src/models/params/evaluation_snc_params.dart';

@immutable
abstract class NonCompliantOutputEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

@immutable
abstract class FetchWorksSNCEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchWorksSNC extends FetchWorksSNCEvent {
  final int bandeja;

  FetchWorksSNC({@required this.bandeja});

  @override
  List<Object> get props => [bandeja];
}

@immutable
abstract class PlainDetailSNCEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchPlainDetailSNC extends PlainDetailSNCEvent {
  final int bandeja;

  FetchPlainDetailSNC({@required this.bandeja});

  @override
  List<Object> get props => [bandeja];
}

@immutable
abstract class NonCompliantOutputIdEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchNonCompliantOutputId extends NonCompliantOutputIdEvent {
  final String nonCompliantOutputId;

  FetchNonCompliantOutputId({@required this.nonCompliantOutputId});

  @override
  List<Object> get props => [nonCompliantOutputId];
}

@immutable
abstract class TypeSNCEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchTypeSNC extends TypeSNCEvent {
  final int bandeja;

  FetchTypeSNC({@required this.bandeja});

  @override
  List<Object> get props => [bandeja];
}

class FetchDetectsSNC extends NonCompliantOutputEvent {
  final int bandeja;
  final String nombre;

  FetchDetectsSNC({@required this.bandeja, @required this.nombre});

  @override
  List<Object> get props => [bandeja, nombre];
}

class FetchConsecutiveSNC extends NonCompliantOutputEvent {
  final int bandeja;
  final String id;

  FetchConsecutiveSNC({@required this.bandeja, @required this.id});

  @override
  List<Object> get props => [bandeja, id];
}

@immutable
abstract class NoCompliantOutputPaginatorEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchNoCompliantOutputPaginator extends NoCompliantOutputPaginatorEvent {
  final int bandeja;
  final String ids;
  final String contratos;
  final String obras;
  final String planos;
  final String tipos;
  final String fichas;
  final String aplica;
  final String atribuible;
  final String estatus;
  final int offset;
  final int nextrows;

  FetchNoCompliantOutputPaginator(
      {@required this.bandeja,
      this.ids,
      this.contratos,
      this.obras,
      this.planos,
      this.tipos,
      this.fichas,
      this.aplica,
      this.atribuible,
      this.estatus,
      this.offset,
      this.nextrows});

  @override
  List<Object> get props => [
        bandeja,
        ids,
        contratos,
        obras,
        planos,
        tipos,
        fichas,
        aplica,
        atribuible,
        estatus,
        offset,
        nextrows
      ];
}

class FetchNonCompliantOutputDD extends NonCompliantOutputEvent {
  final String nonCompliantOutputId;

  FetchNonCompliantOutputDD({@required this.nonCompliantOutputId});

  @override
  List<Object> get props => [nonCompliantOutputId];
}

class FetchDispositionDescription extends NonCompliantOutputEvent {
  final String nonCompliantOutputId;

  FetchDispositionDescription({@required this.nonCompliantOutputId});

  @override
  Object get prop => [nonCompliantOutputId];
}

class FetchPlannedResources extends NonCompliantOutputEvent {
  final String dispositionDescriptionId;

  FetchPlannedResources({@required this.dispositionDescriptionId});

  @override
  List<Object> get props => [dispositionDescriptionId];
}

@immutable
abstract class PlannedResourceEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchPlannedResourcesBySNCId extends PlannedResourceEvent {
  final String nonCompliantOutputId;

  FetchPlannedResourcesBySNCId({@required this.nonCompliantOutputId});

  @override
  List<Object> get props => [nonCompliantOutputId];
}

class InsUpdDispositionDescription extends NonCompliantOutputEvent {
  final DispositionDescriptionParams params;

  InsUpdDispositionDescription({@required this.params});

  // @override
  // List<Object> get props => [params];
}

class UpdEvaluateSNC extends NonCompliantOutputEvent {
  final EvaluationSNCParams params;

  UpdEvaluateSNC({@required this.params});

  // @override
  // List<Object> get props => [params];
}

class InsSNCFN extends NonCompliantOutputEvent {
  final String nonCompliantOutputId;

  InsSNCFN({@required this.nonCompliantOutputId});

  // @override
  // List<Object> get props => [params];
}

class InsUpdSNC extends NonCompliantOutputEvent {
  final NonCompliantOutputIdModel nonCompliantOutput;

  InsUpdSNC({@required this.nonCompliantOutput});

  // @override
  // List<Object> get props => [params];
}
