import 'package:flutter/cupertino.dart';

@immutable
abstract class TableActivityEvent {
  final String contratoId;
  final String obraId;
  final String folioId;
  final String especialidad;
  final String fechaInicio;
  final String reprogramacionOT;
  final String fechaFin;
  final int frenteId;
  final String sistema;
  final String plano;
  final String anexo;
  final String partidaPU;
  final String primaveraId;
  final String noActividadCliente;
  final String estatusId;
  final String partidaFilter;
  // final Final String id;

  TableActivityEvent({
    this.contratoId,
    this.obraId,
    this.folioId,
    this.especialidad,
    this.reprogramacionOT,
    this.sistema,
    this.frenteId,
    this.plano,
    this.anexo,
    this.partidaPU,
    this.primaveraId,
    this.noActividadCliente,
    this.estatusId,
    this.fechaInicio,
    this.fechaFin,
    this.partidaFilter,
  });
}

// los eventos se entienden de la clase abstracta.
class GetTableActivity extends TableActivityEvent {
  GetTableActivity({
    @required String contractId,
    @required String folioId,
    @required String obraId,
    @required String reprogramacionOT,
    @required String especialidad,
    @required String sistema,
    @required int frenteId,
    @required String plano,
    @required String anexo,
    @required String partidaPU,
    @required String primaveraId,
    @required String noActividadCliente,
    @required String estatusId,
    @required String fechaInicio,
    @required String fechaFin,
    @required String partidaFilter,
  }) : super(
          contratoId: contractId,
          folioId: folioId,
          obraId: obraId,
          reprogramacionOT: reprogramacionOT,
          especialidad: especialidad,
          sistema: sistema,
          frenteId: frenteId,
          plano: plano,
          anexo: anexo,
          partidaPU: partidaPU,
          primaveraId: primaveraId,
          noActividadCliente: noActividadCliente,
          estatusId: estatusId,
          fechaFin: fechaFin,
          fechaInicio: fechaInicio,
          partidaFilter: partidaFilter,
        );
}
