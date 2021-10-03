import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';
import 'package:mc_app/src/models/disposition_description_model.dart';
import 'package:mc_app/src/models/contract_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/select_dropdown_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';

//NonCompliantOutputState
@immutable
abstract class NonCompliantOutputState {
  final String error;
  final List<WorkDropDownModel> workList;
  final List<PlainDetailDropDownModel> detailPlainList;
  final List<String> typeSNCList;
  final List<SelectDropDownModel> detectsList;
  final List<SelectDropDownModel> consecutiveSNCList;
  final List<NonCompliantOutputPaginatorModel> ncoPaginatorList;
  final List<NonCompliantOutputIdModel> ncoIdModelList;
  final List<NonCompliantOutputModel> ncoDDList;
  final List<ContractModel> contractSNCList;
  final DispositionDescriptionModel dispositionDescriptionModel;
  final List<PlannedResourceModel> plannedResourceList;

  NonCompliantOutputState({
    this.error,
    this.workList,
    this.detailPlainList,
    this.typeSNCList,
    this.detectsList,
    this.consecutiveSNCList,
    this.ncoPaginatorList,
    this.ncoIdModelList,
    this.ncoDDList,
    this.contractSNCList,
    this.dispositionDescriptionModel,
    this.plannedResourceList,
  });
}
class IsLoadingNonCompliantOutput extends NonCompliantOutputState {}
class InitialNonCompliantOutput extends NonCompliantOutputState {}
class SuccessInsUpdSNC extends NonCompliantOutputState {}
class SuccessInsUpdDispositionDescription extends NonCompliantOutputState {}
class SuccessEvaluateSNC extends NonCompliantOutputState {}
class SuccessInsSNCFN extends NonCompliantOutputState {}
class ErrorNonCompliantOutput extends NonCompliantOutputState {
  ErrorNonCompliantOutput({@required String error}) : super(error: error);
}


// class InitialWorksSNSState extends NonCompliantOutputState {}

// class IsLoadingWorksSNCState extends NonCompliantOutputState {}

// class ErrorWorksSNC extends NonCompliantOutputState {
//   ErrorWorksSNC({@required String error}) : super(error: error);
// }

// class SuccessWorksSNC extends NonCompliantOutputState {
//   final List<WorkDropDownModel> workDropdownModelList;

//   SuccessWorksSNC({@required this.workDropdownModelList})
//       : super(workList: workDropdownModelList);
// }

//WorksSNC
@immutable
abstract class WorksSNCState {
  final List<WorkDropDownModelSNC> works;
  final String error;

  WorksSNCState({this.works, this.error});
}

class InitialWorksSNSState extends WorksSNCState {}

class IsLoadingWorksSNCState extends WorksSNCState {}

class ErrorWorksSNC extends WorksSNCState {
  ErrorWorksSNC({@required String error}) : super(error: error);
}

class SuccessWorksSNC extends WorksSNCState {
  final List<WorkDropDownModelSNC> workDropdownModelList;

  SuccessWorksSNC({@required this.workDropdownModelList})
      : super(works: workDropdownModelList);

  // @override
  // List<WorkDropDownModel> get works => [workDropdownModelList];
}

//PlainDetailSNC
@immutable
abstract class PlainDetailSNCState {
  final List<PlainDetailDropDownModelSNC> plainDetailDDModelList;
  final String error;

  PlainDetailSNCState({this.plainDetailDDModelList, this.error});
}

class InitialPlainDetailSNCState extends PlainDetailSNCState {}

class IsLoadingPlainDetailSNCState extends PlainDetailSNCState {}

class ErrorPlainDetailSNC extends PlainDetailSNCState {
  final String error;

  ErrorPlainDetailSNC({@required this.error}) : super(error: error);
}

class SuccessPlainDetailSNC extends PlainDetailSNCState {
  final List<PlainDetailDropDownModelSNC> plainDetailDDModelList;

  SuccessPlainDetailSNC({@required this.plainDetailDDModelList})
      : super(plainDetailDDModelList: plainDetailDDModelList);
}

//TypeSNC
@immutable
abstract class TypeSNCState {
  final List<TypeModelSNC> typeSNCList;
  final String error;

  TypeSNCState({this.typeSNCList, this.error});
}

class InitialTypeSNCState extends TypeSNCState {}

class IsLoadingTypeSNCState extends TypeSNCState {}

class ErrorTypeSNC extends TypeSNCState {
  final String error;

  ErrorTypeSNC({@required this.error}) : super(error: error);

  // @override
  // List<Object> get props => [error];
}

class SuccessTypeSNC extends TypeSNCState {
  final List<TypeModelSNC> typeSNCList;

  SuccessTypeSNC({@required this.typeSNCList})
      : super(typeSNCList: typeSNCList);

  // @override
  // List<Object> get props => [typeSNCList];
}
// //TypeSNC
// class InitialTypeSNCState extends NonCompliantOutputState {}

// class IsLoadingTypeSNCState extends NonCompliantOutputState {}

// class ErrorTypeSNC extends NonCompliantOutputState {
//   final String error;

//   ErrorTypeSNC({@required this.error}) : super(error: error);
// }

// class SuccessTypeSNC extends NonCompliantOutputState {
//   final List<String> typeSNCList;

//   SuccessTypeSNC({@required this.typeSNCList})
//       : super(typeSNCList: typeSNCList);
// }

// //DetectsSNC
// @immutable
// abstract class DetectsSNCState {
//   final List<SelectDropDownModel> selectDDList;
//   final String error;

//   DetectsSNCState({this.selectDDList, this.error});
// }

// class InitialDetectsSNCState extends DetectsSNCState {}

// class IsLoadingDetectsSNCState extends DetectsSNCState {}

// class ErrorDetectsSNC extends DetectsSNCState {
//   final String error;

//   ErrorDetectsSNC({@required this.error}) : super(error: error);

//DetectsSNC
class InitialDetectsSNCState extends NonCompliantOutputState {}

class IsLoadingDetectsSNCState extends NonCompliantOutputState {}

class ErrorDetectsSNC extends NonCompliantOutputState {
  final String error;

  ErrorDetectsSNC({@required this.error}) : super(error: error);
}

class SuccessDetectsSNC extends NonCompliantOutputState {
  final List<SelectDropDownModel> detectsList;

  SuccessDetectsSNC({@required this.detectsList})
      : super(detectsList: detectsList);
}

// //ConsecutiveSNC
// @immutable
// abstract class ConsecutiveSNCState {
//   final List<SelectDropDownModel> selectDDList;
//   final String error;

//   ConsecutiveSNCState({this.selectDDList, this.error});
// }

// class InitialConsecutiveSNCState extends ConsecutiveSNCState {}

// class IsLoadingConsecutiveSNCState extends ConsecutiveSNCState {}

// class ErrorConsecutiveSNC extends ConsecutiveSNCState {
//   final String error;

//   ErrorConsecutiveSNC({@required this.error}) : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessConsecutiveSNC extends ConsecutiveSNCState {
//   final List<SelectDropDownModel> selectDDModelList;

//   SuccessConsecutiveSNC({@required this.selectDDModelList})
//       : super(selectDDList: selectDDModelList);

//   // @override
//   // List<Object> get props => [selectDDModelList];
// }

//ConsecutiveSNC
class InitialConsecutiveSNCState extends NonCompliantOutputState {}

class IsLoadingConsecutiveSNCState extends NonCompliantOutputState {}

class ErrorConsecutiveSNC extends NonCompliantOutputState {
  final String error;

  ErrorConsecutiveSNC({@required this.error}) : super(error: error);
}

class SuccessConsecutiveSNC extends NonCompliantOutputState {
  final List<SelectDropDownModel> consecutiveSNCList;

  SuccessConsecutiveSNC({@required this.consecutiveSNCList})
      : super(consecutiveSNCList: consecutiveSNCList);
}

// //NonCompliantOutputPaginator
// @immutable
// abstract class NonCompliantOutputPaginatorState {
//   final List<NonCompliantOutputPaginatorModel> ncoPaginatorList;
//   final String error;

//   NonCompliantOutputPaginatorState({this.ncoPaginatorList, this.error});
// }

// class InitialNonCompliantOutputPaginatorState
//     extends NonCompliantOutputPaginatorState {}

// class IsLoadingNonCompliantOutputPaginatorState
//     extends NonCompliantOutputPaginatorState {}

// class ErrorNonCompliantOutputPaginator
//     extends NonCompliantOutputPaginatorState {
//   final String error;

//   ErrorNonCompliantOutputPaginator({@required this.error})
//       : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessNonCompliantOutputPaginator
//     extends NonCompliantOutputPaginatorState {
//   final List<NonCompliantOutputPaginatorModel> ncoPaginatorModelList;

//   SuccessNonCompliantOutputPaginator({@required this.ncoPaginatorModelList})
//       : super(ncoPaginatorList: ncoPaginatorModelList);

//   // @override
//   // List<Object> get props => [ncoPaginatorModelList];
// }
//NonCompliantOutputPaginator
@immutable
abstract class NonCompliantOutputPaginatorState {
  final List<NonCompliantOutputPaginatorModel> ncoPaginatorList;
  final String error;

  NonCompliantOutputPaginatorState({this.ncoPaginatorList, this.error});
}
 
class InitialNonCompliantOutputPaginatorState extends NonCompliantOutputPaginatorState {}

class IsLoadingNonCompliantOutputPaginatorState
    extends NonCompliantOutputPaginatorState {}

class ErrorNonCompliantOutputPaginator extends NonCompliantOutputPaginatorState {
  final String error;

  ErrorNonCompliantOutputPaginator({@required this.error})
      : super(error: error);
}

class SuccessNonCompliantOutputPaginator extends NonCompliantOutputPaginatorState {
  final List<NonCompliantOutputPaginatorModel> ncoPaginatorModelList;

  SuccessNonCompliantOutputPaginator({@required this.ncoPaginatorModelList})
      : super(ncoPaginatorList: ncoPaginatorModelList);
}

// //NonCompliantOutputId
// @immutable
// abstract class NonCompliantOutputIdState {
//   final List<NonCompliantOutputIdModel> ncoIdModelList;
//   final String error;

//   NonCompliantOutputIdState({this.ncoIdModelList, this.error});
// }

// class InitialNonCompliantOutputIdState extends NonCompliantOutputIdState {}

// class IsLoadingNonCompliantOutputId extends NonCompliantOutputIdState {}

// class ErrorNonCompliantOutputId extends NonCompliantOutputIdState {
//   final String error;

//   ErrorNonCompliantOutputId({@required this.error}) : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessNonCompliantOutputId extends NonCompliantOutputIdState {
//   final List<NonCompliantOutputIdModel> nonCompliantOutputIdModelList;

//   SuccessNonCompliantOutputId({@required this.nonCompliantOutputIdModelList})
//       : super(ncoIdModelList: nonCompliantOutputIdModelList);

//   // @override
//   // List<Object> get props => [nonCompliantOutputIdModelList];
// }
//NonCompliantOutputId
//@immutable
abstract class NonCompliantOutputIdState {
  final List<NonCompliantOutputIdModel> ncoIdModelList;
  final String error;

  NonCompliantOutputIdState({this.ncoIdModelList, this.error});
}

class InitialNonCompliantOutputIdState extends NonCompliantOutputIdState {}

class IsLoadingNonCompliantOutputId extends NonCompliantOutputIdState {}

class ErrorNonCompliantOutputId extends NonCompliantOutputIdState {
  final String error;

  ErrorNonCompliantOutputId({@required this.error}) : super(error: error);
}

class SuccessNonCompliantOutputId extends NonCompliantOutputIdState {
  final List<NonCompliantOutputIdModel> nonCompliantOutputIdModelList;

  SuccessNonCompliantOutputId({@required this.nonCompliantOutputIdModelList})
      : super(ncoIdModelList: nonCompliantOutputIdModelList);
}

// //NonCompliantOutputDD
// @immutable
// abstract class NonCompliantOutputDDState {
//   final List<NonCompliantOutputModel> ncoModelList;
//   final String error;

//   NonCompliantOutputDDState({this.ncoModelList, this.error});
// }

// class InitialNonCompliantOutputDDState extends NonCompliantOutputDDState {}

// class IsLoadingNonCompliantOutputDD extends NonCompliantOutputDDState {}

// class ErrorNonCompliantOutputDD extends NonCompliantOutputDDState {
//   final String error;

//   ErrorNonCompliantOutputDD({@required this.error}) : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessNonCompliantOutputDD extends NonCompliantOutputDDState {
//   final List<NonCompliantOutputModel> nonCompliantOutputModelList;

//   SuccessNonCompliantOutputDD({@required this.nonCompliantOutputModelList})
//       : super(ncoModelList: nonCompliantOutputModelList);

//   // @override
//   // List<Object> get props => [nonCompliantOutputModelList];
// }
//NonCompliantOutputDD
class InitialNonCompliantOutputDDState extends NonCompliantOutputState {}

class IsLoadingNonCompliantOutputDD extends NonCompliantOutputState {}

class ErrorNonCompliantOutputDD extends NonCompliantOutputState {
  final String error;

  ErrorNonCompliantOutputDD({@required this.error}) : super(error: error);
}

class SuccessNonCompliantOutputDD extends NonCompliantOutputState {
  final List<NonCompliantOutputModel> nonCompliantOutputModelList;

  SuccessNonCompliantOutputDD({@required this.nonCompliantOutputModelList})
      : super(ncoDDList: nonCompliantOutputModelList);
}

// //ContractsSNC
// class InitialContractsSNCState extends NonCompliantOutputState {}

// class IsLoadingContractsSNC extends NonCompliantOutputState {}

// class ErrorContractsSNC extends NonCompliantOutputState {
//   final String error;

//   ErrorContractsSNC({@required this.error}) : super(error: error);
// }

// class SuccessContractsSNC extends NonCompliantOutputState {
//   final List<ContractModel> contractSNCList;

//   SuccessContractsSNC({@required this.contractSNCList})
//       : super(contractSNCList: contractSNCList);
// }

// //DispositionDescription
// @immutable
// abstract class DispositionDescriptionState {
//   final DispositionDescriptionModel dispositionDescriptionModel;
//   final String error;

//   DispositionDescriptionState({this.dispositionDescriptionModel, this.error});
// }

// class InitialDispositionDescriptionState extends DispositionDescriptionState {}

// class IsLoadingDispositionDescription extends DispositionDescriptionState {}

// class ErrorDispositionDescription extends DispositionDescriptionState {
//   final String error;

//   ErrorDispositionDescription({@required this.error}) : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessDispositionDescription extends DispositionDescriptionState {
//   final DispositionDescriptionModel dispositionDescriptionModel;

//   SuccessDispositionDescription({@required this.dispositionDescriptionModel})
//       : super(dispositionDescriptionModel: dispositionDescriptionModel);

//   // @override
//   // Object get prop => [dispositionDescriptionModel];
// }
//DispositionDescription
class InitialDispositionDescriptionState extends NonCompliantOutputState {}

class IsLoadingDispositionDescription extends NonCompliantOutputState {}

class ErrorDispositionDescription extends NonCompliantOutputState {
  final String error;

  ErrorDispositionDescription({@required this.error}) : super(error: error);
}

class SuccessDispositionDescription extends NonCompliantOutputState {
  final DispositionDescriptionModel dispositionDescriptionModel;

  SuccessDispositionDescription({@required this.dispositionDescriptionModel})
      : super(dispositionDescriptionModel: dispositionDescriptionModel);
}

// //PlannedResources
@immutable
abstract class PlannedResourcesState {
  final List<PlannedResourceModel> plannedResourceModelList;
  final String error;

  PlannedResourcesState({this.plannedResourceModelList, this.error});
}

class InitialPlannedResourceState extends PlannedResourcesState {}

class IsLoadingPlannedResourceState extends PlannedResourcesState {}

class ErrorPlannedResourceState extends PlannedResourcesState {
  ErrorPlannedResourceState({@required String error}) : super(error: error);
}

class SuccessPlannedResourceState extends PlannedResourcesState {
  final List<PlannedResourceModel> modelList;

  SuccessPlannedResourceState({@required this.modelList})
      : super(plannedResourceModelList: modelList);

  // @override
  // List<WorkDropDownModel> get works => [workDropdownModelList];
}

// @immutable
// abstract class PlannedResourcesState {
//   final List<PlannedResourceModel> plannedResourceList;
//   final String error;

//   PlannedResourcesState({this.plannedResourceList, this.error});
// }

// class InitialPlannedResourcesState extends PlannedResourcesState {}

// class IsLoadingPlannedResources extends PlannedResourcesState {}

// class ErrorPlannedResources extends PlannedResourcesState {
//   final String error;

//   ErrorPlannedResources({@required this.error}) : super(error: error);

//   // @override
//   // List<Object> get props => [error];
// }

// class SuccessPlannedResources extends PlannedResourcesState {
//   final List<PlannedResourceModel> plannedModelList;

//   SuccessPlannedResources({@required this.plannedModelList})
//       : super(plannedResourceList: plannedModelList);

//   // @override
//   // List<Object> get props => [plannedModelList];
// }
//PlannedResources
class InitialPlannedResourcesState extends NonCompliantOutputState {}

class IsLoadingPlannedResources extends NonCompliantOutputState {}

class ErrorPlannedResources extends NonCompliantOutputState {
  final String error;

  ErrorPlannedResources({@required this.error}) : super(error: error);
}

class SuccessPlannedResources extends NonCompliantOutputState {
  final List<PlannedResourceModel> plannedModelList;

  SuccessPlannedResources({@required this.plannedModelList})
      : super(plannedResourceList: plannedModelList);
}
