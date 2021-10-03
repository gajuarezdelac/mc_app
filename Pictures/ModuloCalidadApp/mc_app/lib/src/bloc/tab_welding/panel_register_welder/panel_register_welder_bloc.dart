import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_event.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_state.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:mc_app/src/repository/welding_tab_repository.dart';

class PanelRegisterBloc
    extends Bloc<PanelRegisterWelderEvent, PanelRegisterWelderState> {
  PanelRegisterBloc() : super(InitialPanelRegisterWelderState());

  final _pnaelRegisterRepository = WeldingTabRepository();

  @override
  Stream<PanelRegisterWelderState> mapEventToState(
      PanelRegisterWelderEvent event) async* {
    // Realizamos la carga inicial del panel
    if (event is GetPanelWelder) {
      yield IsLoadingPanelRegisterWelder();

      try {
        List<ActividadesSoldaduraModel> actividadesSoldaduraModel =
            await _pnaelRegisterRepository.fetchRegisterSoldier(
                jointId: event.jointId);

        yield SuccessPanelRegisterWelder(
            actividadesSoldaduraModel: actividadesSoldaduraModel);
      } catch (e) {
        yield ErrorPanelRegisterWelder(errorMessage: e.toString());
      }
    }

    // Nos remueve la maquina de soldar
    if (event is RemoveMachineWelding) {
      yield IsLoadingRemoveMachineWelding();

      try {
        RemoveMachineWeldingResponseModel removeMachineWeldingResponseModel =
            await _pnaelRegisterRepository.removeWeldingMachine(
                folioSoldadura: event.folioSoldaduraId);

        yield SuccessRemoveMachineWelding(
            removeMachineWeldingResponseModel:
                removeMachineWeldingResponseModel);
      } catch (e) {
        yield ErrorPanelRegisterWelder(errorMessage: e.toString());
      }
    }

    // Se agrega la maquina de soldar
    if (event is AddMachineWelding) {
      yield IsloadingAddMachineWelding();

      try {
        AddMachineWeldingResponseModel machineWeldingModel =
            await _pnaelRegisterRepository.addMachineWelding(
                folioSoldadura: event.folioSoldaduraId,
                noSerie: event.noSerie,
                aceptVigencia: event.aceptVigencia);

        yield SuccessAddMachineWelding(
            machineWeldingModel: machineWeldingModel);
      } catch (e) {
        yield ErrorAddMachinWelding(messageError: e.toString());
      }
    }

    //  // Se busca la maquina de soldar
    // if (event is FetchMachineWeldingV2) {
    //   yield IsloadingFetchMachineWeldingV2();

    //   try {
    //     AddMachineWeldingListResponseModel machineWeldingModel =
    //         await _pnaelRegisterRepository.fetchMachineWeldingV2(
    //             folioSoldadura: event.folioSoldaduraId,
    //             noSerie: event.noSerie);

    //     yield SuccessFetchMachineWeldingV2(
    //         machineWeldingModel: machineWeldingModel);
    //   } catch (e) {
    //     yield ErrorFetchMachinWeldingV2(messageError: e.toString());
    //   }
    // }

    //  // Se agrega la máquina por id equipo
    // if (event is AddMachineWeldingV2) {
    //   yield IsloadingAddMachineWeldingV2();

    //   try {
    //     AddMachineWeldingResponseModel machineWeldingModel =
    //         await _pnaelRegisterRepository.addMachineWeldingV2(
    //             folioSoldadura: event.folioSoldaduraId,
    //             idEquipo: event.noSerie);

    //     yield SuccessAddMachineWeldingV2(
    //         machineWeldingModel: machineWeldingModel);
    //   } catch (e) {
    //     yield ErrorAddMachinWeldingV2(messageError: e.toString());
    //   }
    // }

    // Se remueve el soldador y asi la actividad
    if (event is RemoveWeldingActivity) {
      yield IsloadingRemoveWeldingActivity();

      try {
        RemoveWeldingActivityModel removeWeldingActivityModel =
            await _pnaelRegisterRepository.removeWelderFromWeldingActivities(
          folioSoldadura: event.folioSoldaduraId,
          cuadranteSoldaduraId: event.cuadranteSoldaduraId,
          zonaSoldaduraId: event.zonaSoldaduraId,
          registroSoldaduraId: event.registroSoldaduraId,
        );

        yield SuccessRemoveWeldingActivity(
            removeWeldingActivityModel: removeWeldingActivityModel);
      } catch (e) {
        yield ErrorRemoveWeldingActivity(messageError: e.toString());
      }
    }

    // Se libera el proceso de soldadura para
    if (event is ReleaseCaboOfWelding) {
      yield IsloadingReleaseCaboOfWelding();

      try {
        ReleaseWeldingResponseModel releaseWeldingResponseModel =
            await _pnaelRegisterRepository.releaseCaboOfWelding(
          employeeId: event.ficha,
          weldingId: event.soldaduraId,
        );

        yield SuccessReleaseCaboOfWelding(
            releaseWeldingResponseModel: releaseWeldingResponseModel);
      } catch (e) {
        yield ErrorReleaseCaboOfWelding(messageError: e.toString());
      }
    }

    // Se firma el soldador.
    if (event is AddWelderSignature) {
      yield IsLoadingAddWelderSignature();

      try {
        int rowsAffected = await _pnaelRegisterRepository.addWelderSignature(
            folioSoldadura: event.folioSoldaduraId);

        yield SuccessAddWelderSignature(rowsAffected: rowsAffected);
      } catch (e) {
        yield ErrorAddWelderSignature(messageError: e.toString());
      }
    }

    // Se actualiza el registro de la soldadura

    if (event is UpdateRegisterWelding) {
      yield IsLoadingPanelRegisterWelder();

      try {
        int rowsAffected = await _pnaelRegisterRepository.updateWeldingDetail(
            params: event.params);

        yield SuccessUpdateRegisterWelding(rowsAffected: rowsAffected);
      } catch (e) {
        yield ErrorUpdateRegisterWelding(messageError: e.toString());
      }
    }
  }
}

class MachinesWelderBloc
    extends Bloc<MachinesWelderEvent, MachinesWelderState> {
  MachinesWelderBloc() : super(InitialMachinesWelderState());

  final _pnaelRegisterRepository = WeldingTabRepository();

  @override
  Stream<MachinesWelderState> mapEventToState(
      MachinesWelderEvent event) async* {
    // Se busca la maquina de soldar
    if (event is FetchMachineWeldingV2) {
      yield IsloadingFetchMachineWeldingV2();

      try {
        AddMachineWeldingListResponseModel machineWeldingModel =
            await _pnaelRegisterRepository.fetchMachineWeldingV2(
                folioSoldadura: event.folioSoldaduraId, noSerie: event.noSerie);

        yield SuccessFetchMachineWeldingV2(
            machineWeldingModel: machineWeldingModel);
      } catch (e) {
        yield ErrorFetchMachinWeldingV2(messageError: e.toString());
      }
    }

    // Se agrega la máquina por id equipo
    if (event is AddMachineWeldingV2) {
      yield IsloadingAddMachineWeldingV2();

      try {
        AddMachineWeldingResponseModel machineWeldingModel =
            await _pnaelRegisterRepository.addMachineWeldingV2(
                folioSoldadura: event.folioSoldaduraId,
                idEquipo: event.noSerie);

        yield SuccessAddMachineWeldingV2(
            machineWeldingModel: machineWeldingModel);
      } catch (e) {
        yield ErrorAddMachinWeldingV2(messageError: e.toString());
      }
    }
  }
}
