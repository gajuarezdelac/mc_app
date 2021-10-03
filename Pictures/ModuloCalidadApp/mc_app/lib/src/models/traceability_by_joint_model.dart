class TraceabilityByJointModel {
  String idTrazabilidad;
  String material;
  double cantidadUsada;
  String uM;
  String materialDescrBreve;

  TraceabilityByJointModel({
    this.idTrazabilidad,
    this.material,
    this.cantidadUsada,
    this.uM,
    this.materialDescrBreve,
  });

  //Convierte un Json en un objeto de tipo TraceabilityByJointModel
  factory TraceabilityByJointModel.fromJson(Map<String, dynamic> json) =>
      TraceabilityByJointModel(
        idTrazabilidad: json['IdTrazabilidad'],
        material: json['Material'],
        cantidadUsada: json['CantidadUsada'],
        uM: json['UM'],
        materialDescrBreve: json['MaterialDescrBreve'],
      );
}

class WorkTraceability {
  String obraId;
  String nombre;
  String ot;

  WorkTraceability({this.obraId, this.nombre, this.ot});

  //Convierte un Json en un objeto de tipo TraceabilityByJointModel
  factory WorkTraceability.fromJson(Map<String, dynamic> json) =>
      WorkTraceability(
          obraId: json['ObraId'], nombre: json['Nombre'], ot: json['OT']);
}
