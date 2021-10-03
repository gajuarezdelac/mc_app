class ActivityJointModel {
  String partidaPU;
  String primaveraId;
  String actividadCliente;
  String folio;
  String siteId;
  double propuestaTecnicaId;
  double actividadId;
  int subActividadId;
  String partidaInterna;

  ActivityJointModel({
    this.partidaPU,
    this.primaveraId,
    this.actividadCliente,
    this.folio,
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
    this.partidaInterna,
  });

  factory ActivityJointModel.fromJson(Map<String, dynamic> json) =>
      ActivityJointModel(
        partidaPU: json["PartidaPU"],
        primaveraId: json["PrimaveraId"],
        actividadCliente: json["ActividadCliente"],
        folio: json["Folio"],
        siteId: json["SiteId"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        partidaInterna: json["partidaInterna"],
      );
}
