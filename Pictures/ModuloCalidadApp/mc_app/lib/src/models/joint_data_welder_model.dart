class JointDataWelderModel {
  String siteId;
  String tipoJuntaId;
  String wPSId;
  String soldaduraId;
  String avanceJuntaId;

  JointDataWelderModel({
    this.siteId,
    this.tipoJuntaId,
    this.wPSId,
    this.soldaduraId,
    this.avanceJuntaId,
  });

  factory JointDataWelderModel.fromJson(Map<String, dynamic> json) =>
      JointDataWelderModel(
        siteId: json['SiteId'],
        tipoJuntaId: json['TipoJuntaId'],
        wPSId: json['WPSId'],
        soldaduraId: json['SoldaduraId'],
        avanceJuntaId: json['AvanceJuntaId'],
      );
}
