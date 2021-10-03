class InitialDataJointModel {
  String siteId;
  String juntaId;
  String juntaNombre;
  String wps;
  String diametro;
  String espesor;
  String tipoJunta;
  String spool;
  String planoDetalle;
  double propuestaTecnicaId;
  double actividadId;
  int subActividadId;
  bool confomadoLiberado;
  String conformadoNorma;
  String conformadoId;
  int consecutivo;
  String fechaFin;
  String fechaInicio;
  int caboId;
  int inspectorCCAId;
  String observaciones;
  String motivoFN;
  String soldaduraNorma;
  int soldaduraLiberada;

  String soldaduraId;
  int soldaduraConsecutivo;
  int soldaduraCaboId;
  int soldaduraInspectorCCAId;
  String soldaduraCambioMaterial;
  String criteriosAceptacionId;

  InitialDataJointModel(
      {this.siteId,
      this.juntaId,
      this.juntaNombre,
      this.wps,
      this.diametro,
      this.espesor,
      this.tipoJunta,
      this.spool,
      this.planoDetalle,
      this.propuestaTecnicaId,
      this.actividadId,
      this.subActividadId,
      this.confomadoLiberado,
      this.conformadoNorma,
      this.conformadoId,
      this.consecutivo,
      this.fechaFin,
      this.fechaInicio,
      this.caboId,
      this.inspectorCCAId,
      this.observaciones,
      this.motivoFN,
      this.soldaduraNorma,
      this.soldaduraLiberada,
      this.soldaduraCaboId,
      this.soldaduraCambioMaterial,
      this.soldaduraConsecutivo,
      this.soldaduraId,
      this.soldaduraInspectorCCAId,
      this.criteriosAceptacionId});

  factory InitialDataJointModel.fromJson(Map<String, dynamic> json) =>
      InitialDataJointModel(
        siteId: json["SiteId"],
        juntaId: json["JuntaId"],
        juntaNombre: json["Nombre"],
        wps: json["WPS"],
        diametro: json["Diametro"],
        espesor: json["Espesor"],
        tipoJunta: json["Tipo"],
        spool: json["Spool"],
        planoDetalle: json["PlanoDetalle"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        confomadoLiberado: json["ConformadoLiberado"] == 1 ? true : false,
        conformadoNorma: json["ConformadoNorma"],
        conformadoId: json["ConformadoId"],
        consecutivo: json["Consecutivo"],
        fechaFin: json["FechaFin"],
        fechaInicio: json["FechaInicio"],
        caboId: json["CaboId"],
        inspectorCCAId: json["InspectorCCAId"],
        observaciones: json["Observaciones"],
        motivoFN: json["MotivoFN"],
        soldaduraNorma: json["SoldaduraNorma"],
        soldaduraLiberada: json["SoldaduraLiberada"],
        soldaduraCaboId: json["SoldadorCaboId"],
        soldaduraCambioMaterial: json["SoldaduraCambioMaterial"],
        soldaduraId: json["SoldaduraId"],
        soldaduraConsecutivo: json["SoldaduraConsecutivo"],
        soldaduraInspectorCCAId: json["SoldaduraInspectorCCAId"],
        criteriosAceptacionId: json["CriteriosAceptacionId"],
      );
}
