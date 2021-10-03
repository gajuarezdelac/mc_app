class TraceabilityModel {
  String idTrazabilidad;
  String material;
  double cantidad;
  String uM;
  String materialDescrBreve;

  TraceabilityModel({
    this.idTrazabilidad,
    this.material,
    this.cantidad,
    this.uM,
    this.materialDescrBreve,
  });

  //Convierte un Json en un objeto de tipo TraceabilityModel
  factory TraceabilityModel.fromJson(Map<String, dynamic> json) =>
      TraceabilityModel(
        idTrazabilidad: json['IdTrazabilidad'],
        material: json['Material'],
        cantidad: json['Cantidad'],
        uM: json['UM'],
        materialDescrBreve: json['MaterialDescrBreve'],
      );
}
