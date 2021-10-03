import 'package:flutter/cupertino.dart';

@immutable
abstract class ListMaterialsEvent {
  final String noPlanInspeccion;
  final String siteId;
  final dynamic propuestaTecnicaId;
  final dynamic actividadId;
  final dynamic subActividadId;
  final dynamic reprogramacionOTId;

  final String materialId;
  final String idTrazabilidad;
  final int resultado;
  final int incluirReporte;
  final String comentarios;

  ListMaterialsEvent({
    this.noPlanInspeccion,
    this.siteId,
    this.actividadId,
    this.propuestaTecnicaId,
    this.reprogramacionOTId,
    this.subActividadId,
    this.materialId,
    this.idTrazabilidad,
    this.comentarios,
    this.resultado,
    this.incluirReporte,
  });
}

class GetTableMaterials extends ListMaterialsEvent {
  GetTableMaterials({
    @required String noPlanInspeccion,
    @required String siteId,
    @required dynamic propuestaTecnicaId,
    @required dynamic actividadId,
    @required dynamic subActividadId,
    @required dynamic reprogramacionOTId,
  }) : super(
          noPlanInspeccion: noPlanInspeccion,
          siteId: siteId,
          propuestaTecnicaId: propuestaTecnicaId,
          actividadId: actividadId,
          subActividadId: subActividadId,
          reprogramacionOTId: reprogramacionOTId,
        );
}

class UpdateReporteIP extends ListMaterialsEvent {
  UpdateReporteIP({
    @required String noPlanInspection,
    @required String siteId,
    @required dynamic propuestaTecnicaId,
    @required dynamic actividadId,
    @required dynamic subActividadId,
    @required dynamic reprogramacionOTId,
    @required String materialId,
    @required String idTrazabilidad,
    @required int resultado,
    @required int incluirReporte,
    @required String comentarios,
  }) : super(
          noPlanInspeccion: noPlanInspection,
          siteId: siteId,
          propuestaTecnicaId: propuestaTecnicaId,
          actividadId: actividadId,
          subActividadId: subActividadId,
          reprogramacionOTId: reprogramacionOTId,
          materialId: materialId,
          idTrazabilidad: idTrazabilidad,
          resultado: resultado,
          incluirReporte: incluirReporte,
          comentarios: comentarios,
        );
}
