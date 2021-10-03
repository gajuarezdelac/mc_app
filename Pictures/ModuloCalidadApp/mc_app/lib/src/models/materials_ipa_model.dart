
class MaterialsIPAModel {
  String nombreElemento;
  String juntaNo;
  String planoDetalleId;
  String trazabilidadId;
  String um;
  String tipoMaterial;
  double cantidadUsada;

  MaterialsIPAModel({
    this.nombreElemento,
    this.juntaNo,
    this.planoDetalleId,
    this.trazabilidadId,
    this.um,
    this.tipoMaterial,
    this.cantidadUsada
  });

  //Convierte un Json en un objeto de tipo NonCompliantOutputId
  factory MaterialsIPAModel.fromJson(Map<String, dynamic> json) =>
      MaterialsIPAModel(
        nombreElemento: json["NombreElemento"],
        juntaNo: json["JuntaNo"],
        planoDetalleId: json["PlanoDetalleId"],
        trazabilidadId: json["TrazabilidadId"],
        um: json["UM"],
        tipoMaterial: json["TipoMaterial"],
        cantidadUsada: json["CantidadUsada"]
      );
}
