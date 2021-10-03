class PlainDetailDropDownModel {
  String planoDetalleId;
  String numeroPlano;
  int revision;
  int hoja;

  PlainDetailDropDownModel({
    this.planoDetalleId,
    this.numeroPlano,
    this.revision,
    this.hoja,
  });

  //Convierte un Json en un objeto de tipo PlainDetailDropDownModel
  factory PlainDetailDropDownModel.fromJson(Map<String, dynamic> json) =>
      PlainDetailDropDownModel(
        planoDetalleId: json["PlanoDetalleId"],
        numeroPlano: json["NumeroPlano"],
        revision: json["Revision"],
        hoja: json["Hoja"],
      );
}
