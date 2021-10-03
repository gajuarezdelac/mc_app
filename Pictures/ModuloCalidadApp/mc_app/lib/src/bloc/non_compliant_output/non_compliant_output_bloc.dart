import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/repository/non_compliant_output_repository.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/models/disposition_description_model.dart';
// import 'package:mc_app/src/models/contract_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';

class NonCompliantOutputBloc
    extends Bloc<NonCompliantOutputEvent, NonCompliantOutputState> {
  NonCompliantOutputBloc() : super(InitialNonCompliantOutput());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<NonCompliantOutputState> mapEventToState(
      NonCompliantOutputEvent event) async* {
    if (event is InsUpdSNC) {
      yield IsLoadingNonCompliantOutput();

      try {
        await _ncoRepository.insUpdSNC(
            nonCompliantOutput: event.nonCompliantOutput);

        yield SuccessInsUpdSNC();
      } catch (e) {
        yield ErrorNonCompliantOutput(error: e.toString());
      }
    }

    if (event is InsUpdDispositionDescription) {
      yield IsLoadingNonCompliantOutput();

      try {
        await _ncoRepository.insUpdDispositionDescription(params: event.params);

        yield SuccessInsUpdDispositionDescription();
      } catch (e) {
        yield ErrorNonCompliantOutput(error: e.toString());
      }
    }

    if (event is UpdEvaluateSNC) {
      yield IsLoadingNonCompliantOutput();

      try {
        await _ncoRepository.updEvaluateSNC(params: event.params);

        yield SuccessEvaluateSNC();
      } catch (e) {
        yield ErrorNonCompliantOutput(error: e.toString());
      }
    }

    if (event is InsSNCFN) {
      yield IsLoadingNonCompliantOutput();

      try {
        await _ncoRepository.insSNCFN(
            nonCompliantOutoutId: event.nonCompliantOutputId);

        yield SuccessInsSNCFN();
      } catch (e) {
        yield ErrorNonCompliantOutput(error: e.toString());
      }
    }

    if (event is FetchDispositionDescription) {
      yield IsLoadingDispositionDescription();

      try {
        DispositionDescriptionModel obj =
            await _ncoRepository.fetchDispositionDescription(
                nonCompliantOutputId: event.nonCompliantOutputId);

        yield SuccessDispositionDescription(dispositionDescriptionModel: obj);
      } catch (e) {
        yield ErrorDispositionDescription(error: e.toString());
      }
    }

    if (event is FetchPlannedResources) {
      yield IsLoadingPlannedResources();

      try {
        List<PlannedResourceModel> list =
            await _ncoRepository.fetchPlannedResources(
                dispositionDescriptionId: event.dispositionDescriptionId);

        yield SuccessPlannedResources(plannedModelList: list);
      } catch (e) {
        yield ErrorPlannedResources(error: e.toString());
      }
    }
    //
    // if (event is FetchDetectsSNC) {
    //   yield IsLoadingDetectsSNCState();

    //   try {
    //     List<SelectDropDownModel> list = await _ncoRepository.fetchDetecsSNC(
    //         bandeja: event.bandeja, nombre: event.nombre);

    //     yield SuccessDetectsSNC(detectsList: list);
    //   } catch (e) {
    //     yield ErrorDetectsSNC(error: e.toString());
    //   }
    // } else if (event is FetchConsecutiveSNC) {
    //   yield IsLoadingConsecutiveSNCState();

    //   try {
    //     List<SelectDropDownModel> list = await _ncoRepository
    //         .fetchConsecutiveSNC(bandeja: event.bandeja, id: event.id);

    //     yield SuccessConsecutiveSNC(consecutiveSNCList: list);
    //   } catch (e) {
    //     yield ErrorConsecutiveSNC(error: e.toString());
    //   }
    // } else if (event is FetchNonCompliantOutputDD) {
    //   yield IsLoadingNonCompliantOutputDD();

    //   try {
    //     List<NonCompliantOutputModel> list =
    //         await _ncoRepository.fetchNonCompliantOutputDD(
    //             nonCompliantOutputId: event.nonCompliantOutputId);

    //     yield SuccessNonCompliantOutputDD(nonCompliantOutputModelList: list);
    //   } catch (e) {
    //     yield ErrorNonCompliantOutputDD(error: e.toString());
    //   }
    // } else if (event is FetchDispositionDescription) {
    //   yield IsLoadingDispositionDescription();

    //   try {
    //     DispositionDescriptionModel obj =
    //         await _ncoRepository.fetchDispositionDescription(
    //             nonCompliantOutputId: event.nonCompliantOutputId);

    //     yield SuccessDispositionDescription(dispositionDescriptionModel: obj);
    //   } catch (e) {
    //     yield ErrorDispositionDescription(error: e.toString());
    //   }
    // } else if (event is FetchPlannedResources) {
    //   yield IsLoadingPlannedResources();

    //   try {
    //     List<PlannedResourceModel> list =
    //         await _ncoRepository.fetchPlannedResources(
    //             dispositionDescriptionId: event.dispositionDescriptionId);

    //     yield SuccessPlannedResources(plannedModelList: list);
    //   } catch (e) {
    //     yield ErrorPlannedResources(error: e.toString());
    //   }
    // } else if (event is FetchPlannedResourcesBySNCId) {
    //   yield IsLoadingPlannedResources();

    //   try {
    //     List<PlannedResourceModel> list =
    //         await _ncoRepository.fetchPlannedResourcesBySNCId(
    //             nonCompliantOutputId: event.nonCompliantOutputId);

    //     yield SuccessPlannedResources(plannedModelList: list);
    //   } catch (e) {
    //     yield ErrorPlannedResources(error: e.toString());
    //   }
    // }
  }
}

class NonCompliantOutputIdBloc
    extends Bloc<NonCompliantOutputIdEvent, NonCompliantOutputIdState> {
  NonCompliantOutputIdBloc() : super(InitialNonCompliantOutputIdState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<NonCompliantOutputIdState> mapEventToState(
      NonCompliantOutputIdEvent event) async* {
    if (event is FetchNonCompliantOutputId) {
      yield IsLoadingNonCompliantOutputId();

      try {
        List<NonCompliantOutputIdModel> list =
            await _ncoRepository.fetchNonCompliantOutputId(
                nonCompliantOutputId: event.nonCompliantOutputId);

        yield SuccessNonCompliantOutputId(nonCompliantOutputIdModelList: list);
      } catch (e) {
        yield ErrorNonCompliantOutputId(error: e.toString());
      }
    }
  }
}

class WorksSNCOutputBloc extends Bloc<FetchWorksSNCEvent, WorksSNCState> {
  WorksSNCOutputBloc() : super(InitialWorksSNSState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<WorksSNCState> mapEventToState(FetchWorksSNCEvent event) async* {
    if (event is FetchWorksSNC) {
      yield IsLoadingWorksSNCState();

      try {
        List<WorkDropDownModelSNC> list =
            await _ncoRepository.fetchWorksSNC(bandeja: event.bandeja);

        yield SuccessWorksSNC(workDropdownModelList: list);
      } catch (e) {
        yield ErrorWorksSNC(error: e.toString());
      }
    }
  }
}

class PlainDetailSNCBloc
    extends Bloc<PlainDetailSNCEvent, PlainDetailSNCState> {
  PlainDetailSNCBloc() : super(InitialPlainDetailSNCState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<PlainDetailSNCState> mapEventToState(
      PlainDetailSNCEvent event) async* {
    if (event is FetchPlainDetailSNC) {
      yield IsLoadingPlainDetailSNCState();

      try {
        List<PlainDetailDropDownModelSNC> list =
            await _ncoRepository.fetchPlainDetailSNC(bandeja: event.bandeja);

        yield SuccessPlainDetailSNC(plainDetailDDModelList: list);
      } catch (e) {
        yield ErrorPlainDetailSNC(error: e.toString());
      }
    }
  }
}

class TypeSNCOutputBloc extends Bloc<TypeSNCEvent, TypeSNCState> {
  TypeSNCOutputBloc() : super(InitialTypeSNCState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<TypeSNCState> mapEventToState(TypeSNCEvent event) async* {
    if (event is FetchTypeSNC) {
      yield IsLoadingTypeSNCState();

      try {
        List<TypeModelSNC> list =
            await _ncoRepository.fetchTypeSNC(bandeja: event.bandeja);

        yield SuccessTypeSNC(typeSNCList: list);
      } catch (e) {
        yield ErrorTypeSNC(error: e.toString());
      }
    }
  }
}

class PaginatorSNCBloc extends Bloc<NoCompliantOutputPaginatorEvent,
    NonCompliantOutputPaginatorState> {
  PaginatorSNCBloc() : super(InitialNonCompliantOutputPaginatorState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<NonCompliantOutputPaginatorState> mapEventToState(
      NoCompliantOutputPaginatorEvent event) async* {
    if (event is FetchNoCompliantOutputPaginator) {
      yield IsLoadingNonCompliantOutputPaginatorState();

      try {
        List<NonCompliantOutputPaginatorModel> list =
            await _ncoRepository.fetchNoCompliantOutputPaginator(
                bandeja: event.bandeja,
                ids: event.ids,
                contratos: event.contratos,
                obras: event.obras,
                planos: event.planos,
                tipos: event.tipos,
                fichas: event.fichas,
                aplica: event.aplica,
                atribuible: event.atribuible,
                estatus: event.estatus,
                offset: event.offset,
                nextrows: event.nextrows);

        yield SuccessNonCompliantOutputPaginator(ncoPaginatorModelList: list);
      } catch (e) {
        yield ErrorNonCompliantOutputPaginator(error: e.toString());
      }
    }
  }
}

class PlannedResourcesBloc
    extends Bloc<PlannedResourceEvent, PlannedResourcesState> {
  PlannedResourcesBloc() : super(InitialPlannedResourceState());

  final _ncoRepository = NonCompliantOutputRepository();

  @override
  Stream<PlannedResourcesState> mapEventToState(
      PlannedResourceEvent event) async* {
    if (event is FetchPlannedResourcesBySNCId) {
      yield IsLoadingPlannedResourceState();

      try {
        List<PlannedResourceModel> list =
            await _ncoRepository.fetchPlannedResourcesBySNCId(
                nonCompliantOutputId: event.nonCompliantOutputId);

        yield SuccessPlannedResourceState(modelList: list);
      } catch (e) {
        yield ErrorPlannedResourceState(error: e.toString());
      }
    }
  }
}
