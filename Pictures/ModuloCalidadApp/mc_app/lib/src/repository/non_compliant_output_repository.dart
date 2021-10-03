//import 'dart:html';
//import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/data/dao/non_compliant_output_dao.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/models/params/disposition_description_params.dart';
import 'package:mc_app/src/models/params/evaluation_snc_params.dart';

class NonCompliantOutputRepository {
  final nonCompliantOutputDao = NonCompliantOutputDao();

  Future fetchWorksSNC({
    int bandeja,
  }) =>
      nonCompliantOutputDao.fetchWorksSNC(
        bandeja,
      );

  Future fetchPlainDetailSNC({
    int bandeja,
  }) =>
      nonCompliantOutputDao.fetchPlainDetailSNC(
        bandeja,
      );

  Future fetchTypeSNC({
    int bandeja,
  }) =>
      nonCompliantOutputDao.fetchTypeSNC(
        bandeja,
      );

  Future fetchDetecsSNC({int bandeja, String nombre}) =>
      nonCompliantOutputDao.fetchDetectsSNC(bandeja, nombre);

  Future fetchConsecutiveSNC({int bandeja, String id}) =>
      nonCompliantOutputDao.fetchConsecutiveSNC(bandeja, id);

  Future fetchNoCompliantOutputPaginator({
    String ids,
    String contratos,
    String obras,
    String planos,
    String tipos,
    String fichas,
    String aplica,
    String atribuible,
    String estatus,
    int bandeja,
    int offset,
    int nextrows,
  }) =>
      nonCompliantOutputDao.fetchNonCompliantOutputPaginator(bandeja,
          ids: ids,
          contratos: contratos,
          obras: obras,
          planos: planos,
          tipos: tipos,
          fichas: fichas,
          aplica: aplica,
          atribuible: atribuible,
          estatus: estatus,
          offset: offset,
          nextrows: nextrows);

  Future fetchNonCompliantOutputId({
    String nonCompliantOutputId,
  }) =>
      nonCompliantOutputDao.fetchNonCompliantOutputId(
        nonCompliantOutputId,
      );

  Future fetchNonCompliantOutputDD({
    String nonCompliantOutputId,
  }) =>
      nonCompliantOutputDao.fetchNonCompliantOutputDD(
        nonCompliantOutputId,
      );

  Future fetchContractsSNC({int bandeja}) =>
      nonCompliantOutputDao.fetchContractsSNC(bandeja);

  Future insUpdDispositionDescription({DispositionDescriptionParams params}) =>
      nonCompliantOutputDao.insUpdDispositionDescription(params);

  Future fetchDispositionDescription({
    String nonCompliantOutputId,
  }) =>
      nonCompliantOutputDao.fetchDispositionDescription(
        nonCompliantOutputId,
      );

  Future fetchPlannedResources({
    String dispositionDescriptionId,
  }) =>
      nonCompliantOutputDao.fetchPlannedResources(
        dispositionDescriptionId,
      );

  Future fetchPlannedResourcesBySNCId({
    String nonCompliantOutputId,
  }) =>
      nonCompliantOutputDao.fetchPlannedResourcesBySNCId(
        nonCompliantOutputId,
      );

  Future updEvaluateSNC({EvaluationSNCParams params}) =>
      nonCompliantOutputDao.updEvaluateSNC(params);

  Future insSNCFN({String nonCompliantOutoutId}) =>
      nonCompliantOutputDao.insSNCFN(nonCompliantOutoutId);

  Future insUpdSNC({NonCompliantOutputIdModel nonCompliantOutput}) =>
      nonCompliantOutputDao.insUpdSNC(nonCompliantOutput);
}
