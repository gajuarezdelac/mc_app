import 'package:flutter/material.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';

@immutable
// ignore: must_be_immutable
abstract class PanelRegisterWelderState {
  // Models
  final List<ActividadesSoldaduraModel> actividadesSoldaduraModel;
  List<UpdateWeldingDetailParams> actividadesSoldaduraUpdatearams = [];
  final RemoveMachineWeldingResponseModel removeMachineWeldingResponseModel;
  final RemoveWeldingActivityModel removeWeldingActivityModel;
  final ReleaseWeldingResponseModel releaseWeldingResponseModel;
  // final AddMachineWeldingResponseModel machineWeldingModel;

  // Params
  final String messageError;
  final int rowsAffected;

  PanelRegisterWelderState({
    this.actividadesSoldaduraModel,
    // this.actividadesSoldaduraUpdatearams = [],
    this.messageError,
    this.rowsAffected,
    this.removeMachineWeldingResponseModel,
    this.removeWeldingActivityModel,
    this.releaseWeldingResponseModel,
    // this.machineWeldingModel,
  });
}

// ignore: must_be_immutable
class InitialPanelRegisterWelderState extends PanelRegisterWelderState {}

// Panel de registro de soldadura.

// ignore: must_be_immutable
class IsLoadingPanelRegisterWelder extends PanelRegisterWelderState {}

// ignore: must_be_immutable
class ErrorPanelRegisterWelder extends PanelRegisterWelderState {
  ErrorPanelRegisterWelder({@required String errorMessage})
      : super(messageError: errorMessage);
}

// ignore: must_be_immutable
class SuccessPanelRegisterWelder extends PanelRegisterWelderState {
  SuccessPanelRegisterWelder(
      {@required List<ActividadesSoldaduraModel> actividadesSoldaduraModel})
      : super(actividadesSoldaduraModel: actividadesSoldaduraModel);
}

// Remover la maquina de soldador  --

// ignore: must_be_immutable
class IsLoadingRemoveMachineWelding extends PanelRegisterWelderState {}

// ignore: must_be_immutable
class ErrorRemoveMachineWelding extends PanelRegisterWelderState {
  ErrorRemoveMachineWelding({@required String messageError})
      : super(messageError: messageError);
}

// ignore: must_be_immutable
class SuccessRemoveMachineWelding extends PanelRegisterWelderState {
  SuccessRemoveMachineWelding(
      {@required
          RemoveMachineWeldingResponseModel removeMachineWeldingResponseModel})
      : super(
            removeMachineWeldingResponseModel:
                removeMachineWeldingResponseModel);
}

// Añadir la maquina de soldador  --

// ignore: must_be_immutable
class IsloadingAddMachineWelding extends PanelRegisterWelderState {}

// ignore: must_be_immutable
class ErrorAddMachinWelding extends PanelRegisterWelderState {
  ErrorAddMachinWelding({String messageError})
      : super(messageError: messageError);
}

// ignore: must_be_immutable
class SuccessAddMachineWelding extends PanelRegisterWelderState {
  final AddMachineWeldingResponseModel machineWeldingModel;
  SuccessAddMachineWelding({this.machineWeldingModel});
}

@immutable
// ignore: must_be_immutable
abstract class MachinesWelderState {
  // Models
  final List<ActividadesSoldaduraModel> actividadesSoldaduraModel;
  final List<UpdateWeldingDetailParams> actividadesSoldaduraUpdatearams = [];
  final RemoveMachineWeldingResponseModel removeMachineWeldingResponseModel;
  final RemoveWeldingActivityModel removeWeldingActivityModel;
  final ReleaseWeldingResponseModel releaseWeldingResponseModel;
  // final AddMachineWeldingResponseModel machineWeldingModel;

  // Params
  final String messageError;
  final int rowsAffected;

  MachinesWelderState({
    this.actividadesSoldaduraModel,
    // this.actividadesSoldaduraUpdatearams = [],
    this.messageError,
    this.rowsAffected,
    this.removeMachineWeldingResponseModel,
    this.removeWeldingActivityModel,
    this.releaseWeldingResponseModel,
    // this.machineWeldingModel,
  });
}

class InitialMachinesWelderState extends MachinesWelderState {}

// Buscamos la maquina de soldador  --
// ignore: must_be_immutable
class IsloadingFetchMachineWeldingV2 extends MachinesWelderState {}

// ignore: must_be_immutable
class ErrorFetchMachinWeldingV2 extends MachinesWelderState {
  ErrorFetchMachinWeldingV2({String messageError})
      : super(messageError: messageError);
}

// ignore: must_be_immutable
class SuccessFetchMachineWeldingV2 extends MachinesWelderState {
  final AddMachineWeldingListResponseModel machineWeldingModel;
  SuccessFetchMachineWeldingV2({this.machineWeldingModel});
}

// Insertamos la máquina de soldador  --
// ignore: must_be_immutable
class IsloadingAddMachineWeldingV2 extends MachinesWelderState {}

// ignore: must_be_immutable
class ErrorAddMachinWeldingV2 extends MachinesWelderState {
  ErrorAddMachinWeldingV2({String messageError})
      : super(messageError: messageError);
}

// ignore: must_be_immutable
class SuccessAddMachineWeldingV2 extends MachinesWelderState {
  final AddMachineWeldingResponseModel machineWeldingModel;
  SuccessAddMachineWeldingV2({this.machineWeldingModel});
}

// Remover la actividad del soldador o bien al soldador

// ignore: must_be_immutable
class IsloadingRemoveWeldingActivity extends PanelRegisterWelderState {}

// ignore: must_be_immutable
class ErrorRemoveWeldingActivity extends PanelRegisterWelderState {
  ErrorRemoveWeldingActivity({String messageError})
      : super(messageError: messageError);
}
// ignore: must_be_immutable
class SuccessRemoveWeldingActivity extends PanelRegisterWelderState {
  SuccessRemoveWeldingActivity(
      {@required RemoveWeldingActivityModel removeWeldingActivityModel})
      : super(removeWeldingActivityModel: removeWeldingActivityModel);
}

// Liberar el proceso de soldadura
// ignore: must_be_immutable
class IsloadingReleaseCaboOfWelding extends PanelRegisterWelderState {}
// ignore: must_be_immutable
class ErrorReleaseCaboOfWelding extends PanelRegisterWelderState {
  ErrorReleaseCaboOfWelding({String messageError})
      : super(messageError: messageError);
}
// ignore: must_be_immutable
class SuccessReleaseCaboOfWelding extends PanelRegisterWelderState {
  SuccessReleaseCaboOfWelding(
      {@required ReleaseWeldingResponseModel releaseWeldingResponseModel})
      : super(releaseWeldingResponseModel: releaseWeldingResponseModel);
}

// Añadir la firma del soldador
// ignore: must_be_immutable
class IsLoadingAddWelderSignature extends PanelRegisterWelderState {}
// ignore: must_be_immutable
class ErrorAddWelderSignature extends PanelRegisterWelderState {
  ErrorAddWelderSignature({@required String messageError})
      : super(messageError: messageError);
}
// ignore: must_be_immutable
class SuccessAddWelderSignature extends PanelRegisterWelderState {
  SuccessAddWelderSignature({@required int rowsAffected})
      : super(rowsAffected: rowsAffected);
}

// Actualizar el registro de la soldadura (Ficha del soldador)
// ignore: must_be_immutable
class IsLoadingUpdateRegisterWelding extends PanelRegisterWelderState {}
// ignore: must_be_immutable
class ErrorUpdateRegisterWelding extends PanelRegisterWelderState {
  ErrorUpdateRegisterWelding({@required String messageError})
      : super(messageError: messageError);
}
// ignore: must_be_immutable
class SuccessUpdateRegisterWelding extends PanelRegisterWelderState {
  SuccessUpdateRegisterWelding({@required int rowsAffected})
      : super(rowsAffected: rowsAffected);
}

// Agregar la evidencia fotografica
