class WorkDropDownModel {
  String obraId;
  String oT;
  String nombre;

  WorkDropDownModel({this.obraId, this.oT, this.nombre});

  //Convierte un Json en un objeto de tipo ObraDropDownModel
  factory WorkDropDownModel.fromJson(Map<String, dynamic> json) =>
      WorkDropDownModel(
        obraId: json["ObraId"],
        oT: json["OT"],
        nombre: json["Nombre"],
      );
}
