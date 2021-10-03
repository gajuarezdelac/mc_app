import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';

@immutable
abstract class PanelRegisterWelderEvent {
  final String jointId; // Get Register welding
  final String folioSoldaduraId; // Remove machine welding
  final String noSerie;
  final String registroSoldaduraId;
  final String cuadranteSoldaduraId;
  final String zonaSoldaduraId;
  final String soldaduraId;
  final int ficha;
  final String structure;
  final int aceptVigencia;

  // Models

  final List<UpdateWeldingDetailParams> params;

  PanelRegisterWelderEvent(
      {this.jointId,
      this.folioSoldaduraId,
      this.noSerie,
      this.registroSoldaduraId,
      this.cuadranteSoldaduraId,
      this.zonaSoldaduraId,
      this.soldaduraId,
      this.ficha,
      this.structure,
      this.params,
      this.aceptVigencia});
}

// los eventos se entienden de la clase abstracta.
class GetPanelWelder extends PanelRegisterWelderEvent {
  GetPanelWelder({
    @required String jointId,
  }) : super(jointId: jointId);
}

// Añadimos la maquina de soldar

class AddMachineWelding extends PanelRegisterWelderEvent {
  AddMachineWelding({
    @required String noSerie,
    @required String folioSoldaduraId,
    @required int aceptVigencia,
  }) : super(
            noSerie: noSerie,
            folioSoldaduraId: folioSoldaduraId,
            aceptVigencia: aceptVigencia);
}

@immutable
abstract class MachinesWelderEvent {
  final String jointId; // Get Register welding
  final String folioSoldaduraId; // Remove machine welding
  final String noSerie;
  final String registroSoldaduraId;
  final String cuadranteSoldaduraId;
  final String zonaSoldaduraId;
  final String soldaduraId;
  final int ficha;
  final String structure;
  final int aceptVigencia;

  // Models

  final List<UpdateWeldingDetailParams> params;

  MachinesWelderEvent(
      {this.jointId,
      this.folioSoldaduraId,
      this.noSerie,
      this.registroSoldaduraId,
      this.cuadranteSoldaduraId,
      this.zonaSoldaduraId,
      this.soldaduraId,
      this.ficha,
      this.structure,
      this.params,
      this.aceptVigencia});
}

// Buscamos la maquina de soldar
class FetchMachineWeldingV2 extends MachinesWelderEvent {
  FetchMachineWeldingV2({
    @required String noSerie,
    @required String folioSoldaduraId,
  }) : super(
            noSerie: noSerie,
            folioSoldaduraId: folioSoldaduraId);
}

// Insertamos la maquina de soldar
class AddMachineWeldingV2 extends MachinesWelderEvent {
  AddMachineWeldingV2({
    @required String idEquipo,
    @required String folioSoldaduraId,
  }) : super(
            noSerie: idEquipo,
            folioSoldaduraId: folioSoldaduraId);
}

// Removemos la maquina de soldar
class RemoveMachineWelding extends PanelRegisterWelderEvent {
  RemoveMachineWelding({
    @required String folioSoldaduraId,
  }) : super(folioSoldaduraId: folioSoldaduraId);
}

// Removemos al soldador
class RemoveWeldingActivity extends PanelRegisterWelderEvent {
  RemoveWeldingActivity({
    @required String folioSoldaduraId,
    @required String registroSoldaduraId,
    @required String cuadranteSoldaduraId,
    @required String zonaSoldaduraId,
  }) : super(
          folioSoldaduraId: folioSoldaduraId,
          registroSoldaduraId: registroSoldaduraId,
          cuadranteSoldaduraId: cuadranteSoldaduraId,
          zonaSoldaduraId: zonaSoldaduraId,
        );
}

// Liberar la soldadura para inspección visual
class ReleaseCaboOfWelding extends PanelRegisterWelderEvent {
  ReleaseCaboOfWelding({int ficha, String soldaduraId})
      : super(soldaduraId: soldaduraId, ficha: ficha);
}

// Firmamos el soldador
class AddWelderSignature extends PanelRegisterWelderEvent {
  AddWelderSignature({String folioSoldaduraId})
      : super(folioSoldaduraId: folioSoldaduraId);
}

// Actualizamos el registro de la soldadura
class UpdateRegisterWelding extends PanelRegisterWelderEvent {
  UpdateRegisterWelding({List<UpdateWeldingDetailParams> params})
      : super(params: params);
}
