
class MaterialStagesDIPAModel {
  String noRegistro;
  int materialIdIPA;
  int orden;
  String fechaEvaluacion;
  String fechaPropuesta;
  String norma;
  double espesor;
  int completado;

  MaterialStagesDIPAModel({
    this.noRegistro,
    this.materialIdIPA,
    this.orden,
    this.fechaEvaluacion,
    this.fechaPropuesta,
    this.norma,
    this.espesor,
    this.completado
  });

  //Convierte un Json en un objeto de tipo NonCompliantOutputId
  factory MaterialStagesDIPAModel.fromJson(Map<String, dynamic> json) =>
      MaterialStagesDIPAModel(
        noRegistro: json["NoRegistro"],
        materialIdIPA: json["MaterialIdIPA"],
        orden: json["Orden"],
        fechaEvaluacion: json["FechaEvaluacion"],
        fechaPropuesta: json["FechaPropuesta"],
        norma: json["Norma"],
        espesor: json["Espesor"],
        completado: json["Completado"]
      );
}
