/*
 * En si esto nos crea un modelo que almacenara de manera temporal los datos
 * de nuestra tabla Empleados
 */

class ActivitiesTableModel {
  String siteId;
  double propuestaTecnicaId;
  double actividadId;
  int subActividadId;
  String anexo;
  String partidaPU;
  String idPrimavera;
  String actividadCliente;
  String folio;
  String reprogramacion;
  String partida;
  String planoSubactividad;
  String propuestaTecnicaActividadesH;
  String especialidad;
  String sistema;
  String frente;
  String fechaInicio;
  String fechaFin;
  String estatus;
  bool selected;

  ActivitiesTableModel({
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
    this.anexo,
    this.partidaPU,
    this.idPrimavera,
    this.actividadCliente,
    this.folio,
    this.reprogramacion,
    this.partida,
    this.planoSubactividad,
    this.propuestaTecnicaActividadesH,
    this.especialidad,
    this.sistema,
    this.frente,
    this.fechaInicio,
    this.fechaFin,
    this.estatus,
    this.selected = false,
  });

  factory ActivitiesTableModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesTableModel(
        siteId: json["SiteId"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        anexo: json['Anexo'],
        partidaPU: json['Partida'],
        idPrimavera: json["PrimaveraId"],
        actividadCliente: json["NoActividadCliente"],
        folio: json["Folio"],
        reprogramacion: json['ReprogramacionOT'],
        partida: json['PartidaInterna'],
        planoSubactividad: json['PlanoSubActividad'],
        propuestaTecnicaActividadesH: json['PropuestaTecnicaActividadesH'],
        especialidad: json['Especialidad'],
        sistema: json['Sistema'],
        frente: json['Frente'],
        fechaInicio: json['FechaInicio'],
        fechaFin: json['FechaFin'],
        estatus: json['DescripcionCorta'],
      );
}
