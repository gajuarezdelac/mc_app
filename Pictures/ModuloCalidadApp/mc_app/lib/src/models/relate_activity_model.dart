class RelateActivityModel {
  String siteId;
  String propuestaTecnicaId;
  String actividadId;
  String subActividadId;
  String juntaId;

  RelateActivityModel({
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
    this.juntaId,
  });

  factory RelateActivityModel.fromMap(Map<String, dynamic> json) =>
      new RelateActivityModel(
        siteId: json["SiteId"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        juntaId: json["JuntaId"],
      );

  RelateActivityModel.fromJson(Map<String, dynamic> map) {
    this.siteId = map['SiteId'];
    this.propuestaTecnicaId = map['PropuestaTecnicaId'];
    this.actividadId = map["ActividadId"];
    this.subActividadId = map["SubActividadId"];
    this.juntaId = map["JuntaId"];
  }

  Map<String, dynamic> toJson() => {
        "SiteId": siteId,
        "PropuestaTecnicaId": propuestaTecnicaId,
        "ActividadId": actividadId,
        "SubActividadId": subActividadId,
        "JuntaId": juntaId,
      };
}
